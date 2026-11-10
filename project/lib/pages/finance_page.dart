import 'package:flutter/material.dart';
import '../widgets.dart';

class FinancePage extends StatelessWidget {
  const FinancePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: ManagementPage(
            title: 'Finance & Expenses',
            subtitle: 'Manage fleet expenses and financial records.',
            addButtonText: 'Add Expense',
            columns: const [
              'Expense',
              'Vehicle',
              'Amount',
              'Date',
              'Status',
            ],
            initialRows: const [
              [
                'Fuel',
                'Toyota Corolla',
                'Rs. 12,500',
                '03 Nov 2026',
                'Approved',
              ],
              [
                'Repair',
                'Honda Civic',
                'Rs. 35,000',
                '02 Nov 2026',
                'Pending',
              ],
              [
                'Insurance',
                'Suzuki Swift',
                'Rs. 18,000',
                '01 Nov 2026',
                'Approved',
              ],
            ],
          ),
        ),
      ],
    );
  }
}