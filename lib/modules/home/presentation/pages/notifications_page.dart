import 'package:flutter/material.dart';

class NotificationsPage extends StatelessWidget {
  const NotificationsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Notifications'),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () {
              // Navigate to notification settings
            },
          ),
        ],
      ),
      body: ListView(
        children: [
          _buildNotificationItem(
            icon: Icons.assignment_turned_in,
            title: 'New Assignment Posted',
            subtitle: 'Math homework due tomorrow',
            time: '2 hours ago',
            isRead: false,
          ),
          _buildNotificationItem(
            icon: Icons.event_available,
            title: 'Class Schedule Updated',
            subtitle: 'Your Wednesday class has been moved',
            time: 'Yesterday',
            isRead: true,
          ),
          _buildNotificationItem(
            icon: Icons.quiz,
            title: 'Test Results Available',
            subtitle: 'View your latest test scores',
            time: '2 days ago',
            isRead: true,
          ),
          _buildNotificationItem(
            icon: Icons.announcement,
            title: 'System Maintenance',
            subtitle: 'App will be offline tonight from 2-3 AM',
            time: '1 week ago',
            isRead: true,
          ),
        ],
      ),
    );
  }

  Widget _buildNotificationItem({
    required IconData icon,
    required String title,
    required String subtitle,
    required String time,
    required bool isRead,
  }) {
    return ListTile(
      leading: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: isRead ? Colors.grey[200] : Colors.blue[50],
          shape: BoxShape.circle,
        ),
        child: Icon(icon, color: isRead ? Colors.grey : Colors.blue),
      ),
      title: Text(
        title,
        style: TextStyle(
          fontWeight: isRead ? FontWeight.normal : FontWeight.bold,
        ),
      ),
      subtitle: Text(subtitle),
      trailing: Text(
        time,
        style: const TextStyle(fontSize: 12, color: Colors.grey),
      ),
      onTap: () {
        // Handle notification tap
      },
    );
  }
}
