import 'package:flutter/material.dart';
import '../widgets.dart';

class EmployeesPage extends StatelessWidget {
  const EmployeesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const ManagementPage(
      title: 'Employees',
      subtitle: 'Manage employee profiles and vehicle assignments.',
      addButtonText: 'Add Employee',
      columns: [
        'Name',
        'Department',
        'Role',
        'Vehicle',
        'Status',
      ],
      initialRows: [
        ['Muhammad Ali', 'IT', 'Employee', 'Toyota Corolla', 'Active'],
        ['Ayesha Khan', 'Finance', 'Manager', 'Honda Civic', 'Active'],
        ['Ahmed Raza', 'Operations', 'Employee', '-', 'Active'],
        ['Sara Ahmed', 'HR', 'Employee', 'Suzuki Swift', 'Inactive'],
      ],
    );
  }
}