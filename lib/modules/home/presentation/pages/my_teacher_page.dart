import 'package:flutter/material.dart';
import 'package:online_training_template/app/const/const.dart';
import 'package:online_training_template/models/teacher_model.dart';

class TeacherProfileScreen extends StatelessWidget {
  final TeacherModel teacher;

  const TeacherProfileScreen({super.key, required this.teacher});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Teacher Profile'),
        centerTitle: true,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildProfileHeader(),
            const SizedBox(height: 24),
            _buildSectionTitle('Personal Information'),
            _buildInfoCard(Icons.person, 'Name', teacher.name),
            _buildInfoCard(Icons.phone, 'Phone', teacher.phone),
            _buildInfoCard(Icons.email, 'Email', teacher.email),
            if (teacher.address != null)
              _buildInfoCard(Icons.location_on, 'Address', teacher.address!),
            if (teacher.city != null)
              _buildInfoCard(Icons.location_city, 'City', teacher.city!),
            const SizedBox(height: 24),
            _buildSectionTitle('Professional Details'),
            if (teacher.qualification != null)
              _buildInfoCard(
                  Icons.school, 'Qualification', teacher.qualification!),
            if (teacher.total_experience != null)
              _buildInfoCard(Icons.work, 'Experience',
                  '${teacher.total_experience} years${teacher.experience_details != null ? '\n${teacher.experience_details}' : ''}'),
            if (teacher.course != null && teacher.course!.isNotEmpty)
              _buildInfoCard(
                  Icons.menu_book, 'Courses', teacher.course!.join(', ')),
            if (teacher.upi_id != null)
              _buildInfoCard(Icons.payment, 'UPI ID', teacher.upi_id!),
            const SizedBox(height: 24),
            _buildVerificationBadge(),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileHeader() {
    return Center(
      child: Column(
        children: [
          CircleAvatar(
            radius: 60,
            backgroundImage: teacher.profile_photo != null
                ? NetworkImage(
                    '${ServerConstant.baseUrl}/${teacher.profile_photo!}')
                : const AssetImage('assets/default_avatar.png')
                    as ImageProvider,
          ),
          const SizedBox(height: 16),
          Text(
            teacher.name,
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          if (teacher.is_verified == 1)
            const Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.verified, color: Colors.blue, size: 16),
                SizedBox(width: 4),
                Text(
                  'Verified Teacher',
                  style: TextStyle(
                    color: Colors.blue,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
          color: Colors.blueGrey,
        ),
      ),
    );
  }

  Widget _buildInfoCard(IconData icon, String label, String value) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8),
      elevation: 1,
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(icon, size: 24, color: Colors.blueGrey),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    label,
                    style: const TextStyle(
                      fontSize: 14,
                      color: Colors.grey,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    value,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildVerificationBadge() {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: teacher.is_verified == 1 ? Colors.green[50] : Colors.orange[50],
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: teacher.is_verified == 1 ? Colors.green : Colors.orange,
          width: 1,
        ),
      ),
      child: Row(
        children: [
          Icon(
            teacher.is_verified == 1 ? Icons.verified : Icons.pending,
            color: teacher.is_verified == 1 ? Colors.green : Colors.orange,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              teacher.is_verified == 1
                  ? 'This teacher is verified by our team'
                  : 'Verification pending for this teacher',
              style: TextStyle(
                color: teacher.is_verified == 1 ? Colors.green : Colors.orange,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
