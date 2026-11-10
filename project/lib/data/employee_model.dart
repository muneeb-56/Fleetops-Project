
class Employee {
  final int? id;
  final String name;
  final String department;
  final String role;
  final String vehicle;
  final String status;

  Employee({
    this.id,
    required this.name,
    required this.department,
    required this.role,
    required this.vehicle,
    required this.status,
  });

  // Convert Dart object into a database Map.
  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'department': department,
      'role': role,
      'vehicle': vehicle,
      'status': status,
    };
  }

  // Convert database Map into Dart object.
  factory Employee.fromMap(Map<String, dynamic> map) {
    return Employee(
      id: map['id'] as int,
      name: map['name'] as String,
      department: map['department'] as String,
      role: map['role'] as String,
      vehicle: map['vehicle'] as String,
      status: map['status'] as String,
    );
  }
}
