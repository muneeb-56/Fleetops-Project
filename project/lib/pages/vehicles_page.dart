import 'package:flutter/material.dart';
import '../widgets.dart';

class VehiclesPage extends StatelessWidget {
  const VehiclesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const ManagementPage(
      title: 'Vehicles',
      subtitle: 'Manage fleet vehicles and their availability.',
      addButtonText: 'Add Vehicle',
      columns: [
        'Vehicle',
        'Registration',
        'Type',
        'Assigned To',
        'Status',
      ],
      initialRows: [
        ['Toyota Corolla', 'ABC-123', 'Sedan', 'Muhammad Ali', 'Assigned'],
        ['Honda Civic', 'DEF-456', 'Sedan', 'Ayesha Khan', 'Assigned'],
        ['Suzuki Swift', 'GHI-789', 'Hatchback', '-', 'Available'],
        ['Toyota Yaris', 'JKL-101', 'Sedan', '-', 'Maintenance'],
      ],
    );
  }
}