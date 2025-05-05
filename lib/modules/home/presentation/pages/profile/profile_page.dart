import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:online_training_template/app/const/const.dart';
import 'package:online_training_template/models/user_model.dart';
import 'package:online_training_template/modules/home/presentation/pages/help_center_page.dart';
import 'package:online_training_template/modules/home/presentation/pages/my_profile_page.dart';
import 'package:online_training_template/modules/home/presentation/pages/mycourses_page.dart';
import 'package:online_training_template/modules/home/presentation/pages/notifications_page.dart';
import 'package:online_training_template/modules/home/presentation/pages/settings_page.dart';
import 'package:online_training_template/modules/login/presentation/pages/login_page.dart';
import 'package:online_training_template/repositories/auth_local_repository.dart';

class ProfileScreen extends ConsumerStatefulWidget {
  final UserModel userModel;
  const ProfileScreen({super.key, required this.userModel});

  @override
  ConsumerState<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends ConsumerState<ProfileScreen> {
  File? _profileImage;

  @override
  Widget build(BuildContext context) {
    final authRepo = ref.read(authLocalRepositoryProvider);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: const Text("Profile"),
        centerTitle: true,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(vertical: 20),
        child: Column(
          children: [
            ProfilePic(
              onImageSelected: (image) {
                setState(() {
                  _profileImage = image;
                });
                // Here you would typically upload the image to your server
              },
            ),
            const SizedBox(height: 20),
            _buildProfileMenu(
              context,
              icon: Icons.person_outline,
              text: "My Account",
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => UserProfileScreen(
                            user: widget.userModel,
                          )),
                );
              },
            ),
            _buildProfileMenu(
              context,
              icon: Icons.menu_book_outlined,
              text: "My Courses",
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const MyCoursePage()),
                );
              },
            ),
            _buildProfileMenu(
              context,
              icon: Icons.notifications_outlined,
              text: "Notifications",
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const NotificationsPage()),
                );
              },
            ),
            _buildProfileMenu(
              context,
              icon: Icons.settings_outlined,
              text: "Settings",
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const SettingsPage()),
                );
              },
            ),
            _buildProfileMenu(
              context,
              icon: Icons.help_outline,
              text: "Help Center",
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const HelpCenterPage()),
                );
              },
            ),
            _buildProfileMenu(
              context,
              icon: Icons.logout,
              text: "Log Out",
              isLogout: true,
              onPressed: () => _showLogoutDialog(context, authRepo),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileMenu(
    BuildContext context, {
    required IconData icon,
    required String text,
    required VoidCallback onPressed,
    bool isLogout = false,
  }) {
    return ListTile(
      leading: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: isLogout
              ? Colors.red.withOpacity(0.1)
              : Colors.blue.withOpacity(0.1),
          shape: BoxShape.circle,
        ),
        child: Icon(
          icon,
          color: isLogout ? Colors.red : Colors.blue,
        ),
      ),
      title: Text(
        text,
        style: TextStyle(
          fontWeight: FontWeight.w500,
          color: isLogout ? Colors.red : Colors.black,
        ),
      ),
      trailing: const Icon(Icons.arrow_forward_ios, size: 16),
      onTap: onPressed,
    );
  }

  Future<void> _showLogoutDialog(
      BuildContext context, AuthLocalRepository authRepo) async {
    await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Logout'),
        content: const Text('Are you sure you want to log out?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () async {
              await authRepo.removeToken();
              if (!mounted) return;
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (context) => const LoginPage()),
                (route) => false,
              );
            },
            child: const Text(
              'Logout',
              style: TextStyle(color: Colors.red),
            ),
          ),
        ],
      ),
    );
  }
}

class ProfilePic extends StatelessWidget {
  final Function(File?)? onImageSelected;
  final String? initialImageUrl;

  const ProfilePic({
    super.key,
    this.onImageSelected,
    this.initialImageUrl,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Stack(
        alignment: Alignment.bottomRight,
        children: [
          Container(
            width: 120,
            height: 120,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(
                color: Colors.grey.shade200,
                width: 2,
              ),
            ),
            child: ClipOval(
              child: initialImageUrl != null
                  ? Image.network(
                      initialImageUrl!,
                      fit: BoxFit.cover,
                      errorBuilder: (_, __, ___) => _buildDefaultAvatar(),
                    )
                  : _buildDefaultAvatar(),
            ),
          ),
          Positioned(
            right: 5,
            bottom: 5,
            child: GestureDetector(
              onTap: () => _showImageSourceDialog(context),
              child: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.blue,
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: Colors.white,
                    width: 2,
                  ),
                ),
                child: const Icon(
                  Icons.camera_alt,
                  color: Colors.white,
                  size: 20,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDefaultAvatar() {
    return const Icon(
      Icons.person,
      size: 60,
      color: Colors.grey,
    );
  }

  Future<void> _showImageSourceDialog(BuildContext context) async {
    final result = await showDialog<String>(
      context: context,
      builder: (context) => SimpleDialog(
        title: const Text('Select Image Source'),
        children: [
          SimpleDialogOption(
            onPressed: () => Navigator.pop(context, 'camera'),
            child: const Row(
              children: [
                Icon(Icons.camera_alt),
                SizedBox(width: 10),
                Text('Take Photo'),
              ],
            ),
          ),
          SimpleDialogOption(
            onPressed: () => Navigator.pop(context, 'gallery'),
            child: const Row(
              children: [
                Icon(Icons.photo_library),
                SizedBox(width: 10),
                Text('Choose from Gallery'),
              ],
            ),
          ),
        ],
      ),
    );

    if (result != null) {
      final picker = ImagePicker();
      final source =
          result == 'camera' ? ImageSource.camera : ImageSource.gallery;

      try {
        final pickedFile = await picker.pickImage(
          source: source,
          maxWidth: 800,
          maxHeight: 800,
          imageQuality: 85,
        );

        if (pickedFile != null && onImageSelected != null) {
          onImageSelected!(File(pickedFile.path));
        }
      } catch (e) {
        if (!context.mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: ${e.toString()}')),
        );
      }
    }
  }
}
