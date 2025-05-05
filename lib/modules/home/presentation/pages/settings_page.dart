import 'package:flutter/material.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  bool _notificationsEnabled = true;
  bool _darkModeEnabled = false;
  String _language = 'English';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          const Text(
            'General Settings',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          _buildSettingsSwitch(
            title: 'Enable Notifications',
            value: _notificationsEnabled,
            onChanged: (value) {
              setState(() {
                _notificationsEnabled = value;
              });
            },
          ),
          _buildSettingsSwitch(
            title: 'Dark Mode',
            value: _darkModeEnabled,
            onChanged: (value) {
              setState(() {
                _darkModeEnabled = value;
              });
            },
          ),
          _buildSettingsDropdown(
            title: 'Language',
            value: _language,
            items: const ['English', 'Spanish', 'French', 'German'],
            onChanged: (value) {
              setState(() {
                _language = value!;
              });
            },
          ),
          const Divider(height: 32),
          const Text(
            'Account Settings',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          _buildSettingsButton(
            title: 'Change Password',
            icon: Icons.lock,
            onTap: () {
              // Navigate to change password screen
            },
          ),
          _buildSettingsButton(
            title: 'Privacy Settings',
            icon: Icons.privacy_tip,
            onTap: () {
              // Navigate to privacy settings
            },
          ),
          const Divider(height: 32),
          _buildSettingsButton(
            title: 'Log Out',
            icon: Icons.logout,
            color: Colors.red,
            onTap: () {
              // Handle logout
            },
          ),
        ],
      ),
    );
  }

  Widget _buildSettingsSwitch({
    required String title,
    required bool value,
    required Function(bool) onChanged,
  }) {
    return SwitchListTile(
      title: Text(title),
      value: value,
      onChanged: onChanged,
    );
  }

  Widget _buildSettingsDropdown({
    required String title,
    required String value,
    required List<String> items,
    required Function(String?) onChanged,
  }) {
    return ListTile(
      title: Text(title),
      trailing: DropdownButton<String>(
        value: value,
        onChanged: onChanged,
        items: items.map<DropdownMenuItem<String>>((String value) {
          return DropdownMenuItem<String>(
            value: value,
            child: Text(value),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildSettingsButton({
    required String title,
    required IconData icon,
    required VoidCallback onTap,
    Color? color,
  }) {
    return ListTile(
      leading: Icon(icon, color: color),
      title: Text(title, style: TextStyle(color: color)),
      trailing: const Icon(Icons.chevron_right),
      onTap: onTap,
    );
  }
}
