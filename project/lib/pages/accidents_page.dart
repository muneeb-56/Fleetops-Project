
import 'package:flutter/material.dart';
import '../widgets.dart';

class AccidentsPage extends StatefulWidget {
  const AccidentsPage({super.key});

  @override
  State<AccidentsPage> createState() => _AccidentsPageState();
}

class _AccidentsPageState extends State<AccidentsPage> {
  final TextEditingController searchController = TextEditingController();

  String selectedFilter = 'All';

  final List<Map<String, dynamic>> accidents = [
    {
      'employee': 'Muhammad Ali',
      'vehicle': 'Toyota Corolla',
      'plate': 'LEA-2026',
      'date': '01 Nov 2026',
      'location': 'Lahore',
      'fault': 'Under Review',
      'status': 'Pending',
      'damage': 'Front bumper and headlights damaged',
      'description':
          'Vehicle collided with another car at a traffic signal.',
      'estimated': 'Rs. 85,000',
      'claim': 'Rs. 65,000',
      'witness': 'Available',
      'severity': 'Medium',
    },
    {
      'employee': 'Ahmed Raza',
      'vehicle': 'Honda Civic',
      'plate': 'ISB-2025',
      'date': '28 Oct 2026',
      'location': 'Islamabad',
      'fault': 'Employee',
      'status': 'Reviewed',
      'damage': 'Rear door and side panel damaged',
      'description': 'Vehicle hit a roadside barrier.',
      'estimated': 'Rs. 120,000',
      'claim': 'Rs. 90,000',
      'witness': 'Not Available',
      'severity': 'High',
    },
    {
      'employee': 'Usman Khalid',
      'vehicle': 'Suzuki Swift',
      'plate': 'KHI-2024',
      'date': '25 Oct 2026',
      'location': 'Karachi',
      'fault': 'Company',
      'status': 'Resolved',
      'damage': 'Minor scratches on left door',
      'description': 'Damage occurred while vehicle was parked.',
      'estimated': 'Rs. 25,000',
      'claim': 'Rs. 20,000',
      'witness': 'Available',
      'severity': 'Low',
    },
  ];

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  void showMessage(String message, {bool error = false}) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          content: Text(message),
          backgroundColor: error ? Colors.red.shade700 : const Color(0xFF00A68A),
          behavior: SnackBarBehavior.floating,
          duration: const Duration(seconds: 2),
        ),
      );
  }

  List<Map<String, dynamic>> get filteredAccidents {
    return accidents.where((accident) {
      final query = searchController.text.toLowerCase();

      final matchesSearch =
          accident['employee'].toString().toLowerCase().contains(query) ||
          accident['vehicle'].toString().toLowerCase().contains(query) ||
          accident['location'].toString().toLowerCase().contains(query);

      final matchesFilter =
          selectedFilter == 'All' || accident['status'] == selectedFilter;

      return matchesSearch && matchesFilter;
    }).toList();
  }

  void updateStatus(Map<String, dynamic> accident, String status) {
    setState(() {
      accident['status'] = status;
    });

    Navigator.pop(context);
    showMessage('Accident marked as $status');
  }

  void openInvestigation(Map<String, dynamic> accident) {
    showDialog(
      context: context,
      builder: (dialogContext) {
        return Dialog(
          backgroundColor: const Color(0xFF0F1F17),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
            side: const BorderSide(color: Color(0xFF3D4337)),
          ),
          child: StatefulBuilder(
            builder: (context, dialogSetState) {
              return Container(
                width: 650,
                constraints: const BoxConstraints(maxHeight: 750),
                padding: const EdgeInsets.all(24),
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          const Icon(Icons.travel_explore,
                              color: Color(0xFF00A68A), size: 28),
                          const SizedBox(width: 12),
                          const Expanded(
                            child: Text(
                              'Accident Investigation',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 21,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          IconButton(
                            onPressed: () => Navigator.pop(context),
                            icon: const Icon(Icons.close, color: Colors.white),
                          ),
                        ],
                      ),
                      const Divider(color: Color(0xFF3D4337), height: 28),

                      _sectionTitle('REPORT INFORMATION'),
                      _detailGrid([
                        ['Employee', accident['employee']],
                        ['Vehicle', accident['vehicle']],
                        ['Registration', accident['plate']],
                        ['Incident Date', accident['date']],
                        ['Location', accident['location']],
                        ['Severity', accident['severity']],
                      ]),

                      const SizedBox(height: 22),
                      _sectionTitle('DAMAGE ASSESSMENT'),
                      _detailBox('Damage Description', accident['damage']),
                      _detailBox('Incident Summary', accident['description']),
                      _detailGrid([
                        ['Estimated Damage', accident['estimated']],
                        ['Claim Amount', accident['claim']],
                        ['Witness Statement', accident['witness']],
                        ['Fault Assessment', accident['fault']],
                      ]),

                      const SizedBox(height: 22),
                      _sectionTitle('INVESTIGATION NOTES'),
                      const Text(
                        'Review the incident evidence, employee statement, '
                        'vehicle damage and estimated repair cost before '
                        'making a decision.',
                        style: TextStyle(color: Color(0xFFC7CBB8), height: 1.5),
                      ),

                      const SizedBox(height: 22),
                      _sectionTitle('INVESTIGATION ACTIONS'),
                      Wrap(
                        spacing: 10,
                        runSpacing: 10,
                        children: [
                          _actionButton(
                            'Request Evidence',
                            Icons.upload_file,
                            Colors.orange,
                            () {
                              Navigator.pop(context);
                              showMessage('Evidence requested from employee');
                            },
                          ),
                          _actionButton(
                            'Approve Claim',
                            Icons.check_circle_outline,
                            const Color(0xFF00A68A),
                            () => updateStatus(accident, 'Approved'),
                          ),
                          _actionButton(
                            'Reject Claim',
                            Icons.cancel_outlined,
                            Colors.red,
                            () => updateStatus(accident, 'Rejected'),
                          ),
                          _actionButton(
                            'Mark Resolved',
                            Icons.verified,
                            Colors.blue,
                            () => updateStatus(accident, 'Resolved'),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        );
      },
    );
  }

  void reportAccident() {
    final employee = TextEditingController();
    final vehicle = TextEditingController();
    final location = TextEditingController();
    final damage = TextEditingController();

    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        backgroundColor: const Color(0xFF0F1F17),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(18),
        ),
        title: const Text(
          'Report New Accident',
          style: TextStyle(color: Colors.white),
        ),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _formField(employee, 'Employee Name'),
              _formField(vehicle, 'Vehicle'),
              _formField(location, 'Incident Location'),
              _formField(damage, 'Damage Description'),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF00A68A),
            ),
            onPressed: () {
              if (employee.text.trim().isEmpty ||
                  vehicle.text.trim().isEmpty ||
                  location.text.trim().isEmpty ||
                  damage.text.trim().isEmpty) {
                showMessage('Please complete all fields', error: true);
                return;
              }

              setState(() {
                accidents.insert(0, {
                  'employee': employee.text.trim(),
                  'vehicle': vehicle.text.trim(),
                  'plate': 'Not Provided',
                  'date': '03 Nov 2026',
                  'location': location.text.trim(),
                  'fault': 'Under Review',
                  'status': 'Pending',
                  'damage': damage.text.trim(),
                  'description': 'Newly submitted accident report.',
                  'estimated': 'Not Assessed',
                  'claim': 'Not Submitted',
                  'witness': 'Not Provided',
                  'severity': 'Pending Assessment',
                });
              });

              Navigator.pop(dialogContext);
              showMessage('New accident report submitted');
            },
            child: const Text(
              'Submit Report',
              style: TextStyle(color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final filtered = filteredAccidents;

    return Scaffold(
      backgroundColor: const Color(0xFF0F1F17),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(22),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Accidents & Loss Reports',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 6),
                      Text(
                        'Investigate incidents, assess damages and manage claims.',
                        style: TextStyle(color: Color(0xFFC7CBB8)),
                      ),
                    ],
                  ),
                ),
                ElevatedButton.icon(
                  onPressed: reportAccident,
                  icon: const Icon(Icons.add),
                  label: const Text('Report Accident'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF00A68A),
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 14,
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 24),

            Wrap(
              spacing: 14,
              runSpacing: 14,
              children: [
                _summaryCard('Total Reports', '${accidents.length}',
                    Icons.car_crash, Colors.blue),
                _summaryCard(
                  'Pending',
                  '${accidents.where((a) => a['status'] == 'Pending').length}',
                  Icons.pending_actions,
                  Colors.orange,
                ),
                _summaryCard(
                  'Resolved',
                  '${accidents.where((a) => a['status'] == 'Resolved').length}',
                  Icons.verified,
                  const Color(0xFF00A68A),
                ),
                _summaryCard(
                  'Rejected',
                  '${accidents.where((a) => a['status'] == 'Rejected').length}',
                  Icons.cancel,
                  Colors.red,
                ),
              ],
            ),

            const SizedBox(height: 24),

            Wrap(
              spacing: 12,
              runSpacing: 12,
              crossAxisAlignment: WrapCrossAlignment.center,
              children: [
                SizedBox(
                  width: 260,
                  child: TextField(
                    controller: searchController,
                    onChanged: (_) => setState(() {}),
                    style: const TextStyle(color: Colors.white),
                    decoration: InputDecoration(
                      hintText: 'Search reports...',
                      hintStyle: const TextStyle(color: Colors.grey),
                      prefixIcon: const Icon(Icons.search, color: Colors.grey),
                      filled: true,
                      fillColor: const Color(0xFF1E3A2E),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide.none,
                      ),
                    ),
                  ),
                ),
                ...['All', 'Pending', 'Approved', 'Reviewed', 'Resolved',
                  'Rejected'].map((filter) {
                  final selected = selectedFilter == filter;
                  return ChoiceChip(
                    label: Text(filter),
                    selected: selected,
                    onSelected: (_) {
                      setState(() => selectedFilter = filter);
                    },
                    selectedColor: const Color(0xFF00A68A),
                    backgroundColor: const Color(0xFF1E3A2E),
                    labelStyle: TextStyle(
                      color: selected ? Colors.white : const Color(0xFFC7CBB8),
                    ),
                  );
                }),
              ],
            ),

            const SizedBox(height: 20),

            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: const Color(0xFF1E3A2E),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: const Color(0xFF3D4337)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Accident Investigation Records',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16),
                  if (filtered.isEmpty)
                    const Padding(
                      padding: EdgeInsets.all(25),
                      child: Center(
                        child: Text(
                          'No accident reports found.',
                          style: TextStyle(color: Colors.white70),
                        ),
                      ),
                    )
                  else
                    ...filtered.map((accident) => _accidentCard(accident)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _accidentCard(Map<String, dynamic> accident) {
    final status = accident['status'].toString();

    Color statusColor = Colors.orange;
    if (status == 'Resolved' || status == 'Approved') {
      statusColor = const Color(0xFF00A68A);
    } else if (status == 'Rejected') {
      statusColor = Colors.red;
    } else if (status == 'Reviewed') {
      statusColor = Colors.blue;
    }

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF0F1F17),
        borderRadius: BorderRadius.circular(13),
        border: Border.all(color: const Color(0xFF3D4337)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Wrap(
            alignment: WrapAlignment.spaceBetween,
            crossAxisAlignment: WrapCrossAlignment.center,
            spacing: 12,
            runSpacing: 10,
            children: [
              Text(
                accident['employee'],
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: statusColor.withOpacity(0.15),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  status,
                  style: TextStyle(
                    color: statusColor,
                    fontWeight: FontWeight.bold,
                    fontSize: 12,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Wrap(
            spacing: 22,
            runSpacing: 10,
            children: [
              _smallInfo(Icons.directions_car, accident['vehicle']),
              _smallInfo(Icons.confirmation_number, accident['plate']),
              _smallInfo(Icons.calendar_today, accident['date']),
              _smallInfo(Icons.location_on, accident['location']),
            ],
          ),
          const SizedBox(height: 14),
          Row(
            children: [
              Expanded(
                child: Text(
                  'Damage: ${accident['damage']}',
                  style: const TextStyle(color: Color(0xFFC7CBB8)),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              const SizedBox(width: 12),
              ElevatedButton.icon(
                onPressed: () => openInvestigation(accident),
                icon: const Icon(Icons.manage_search, size: 18),
                label: const Text('Investigate'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF00A68A),
                  foregroundColor: Colors.white,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _summaryCard(
      String title, String value, IconData icon, Color color) {
    return Container(
      width: 190,
      padding: const EdgeInsets.all(17),
      decoration: BoxDecoration(
        color: const Color(0xFF1E3A2E),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: const Color(0xFF3D4337)),
      ),
      child: Row(
        children: [
          Icon(icon, color: color, size: 28),
          const SizedBox(width: 12),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(value,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  )),
              Text(title,
                  style: const TextStyle(
                    color: Color(0xFFC7CBB8),
                    fontSize: 12,
                  )),
            ],
          ),
        ],
      ),
    );
  }

  Widget _smallInfo(IconData icon, String value) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, color: const Color(0xFF00A68A), size: 15),
        const SizedBox(width: 5),
        Text(value,
            style: const TextStyle(color: Color(0xFFC7CBB8), fontSize: 12)),
      ],
    );
  }

  Widget _sectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Text(
        title,
        style: const TextStyle(
          color: Color(0xFF00A68A),
          fontSize: 12,
          fontWeight: FontWeight.bold,
          letterSpacing: 1.2,
        ),
      ),
    );
  }

  Widget _detailGrid(List<List<String>> details) {
    return Wrap(
      spacing: 12,
      runSpacing: 12,
      children: details.map((item) {
        return SizedBox(
          width: 245,
          child: _detailBox(item[0], item[1]),
        );
      }).toList(),
    );
  }

  Widget _detailBox(String title, String value) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xFF1E3A2E),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title,
              style: const TextStyle(
                color: Color(0xFF9BAA9A),
                fontSize: 11,
              )),
          const SizedBox(height: 5),
          Text(value,
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w600,
              )),
        ],
      ),
    );
  }

  Widget _actionButton(
      String label, IconData icon, Color color, VoidCallback onPressed) {
    return ElevatedButton.icon(
      onPressed: onPressed,
      icon: Icon(icon, size: 17),
      label: Text(label),
      style: ElevatedButton.styleFrom(
        backgroundColor: color.withOpacity(0.15),
        foregroundColor: color,
        elevation: 0,
      ),
    );
  }

  Widget _formField(TextEditingController controller, String label) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: TextField(
        controller: controller,
        style: const TextStyle(color: Colors.white),
        decoration: InputDecoration(
          labelText: label,
          labelStyle: const TextStyle(color: Color(0xFFC7CBB8)),
          filled: true,
          fillColor: const Color(0xFF1E3A2E),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
      ),
    );
  }
}
