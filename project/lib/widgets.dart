import 'package:flutter/material.dart';
import 'style.dart';

import 'pages/dashboard.dart';
import 'pages/employees_page.dart';
import 'pages/vehicles_page.dart';
import 'pages/returns_page.dart';
import 'pages/accidents_page.dart';
import 'pages/maintenance_page.dart';
import 'pages/requests_page.dart';
import 'pages/finance_page.dart';
import 'pages/profile_page.dart';
import 'pages/login_page.dart';

class AppShell extends StatefulWidget {
  const AppShell({super.key});

  @override
  State<AppShell> createState() => _AppShellState();
}

class _AppShellState extends State<AppShell> {
  int selectedIndex = 0;

  final List<String> titles = const [
    'Dashboard',
    'Employees',
    'Vehicles',
    'Car Returns',
    'Accidents',
    'Maintenance',
    'Car Requests',
    'Finance',
    'Profile',
  ];

  final List<IconData> icons = const [
    Icons.dashboard_rounded,
    Icons.people_alt_rounded,
    Icons.directions_car_rounded,
    Icons.assignment_return_rounded,
    Icons.car_crash_rounded,
    Icons.build_rounded,
    Icons.assignment_rounded,
    Icons.account_balance_wallet_rounded,
    Icons.person_rounded,
  ];

  final List<Widget> pages = const [
    DashboardPage(),
    EmployeesPage(),
    VehiclesPage(),
    ReturnsPage(),
    AccidentsPage(),
    MaintenancePage(),
    RequestsPage(),
    FinancePage(),
    ProfilePage(),
  ];

  void selectPage(int index) {
    setState(() {
      selectedIndex = index;
    });

    if (Scaffold.of(context).isDrawerOpen) {
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDesktop = MediaQuery.of(context).size.width >= 850;

    return Scaffold(
      drawer: isDesktop ? null : Drawer(child: sidebar()),
      body: Row(
        children: [
          if (isDesktop) sidebar(),
          Expanded(
            child: Column(
              children: [
                topBar(isDesktop),
                Expanded(
                  child: IndexedStack(
                    index: selectedIndex,
                    children: pages,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget sidebar() {
    return Container(
      width: 245,
      color: AppColors.darkBackground,
      child: Column(
        children: [
          const SizedBox(height: 28),

          const Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.directions_car_filled_rounded,
                color: AppColors.primary,
                size: 32,
              ),
              SizedBox(width: 10),
              Text(
                'FleetOps',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),

          const SizedBox(height: 35),

          Expanded(
            child: ListView.builder(
              itemCount: titles.length,
              itemBuilder: (context, index) {
                final selected = selectedIndex == index;

                return Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 3,
                  ),
                  child: ListTile(
                    selected: selected,
                    selectedTileColor: AppColors.darkGreen,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    leading: Icon(
                      icons[index],
                      color: selected
                          ? AppColors.primary
                          : Colors.white70,
                    ),
                    title: Text(
                      titles[index],
                      style: TextStyle(
                        color: selected
                            ? Colors.white
                            : Colors.white70,
                        fontWeight: selected
                            ? FontWeight.bold
                            : FontWeight.normal,
                      ),
                    ),
                    onTap: () {
                      setState(() {
                        selectedIndex = index;
                      });

                      if (MediaQuery.of(context).size.width < 850) {
                        Navigator.pop(context);
                      }
                    },
                  ),
                );
              },
            ),
          ),

          Padding(
            padding: const EdgeInsets.all(15),
            child: ListTile(
              leading: const Icon(
                Icons.logout,
                color: Colors.white70,
              ),
              title: const Text(
                'Sign Out',
                style: TextStyle(color: Colors.white70),
              ),
              onTap: () {
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const LoginPage(),
                  ),
                  (route) => false,
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget topBar(bool isDesktop) {
    return Container(
      height: 75,
      padding: const EdgeInsets.symmetric(horizontal: 22),
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(
          bottom: BorderSide(color: AppColors.border),
        ),
      ),
      child: Row(
        children: [
          if (!isDesktop)
            Builder(
              builder: (context) => IconButton(
                icon: const Icon(Icons.menu),
                onPressed: () {
                  Scaffold.of(context).openDrawer();
                },
              ),
            ),

          Text(
            titles[selectedIndex],
            style: const TextStyle(
              fontSize: 21,
              fontWeight: FontWeight.bold,
              color: AppColors.text,
            ),
          ),

          const Spacer(),

          IconButton(
            tooltip: 'Notifications',
            icon: const Icon(Icons.notifications_none_rounded),
            onPressed: () {
              showDialog(
                context: context,
                builder: (_) => AlertDialog(
                  title: const Text('Notifications'),
                  content: const Text('You are all caught up.'),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: const Text('Close'),
                    ),
                  ],
                ),
              );
            },
          ),

          const SizedBox(width: 10),

          const CircleAvatar(
            backgroundColor: AppColors.darkGreen,
            child: Icon(Icons.person, color: Colors.white),
          ),

          const SizedBox(width: 10),

          const Text(
            'Admin',
            style: TextStyle(fontWeight: FontWeight.w600),
          ),
        ],
      ),
    );
  }
}

class StatCard extends StatelessWidget {
  final String title;
  final String value;
  final IconData icon;
  final Color color;
  final String subtitle;

  const StatCard({
    super.key,
    required this.title,
    required this.value,
    required this.icon,
    required this.color,
    this.subtitle = 'Current fleet overview',
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.12),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(icon, color: color),
              ),
              const Spacer(),
              const Icon(Icons.more_horiz, color: AppColors.grey),
            ],
          ),

          const SizedBox(height: 18),

          Text(
            title,
            style: const TextStyle(color: AppColors.grey),
          ),

          const SizedBox(height: 5),

          Text(
            value,
            style: const TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
              color: AppColors.text,
            ),
          ),

          const SizedBox(height: 8),

          Text(
            subtitle,
            style: const TextStyle(
              fontSize: 12,
              color: AppColors.grey,
            ),
          ),
        ],
      ),
    );
  }
}

class ManagementPage extends StatefulWidget {
  final String title;
  final String subtitle;
  final List<String> columns;
  final List<List<String>> initialRows;
  final String addButtonText;

  const ManagementPage({
    super.key,
    required this.title,
    required this.subtitle,
    required this.columns,
    required this.initialRows,
    this.addButtonText = 'Add New',
  });

  @override
  State<ManagementPage> createState() => _ManagementPageState();
}

class _ManagementPageState extends State<ManagementPage> {
  late List<List<String>> rows;
  String searchText = '';

  @override
  void initState() {
    super.initState();
    rows = widget.initialRows.map((row) => List<String>.from(row)).toList();
  }

  void addRow() {
    final controllers = List.generate(
      widget.columns.length,
      (_) => TextEditingController(),
    );

    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: Text(widget.addButtonText),
        content: SizedBox(
          width: 400,
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: List.generate(
                widget.columns.length,
                (index) => Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: TextField(
                    controller: controllers[index],
                    decoration: InputDecoration(
                      labelText: widget.columns[index],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              setState(() {
                rows.add(
                  controllers.map((controller) {
                    return controller.text.trim().isEmpty
                        ? '-'
                        : controller.text.trim();
                  }).toList(),
                );
              });

              Navigator.pop(dialogContext);
            },
            child: const Text('Save'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final filteredRows = rows.where((row) {
      return row.join(' ').toLowerCase().contains(
        searchText.toLowerCase(),
      );
    }).toList();

    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            widget.subtitle,
            style: const TextStyle(color: AppColors.grey),
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
                    hintText: 'Search...',
                    prefixIcon: Icon(Icons.search),
                  ),
                ),
              ),

              const SizedBox(width: 12),

              ElevatedButton.icon(
                onPressed: addRow,
                icon: const Icon(Icons.add),
                label: Text(widget.addButtonText),
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
              child: ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: SingleChildScrollView(
                    child: DataTable(
                      columns: [
                        ...widget.columns.map(
                          (column) => DataColumn(
                            label: Text(
                              column,
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                        const DataColumn(label: Text('Action')),
                      ],
                      rows: filteredRows.map((row) {
                        return DataRow(
                          cells: [
                            ...row.map(
                              (value) => DataCell(Text(value)),
                            ),
                            DataCell(
                              IconButton(
                                tooltip: 'Delete',
                                icon: const Icon(
                                  Icons.delete_outline,
                                  color: AppColors.red,
                                ),
                                onPressed: () {
                                  setState(() {
                                    rows.remove(row);
                                  });
                                },
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

          Text(
            '${filteredRows.length} records found',
            style: const TextStyle(color: AppColors.grey),
          ),
        ],
      ),
    );
  }
}