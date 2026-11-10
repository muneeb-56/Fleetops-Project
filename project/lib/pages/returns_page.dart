import 'package:flutter/material.dart';
import '../widgets.dart';

class ReturnsPage extends StatelessWidget {
  const ReturnsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const ManagementPage(
      title: 'Car Returns',
      subtitle: 'Track vehicle return submissions and approvals.',
      addButtonText: 'Add Return',
      columns: [
        'Employee',
        'Vehicle',
        'Return Date',
        'Condition',
        'Status',
      ],
      initialRows: [
        ['Muhammad Ali', 'Toyota Corolla', '03 Nov 2026', 'Good', 'Pending'],
        ['Sara Ahmed', 'Suzuki Swift', '02 Nov 2026', 'Good', 'Approved'],
        ['Ahmed Raza', 'Honda Civic', '01 Nov 2026', 'Damaged', 'Review'],
      ],
    );
  }
}