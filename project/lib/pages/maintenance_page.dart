import 'package:flutter/material.dart';
import '../widgets.dart';

class MaintenancePage extends StatelessWidget {
  const MaintenancePage({super.key});

  @override
  Widget build(BuildContext context) {
    return const ManagementPage(
      title: 'Maintenance',
      subtitle: 'Track maintenance requests and vehicle repair status.',
      addButtonText: 'Add Maintenance',
      columns: [
        'Vehicle',
        'Issue',
        'Reported Date',
        'Assigned Workshop',
        'Status',
      ],
      initialRows: [
        [
          'Toyota Yaris',
          'Engine oil change',
          '03 Nov 2026',
          'Workshop A',
          'In Progress',
        ],
        [
          'Honda Civic',
          'Brake inspection',
          '02 Nov 2026',
          'Workshop B',
          'Pending',
        ],
        [
          'Suzuki Swift',
          'Tyre replacement',
          '01 Nov 2026',
          'Workshop A',
          'Completed',
        ],
      ],
    );
  }
}