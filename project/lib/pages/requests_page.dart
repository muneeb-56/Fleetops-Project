import 'package:flutter/material.dart';
import '../widgets.dart';

class RequestsPage extends StatelessWidget {
  const RequestsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const ManagementPage(
      title: 'Car Requests',
      subtitle: 'Review employee requests for vehicle allocation.',
      addButtonText: 'Add Request',
      columns: [
        'Employee',
        'Department',
        'Vehicle Type',
        'Request Date',
        'Status',
      ],
      initialRows: [
        [
          'Ayesha Khan',
          'Finance',
          'Sedan',
          '03 Nov 2026',
          'Pending',
        ],
        [
          'Ahmed Raza',
          'Operations',
          'SUV',
          '02 Nov 2026',
          'Approved',
        ],
        [
          'Sara Ahmed',
          'HR',
          'Hatchback',
          '01 Nov 2026',
          'Rejected',
        ],
      ],
    );
  }
}