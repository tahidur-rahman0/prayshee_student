import 'package:flutter/material.dart';

class HelpCenterPage extends StatelessWidget {
  const HelpCenterPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Help Center'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _buildHelpSection(
            title: 'FAQs',
            items: [
              'How to reset my password?',
              'How to enroll in a course?',
              'Where can I find my assignments?',
              'How to contact my teacher?',
            ],
          ),
          const SizedBox(height: 24),
          _buildHelpSection(
            title: 'Contact Support',
            items: [
              'Email: support@prayashee.com',
              'Phone: +91 9508446021',
              // 'Live Chat (9AM-5PM)',
            ],
          ),
          const SizedBox(height: 24),
          // _buildHelpCard(
          //   icon: Icons.video_library,
          //   title: 'Video Tutorials',
          //   subtitle: 'Learn how to use the app with our video guides',
          //   onTap: () {
          //     // Navigate to video tutorials
          //   },
          // ),
          // const SizedBox(height: 16),
          // _buildHelpCard(
          //   icon: Icons.feedback,
          //   title: 'Send Feedback',
          //   subtitle: 'We value your suggestions and comments',
          //   onTap: () {
          //     // Navigate to feedback form
          //   },
          // ),
        ],
      ),
    );
  }

  Widget _buildHelpSection(
      {required String title, required List<String> items}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        Card(
          child: Column(
            children: items
                .map(
                  (item) => ListTile(
                    title: Text(item),
                    trailing: const Icon(Icons.chevron_right),
                    onTap: () {
                      // Handle FAQ item tap
                    },
                  ),
                )
                .toList(),
          ),
        ),
      ],
    );
  }

  Widget _buildHelpCard({
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return Card(
      child: ListTile(
        leading: Icon(icon, size: 40, color: Colors.blue),
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Text(subtitle),
        trailing: const Icon(Icons.chevron_right),
        onTap: onTap,
      ),
    );
  }
}
