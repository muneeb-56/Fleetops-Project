
import 'package:flutter/material.dart';

import '../data/database_helper.dart';
import '../data/employee_model.dart';
import '../style.dart';

class EmployeesPage extends StatefulWidget {
  const EmployeesPage({super.key});

  @override
  State<EmployeesPage> createState() => _EmployeesPageState();
}

class _EmployeesPageState extends State<EmployeesPage> {
  final DatabaseHelper dbHelper = DatabaseHelper.instance;

  List<Employee> employees = [];

  bool isLoading = true;
  String searchText = '';

  @override
  void initState() {
    super.initState();
    loadEmployees();
  }

  // READ: Load records from SQLite
  Future<void> loadEmployees() async {
    setState(() {
      isLoading = true;
    });

    try {
      final data = await dbHelper.getEmployees();

      if (!mounted) return;

      setState(() {
        employees = data;
        isLoading = false;
      });
    } catch (e) {
      if (!mounted) return;

      setState(() {
        isLoading = false;
      });

      showMessage('Database error: $e');
    }
  }

  void showMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  // CREATE / UPDATE: Open employee form
  Future<void> showEmployeeDialog({Employee? employee}) async {
    final nameController = TextEditingController(
      text: employee?.name ?? '',
    );

    final departmentController = TextEditingController(
      text: employee?.department ?? '',
    );

    final roleController = TextEditingController(
      text: employee?.role ?? '',
    );

    final vehicleController = TextEditingController(
      text: employee?.vehicle ?? '',
    );

    String status = employee?.status ?? 'Active';

    final formKey = GlobalKey<FormState>();

    final result = await showDialog<Employee>(
      context: context,
      builder: (dialogContext) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            return AlertDialog(
              title: Text(
                employee == null
                    ? 'Add Employee'
                    : 'Edit Employee',
              ),
              content: SizedBox(
                width: 420,
                child: SingleChildScrollView(
                  child: Form(
                    key: formKey,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        buildField(
                          nameController,
                          'Employee Name',
                        ),
                        buildField(
                          departmentController,
                          'Department',
                        ),
                        buildField(
                          roleController,
                          'Role',
                        ),
                        buildField(
                          vehicleController,
                          'Assigned Vehicle',
                        ),

                        const SizedBox(height: 12),

                        DropdownButtonFormField<String>(
                          value: status,
                          decoration: const InputDecoration(
                            labelText: 'Status',
                          ),
                          items: const [
                            DropdownMenuItem(
                              value: 'Active',
                              child: Text('Active'),
                            ),
                            DropdownMenuItem(
                              value: 'Inactive',
                              child: Text('Inactive'),
                            ),
                          ],
                          onChanged: (value) {
                            if (value != null) {
                              setDialogState(() {
                                status = value;
                              });
                            }
                          },
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.pop(dialogContext);
                  },
                  child: const Text('Cancel'),
                ),

                ElevatedButton(
                  onPressed: () {
                    if (formKey.currentState!.validate()) {
                      Navigator.pop(
                        dialogContext,
                        Employee(
                          id: employee?.id,
                          name: nameController.text.trim(),
                          department: departmentController.text.trim(),
                          role: roleController.text.trim(),
                          vehicle: vehicleController.text.trim().isEmpty
                              ? '-'
                              : vehicleController.text.trim(),
                          status: status,
                        ),
                      );
                    }
                  },
                  child: const Text('Save'),
                ),
              ],
            );
          },
        );
      },
    );

    nameController.dispose();
    departmentController.dispose();
    roleController.dispose();
    vehicleController.dispose();

    if (result == null) return;

    try {
      if (employee == null) {
        await dbHelper.insertEmployee(result);
        showMessage('Employee added successfully!');
      } else {
        await dbHelper.updateEmployee(result);
        showMessage('Employee updated successfully!');
      }

      await loadEmployees();
    } catch (e) {
      showMessage('Operation failed: $e');
    }
  }

  // Reusable text field
  Widget buildField(
    TextEditingController controller,
    String label,
  ) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: TextFormField(
        controller: controller,
        decoration: InputDecoration(
          labelText: label,
        ),
        validator: (value) {
          if (value == null || value.trim().isEmpty) {
            return '$label is required';
          }

          return null;
        },
      ),
    );
  }

  // DELETE: Remove employee
  Future<void> deleteEmployee(Employee employee) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: const Text('Delete Employee?'),
          content: Text(
            'Are you sure you want to delete ${employee.name}?',
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(dialogContext, false);
              },
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.red,
              ),
              onPressed: () {
                Navigator.pop(dialogContext, true);
              },
              child: const Text('Delete'),
            ),
          ],
        );
      },
    );

    if (confirm != true) return;

    try {
      await dbHelper.deleteEmployee(employee.id!);

      await loadEmployees();

      showMessage('Employee deleted successfully!');
    } catch (e) {
      showMessage('Delete failed: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    final filteredEmployees = employees.where((employee) {
      final data = [
        employee.name,
        employee.department,
        employee.role,
        employee.vehicle,
        employee.status,
      ].join(' ').toLowerCase();

      return data.contains(searchText.toLowerCase());
    }).toList();

    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Manage employee profiles and vehicle assignments.',
            style: TextStyle(color: AppColors.grey),
          ),

          const SizedBox(height: 20),

          Row(
            children: [
              Expanded(
                child: TextField(
                  onChanged: (value) {
                    setState(() {
                      searchText = value;
                    });
                  },
                  decoration: const InputDecoration(
                    hintText: 'Search employees...',
                    prefixIcon: Icon(Icons.search),
                  ),
                ),
              ),

              const SizedBox(width: 12),

              ElevatedButton.icon(
                onPressed: () => showEmployeeDialog(),
                icon: const Icon(Icons.add),
                label: const Text('Add Employee'),
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 18,
                    vertical: 18,
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 22),

          Expanded(
            child: Container(
              width: double.infinity,
              decoration: BoxDecoration(
                color: Colors.white,
                border: Border.all(color: AppColors.border),
                borderRadius: BorderRadius.circular(16),
              ),
              child: isLoading
                  ? const Center(
                      child: CircularProgressIndicator(),
                    )
                  : filteredEmployees.isEmpty
                      ? const Center(
                          child: Text('No employees found.'),
                        )
                      : ClipRRect(
                          borderRadius: BorderRadius.circular(16),
                          child: SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            child: SingleChildScrollView(
                              child: DataTable(
                                columns: const [
                                  DataColumn(label: Text('Name')),
                                  DataColumn(label: Text('Department')),
                                  DataColumn(label: Text('Role')),
                                  DataColumn(label: Text('Vehicle')),
                                  DataColumn(label: Text('Status')),
                                  DataColumn(label: Text('Actions')),
                                ],
                                rows: filteredEmployees.map((employee) {
                                  return DataRow(
                                    cells: [
                                      DataCell(Text(employee.name)),
                                      DataCell(Text(employee.department)),
                                      DataCell(Text(employee.role)),
                                      DataCell(Text(employee.vehicle)),
                                      DataCell(
                                        Text(
                                          employee.status,
                                          style: TextStyle(
                                            color: employee.status == 'Active'
                                                ? AppColors.primary
                                                : AppColors.red,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                      ),
                                      DataCell(
                                        Row(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            IconButton(
                                              tooltip: 'Edit',
                                              icon: const Icon(
                                                Icons.edit_outlined,
                                                color: AppColors.blue,
                                              ),
                                              onPressed: () {
                                                showEmployeeDialog(
                                                  employee: employee,
                                                );
                                              },
                                            ),
                                            IconButton(
                                              tooltip: 'Delete',
                                              icon: const Icon(
                                                Icons.delete_outline,
                                                color: AppColors.red,
                                              ),
                                              onPressed: () {
                                                deleteEmployee(employee);
                                              },
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  );
                                }).toList(),
                              ),
                            ),
                          ),
                        ),
            ),
          ),

          const SizedBox(height: 12),

          Row(
            children: [
              Text(
                '${filteredEmployees.length} records found',
                style: const TextStyle(color: AppColors.grey),
              ),
              const Spacer(),
              IconButton(
                tooltip: 'Refresh records',
                onPressed: loadEmployees,
                icon: const Icon(Icons.refresh),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
