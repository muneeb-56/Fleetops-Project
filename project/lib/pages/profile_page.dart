import 'package:flutter/material.dart';
import '../style.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final nameController = TextEditingController(text: 'Fleet Admin');
  final emailController = TextEditingController(text: 'admin@fleetops.com');
  final phoneController = TextEditingController(text: '+92 300 1234567');
  final departmentController = TextEditingController(text: 'Administration');

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(25),
      child: Center(
        child: Container(
          constraints: const BoxConstraints(maxWidth: 850),
          padding: const EdgeInsets.all(25),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(18),
            border: Border.all(color: AppColors.border),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'My Profile',
                style: TextStyle(
                  fontSize: 25,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 8),

              const Text(
                'View and update your account information.',
                style: TextStyle(color: AppColors.grey),
              ),

              const SizedBox(height: 25),

              const Center(
                child: CircleAvatar(
                  radius: 45,
                  backgroundColor: AppColors.darkGreen,
                  child: Icon(
                    Icons.person,
                    size: 45,
                    color: Colors.white,
                  ),
                ),
              ),

              const SizedBox(height: 25),

              profileField('Full Name', nameController),
              profileField('Email Address', emailController),
              profileField('Phone Number', phoneController),
              profileField('Department', departmentController),

              const SizedBox(height: 15),

              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Profile saved locally.'),
                      ),
                    );
                  },
                  icon: const Icon(Icons.save_outlined),
                  label: const Text('Save Changes'),
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.all(16),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget profileField(
    String label,
    TextEditingController controller,
  ) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 18),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: const TextStyle(
              fontWeight: FontWeight.w600,
            ),
          ),

          const SizedBox(height: 8),

          TextField(
            controller: controller,
            decoration: InputDecoration(
              hintText: label,
            ),
          ),
        ],
      ),
    );
  }
}