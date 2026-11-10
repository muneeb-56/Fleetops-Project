
import 'package:flutter/material.dart';
import '../style.dart';
import '../widgets.dart';

class DashboardPage extends StatelessWidget {
  const DashboardPage({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // HEADER
          const Text(
            'Fleet Overview',
            style: TextStyle(
              fontSize: 27,
              fontWeight: FontWeight.bold,
              color: AppColors.darkBackground,
            ),
          ),
          const SizedBox(height: 6),
          const Text(
            'Monitor your fleet, employees and operations.',
            style: TextStyle(color: AppColors.grey),
          ),

          const SizedBox(height: 25),

          // STATISTICS
          LayoutBuilder(
            builder: (context, constraints) {
              final count = constraints.maxWidth > 1100
                  ? 5
                  : constraints.maxWidth > 650
                      ? 3
                      : 2;

              final width =
                  (constraints.maxWidth - (count - 1) * 15) / count;

              final stats = [
                ['Total Vehicles', '248', Icons.directions_car, AppColors.primary],
                ['Available', '64', Icons.check_circle, AppColors.blue],
                ['Assigned', '162', Icons.assignment_ind, AppColors.green],
                ['Employees', '186', Icons.people, AppColors.mutedGreen],
                ['Accidents', '08', Icons.car_crash, AppColors.red],
                ['Maintenance', '22', Icons.build, AppColors.orange],
                ['Pending Requests', '14', Icons.pending_actions, AppColors.primary],
                ['Emergency Cases', '03', Icons.warning_amber, AppColors.red],
                ['Total Drivers', '95', Icons.person_pin, AppColors.blue],
                ['Monthly Expenses', 'Rs. 8.4M', Icons.account_balance_wallet, AppColors.darkGreen],
              ];

              return Wrap(
                spacing: 15,
                runSpacing: 15,
                children: stats.map((stat) {
                  return SizedBox(
                    width: width,
                    child: StatCard(
                      title: stat[0] as String,
                      value: stat[1] as String,
                      icon: stat[2] as IconData,
                      color: stat[3] as Color,
                    ),
                  );
                }).toList(),
              );
            },
          ),

          const SizedBox(height: 30),

          // FIRST ROW: VEHICLE + EXPENSE GRAPHS
          responsiveRow(
            context,
            vehicleDistribution(),
            expenseChart(),
          ),

          const SizedBox(height: 20),

          // SECOND ROW: EMPLOYEE + MAINTENANCE
          responsiveRow(
            context,
            employeeChart(),
            maintenanceChart(),
          ),

          const SizedBox(height: 20),

          // THIRD ROW: ACCIDENT + MONTHLY FLEET
          responsiveRow(
            context,
            accidentChart(),
            monthlyFleetChart(),
          ),

          const SizedBox(height: 25),

          // FLEET STATUS
          fleetStatus(),

          const SizedBox(height: 25),

          // ACTIVITY AND ALERTS
          responsiveRow(
            context,
            activityArea(),
            alertsArea(),
          ),

          const SizedBox(height: 25),

          // RECENT TRANSACTIONS
          recentTransactions(),

          const SizedBox(height: 25),
        ],
      ),
    );
  }

  // RESPONSIVE TWO COLUMN LAYOUT
  Widget responsiveRow(
    BuildContext context,
    Widget first,
    Widget second,
  ) {
    return LayoutBuilder(
      builder: (context, constraints) {
        if (constraints.maxWidth < 750) {
          return Column(
            children: [
              first,
              const SizedBox(height: 20),
              second,
            ],
          );
        }

        return Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(child: first),
            const SizedBox(width: 20),
            Expanded(child: second),
          ],
        );
      },
    );
  }

  // COMMON GRAPH CONTAINER
  Widget graphCard(String title, Widget child, {String? subtitle}) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(22),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 17,
              fontWeight: FontWeight.bold,
              color: AppColors.darkBackground,
            ),
          ),
          if (subtitle != null) ...[
            const SizedBox(height: 5),
            Text(
              subtitle,
              style: const TextStyle(
                fontSize: 12,
                color: AppColors.grey,
              ),
            ),
          ],
          const SizedBox(height: 24),
          child,
        ],
      ),
    );
  }

  // GRAPH 1: VEHICLE DISTRIBUTION
  Widget vehicleDistribution() {
    final data = [
      ['Assigned', 162, AppColors.primary],
      ['Available', 64, AppColors.blue],
      ['Maintenance', 22, AppColors.orange],
    ];

    return graphCard(
      'Vehicle Distribution',
      Column(
        children: data.map((item) {
          final value = item[1] as int;
          final color = item[2] as Color;

          return Padding(
            padding: const EdgeInsets.only(bottom: 22),
            child: Column(
              children: [
                Row(
                  children: [
                    CircleAvatar(
                      radius: 5,
                      backgroundColor: color,
                    ),
                    const SizedBox(width: 9),
                    Text(item[0] as String),
                    const Spacer(),
                    Text(
                      '$value vehicles',
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                ClipRRect(
                  borderRadius: BorderRadius.circular(20),
                  child: LinearProgressIndicator(
                    value: value / 248,
                    minHeight: 11,
                    color: color,
                    backgroundColor: AppColors.background,
                  ),
                ),
              ],
            ),
          );
        }).toList(),
      ),
      subtitle: 'Current status of all fleet vehicles',
    );
  }

  // GRAPH 2: MONTHLY EXPENSES
  Widget expenseChart() {
    final values = [45.0, 65.0, 52.0, 80.0, 60.0, 95.0, 75.0];
    final labels = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];

    return graphCard(
      'Weekly Expenses',
      SizedBox(
        height: 190,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: List.generate(values.length, (index) {
            return Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Text(
                  '${values[index].toInt()}k',
                  style: const TextStyle(
                    fontSize: 10,
                    color: AppColors.grey,
                  ),
                ),
                const SizedBox(height: 6),
                Container(
                  width: 22,
                  height: values[index] * 1.3,
                  decoration: BoxDecoration(
                    color: index == 5
                        ? AppColors.primary
                        : AppColors.mutedGreen,
                    borderRadius: const BorderRadius.vertical(
                      top: Radius.circular(6),
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  labels[index],
                  style: const TextStyle(
                    fontSize: 10,
                    color: AppColors.grey,
                  ),
                ),
              ],
            );
          }),
        ),
      ),
      subtitle: 'Expense trend in thousands of rupees',
    );
  }

  // GRAPH 3: EMPLOYEE DISTRIBUTION
  Widget employeeChart() {
    final departments = [
      ['IT', 42, AppColors.primary],
      ['Finance', 35, AppColors.blue],
      ['HR', 24, AppColors.orange],
      ['Operations', 58, AppColors.green],
      ['Management', 27, AppColors.mutedGreen],
    ];

    return graphCard(
      'Employees by Department',
      Column(
        children: departments.map((item) {
          final value = item[1] as int;
          final color = item[2] as Color;

          return Padding(
            padding: const EdgeInsets.only(bottom: 16),
            child: Column(
              children: [
                Row(
                  children: [
                    Text(item[0] as String),
                    const Spacer(),
                    Text(
                      '$value',
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 7),
                ClipRRect(
                  borderRadius: BorderRadius.circular(20),
                  child: LinearProgressIndicator(
                    value: value / 60,
                    minHeight: 9,
                    color: color,
                    backgroundColor: AppColors.background,
                  ),
                ),
              ],
            ),
          );
        }).toList(),
      ),
      subtitle: '186 employees across departments',
    );
  }

  // GRAPH 4: MAINTENANCE
  Widget maintenanceChart() {
    final items = [
      ['Completed', 48, AppColors.primary],
      ['In Progress', 30, AppColors.blue],
      ['Pending', 22, AppColors.orange],
    ];

    return graphCard(
      'Maintenance Overview',
      Column(
        children: [
          ...items.map((item) {
            final value = item[1] as int;
            final color = item[2] as Color;

            return Padding(
              padding: const EdgeInsets.only(bottom: 20),
              child: Column(
                children: [
                  Row(
                    children: [
                      Text(item[0] as String),
                      const Spacer(),
                      Text('$value%'),
                    ],
                  ),
                  const SizedBox(height: 8),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(20),
                    child: LinearProgressIndicator(
                      value: value / 100,
                      minHeight: 10,
                      color: color,
                      backgroundColor: AppColors.background,
                    ),
                  ),
                ],
              ),
            );
          }),
          const Divider(),
          const Row(
            children: [
              Icon(Icons.build_circle_outlined,
                  color: AppColors.orange),
              SizedBox(width: 10),
              Text('22 vehicles under maintenance'),
            ],
          ),
        ],
      ),
      subtitle: 'Maintenance request completion status',
    );
  }

  // GRAPH 5: ACCIDENT REPORTS
  Widget accidentChart() {
    final data = [
      ['Minor', 5, AppColors.orange],
      ['Major', 2, AppColors.red],
      ['Under Review', 1, AppColors.blue],
    ];

    return graphCard(
      'Accident Reports',
      Column(
        children: [
          Row(
            children: data.map((item) {
              return Expanded(
                child: Column(
                  children: [
                    Text(
                      '${item[1]}',
                      style: TextStyle(
                        fontSize: 27,
                        fontWeight: FontWeight.bold,
                        color: item[2] as Color,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      item[0] as String,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontSize: 11,
                        color: AppColors.grey,
                      ),
                    ),
                  ],
                ),
              );
            }).toList(),
          ),
          const SizedBox(height: 25),
          const Divider(),
          const Row(
            children: [
              Icon(Icons.warning_amber_rounded,
                  color: AppColors.red),
              SizedBox(width: 10),
              Expanded(
                child: Text('8 accident reports recorded this month'),
              ),
            ],
          ),
        ],
      ),
      subtitle: 'Accident severity breakdown',
    );
  }

  // GRAPH 6: MONTHLY FLEET ACTIVITY
  Widget monthlyFleetChart() {
    final assigned = [30.0, 45.0, 40.0, 65.0, 55.0, 80.0];
    final available = [70.0, 60.0, 75.0, 55.0, 65.0, 50.0];
    final months = ['Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov'];

    return graphCard(
      'Monthly Fleet Activity',
      SizedBox(
        height: 190,
        child: Column(
          children: [
            Expanded(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: List.generate(6, (index) {
                  return Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Container(
                            width: 12,
                            height: assigned[index] * 1.25,
                            decoration: const BoxDecoration(
                              color: AppColors.primary,
                              borderRadius: BorderRadius.vertical(
                                top: Radius.circular(4),
                              ),
                            ),
                          ),
                          const SizedBox(width: 4),
                          Container(
                            width: 12,
                            height: available[index] * 1.25,
                            decoration: const BoxDecoration(
                              color: AppColors.light,
                              borderRadius: BorderRadius.vertical(
                                top: Radius.circular(4),
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Text(
                        months[index],
                        style: const TextStyle(
                          fontSize: 10,
                          color: AppColors.grey,
                        ),
                      ),
                    ],
                  );
                }),
              ),
            ),
          ],
        ),
      ),
      subtitle: 'Assigned vs available vehicle activity',
    );
  }

  // FLEET STATUS
  Widget fleetStatus() {
    return graphCard(
      'Fleet Performance',
      Column(
        children: [
          statusBar('Vehicle utilization', 0.78, AppColors.primary),
          statusBar('Vehicle availability', 0.26, AppColors.blue),
          statusBar('Maintenance completion', 0.85, AppColors.orange),
          statusBar('Employee allocation', 0.91, AppColors.green),
        ],
      ),
      subtitle: 'Overall operational performance',
    );
  }

  Widget statusBar(String label, double value, Color color) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: Column(
        children: [
          Row(
            children: [
              Text(label),
              const Spacer(),
              Text('${(value * 100).round()}%'),
            ],
          ),
          const SizedBox(height: 8),
          ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child: LinearProgressIndicator(
              value: value,
              minHeight: 10,
              color: color,
              backgroundColor: AppColors.background,
            ),
          ),
        ],
      ),
    );
  }

  // ACTIVITY AREA
  Widget activityArea() {
    final activities = [
      [
        'Vehicle assigned to Muhammad Ali',
        'Toyota Corolla • Vehicle allocation',
        '10 min ago',
        Icons.directions_car,
        AppColors.primary,
      ],
      [
        'Accident report submitted',
        'Honda Civic • Lahore',
        '25 min ago',
        Icons.car_crash,
        AppColors.red,
      ],
      [
        'Maintenance request approved',
        'Toyota Yaris • Engine service',
        '45 min ago',
        Icons.build,
        AppColors.orange,
      ],
      [
        'New employee registered',
        'Ahmed Raza • Operations',
        '1 hour ago',
        Icons.person_add,
        AppColors.blue,
      ],
      [
        'Vehicle return completed',
        'Suzuki Swift • Return approved',
        '2 hours ago',
        Icons.assignment_return,
        AppColors.green,
      ],
      [
        'New vehicle request received',
        'Sara Ahmed • HR Department',
        '3 hours ago',
        Icons.assignment,
        AppColors.mutedGreen,
      ],
    ];

    return graphCard(
      'Recent Activity',
      Column(
        children: activities.map((item) {
          return ListTile(
            contentPadding: EdgeInsets.zero,
            leading: CircleAvatar(
              backgroundColor:
                  (item[4] as Color).withValues(alpha: 0.12),
              child: Icon(
                item[3] as IconData,
                color: item[4] as Color,
                size: 20,
              ),
            ),
            title: Text(
              item[0] as String,
              style: const TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w600,
              ),
            ),
            subtitle: Text(
              '${item[1]} • ${item[2]}',
              style: const TextStyle(fontSize: 11),
            ),
          );
        }).toList(),
      ),
      subtitle: 'Latest fleet operations and updates',
    );
  }

  // ALERTS AREA
  Widget alertsArea() {
    final alerts = [
      [
        'Vehicle maintenance overdue',
        'Toyota Yaris • 3 days overdue',
        AppColors.orange,
        Icons.build,
      ],
      [
        'Accident awaiting review',
        'Honda Civic • Report #AC-008',
        AppColors.red,
        Icons.car_crash,
      ],
      [
        'Vehicle return pending',
        'Muhammad Ali • Toyota Corolla',
        AppColors.blue,
        Icons.assignment_return,
      ],
      [
        'New allocation request',
        'Finance Department • 2 hours ago',
        AppColors.primary,
        Icons.assignment,
      ],
    ];

    return graphCard(
      'Alerts & Notifications',
      Column(
        children: alerts.map((item) {
          return Container(
            margin: const EdgeInsets.only(bottom: 12),
            padding: const EdgeInsets.all(13),
            decoration: BoxDecoration(
              color: (item[2] as Color).withValues(alpha: 0.07),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: (item[2] as Color).withValues(alpha: 0.2),
              ),
            ),
            child: Row(
              children: [
                Icon(
                  item[3] as IconData,
                  color: item[2] as Color,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        item[0] as String,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 12,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        item[1] as String,
                        style: const TextStyle(
                          fontSize: 11,
                          color: AppColors.grey,
                        ),
                      ),
                    ],
                  ),
                ),
                Icon(
                  Icons.chevron_right,
                  color: item[2] as Color,
                ),
              ],
            ),
          );
        }).toList(),
      ),
      subtitle: 'Items requiring administrative attention',
    );
  }

  // RECENT TRANSACTIONS
  Widget recentTransactions() {
    final transactions = [
      ['Fuel Expense', 'Toyota Corolla', 'Rs. 12,500', 'Approved'],
      ['Vehicle Repair', 'Honda Civic', 'Rs. 35,000', 'Pending'],
      ['Insurance', 'Suzuki Swift', 'Rs. 18,000', 'Approved'],
      ['Tyre Replacement', 'Toyota Yaris', 'Rs. 22,000', 'Pending'],
    ];

    return graphCard(
      'Recent Fleet Expenses',
      SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: DataTable(
          columns: const [
            DataColumn(label: Text('Expense')),
            DataColumn(label: Text('Vehicle')),
            DataColumn(label: Text('Amount')),
            DataColumn(label: Text('Status')),
          ],
          rows: transactions.map((item) {
            return DataRow(
              cells: [
                DataCell(Text(item[0])),
                DataCell(Text(item[1])),
                DataCell(Text(item[2])),
                DataCell(
                  Text(
                    item[3],
                    style: TextStyle(
                      color: item[3] == 'Approved'
                          ? AppColors.primary
                          : AppColors.orange,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            );
          }).toList(),
        ),
      ),
      subtitle: 'Latest recorded vehicle expenses',
    );
  }
}
