import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:online_training_template/models/user_model.dart';

class UserProfileScreen extends ConsumerStatefulWidget {
  final UserModel user;

  const UserProfileScreen({super.key, required this.user});

  @override
  ConsumerState<UserProfileScreen> createState() => _UserProfileScreenState();
}

class _UserProfileScreenState extends ConsumerState<UserProfileScreen> {
  File? _profileImage;
  late UserModel _currentUser;

  @override
  void initState() {
    super.initState();
    _currentUser = widget.user;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Profile'),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.edit),
            onPressed: () => _navigateToEditProfile(),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            _buildProfileHeader(),
            const SizedBox(height: 24),
            _buildUserInfoSection(),
            const SizedBox(height: 24),
            _buildAcademicInfoSection(),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileHeader() {
    return Column(
      children: [
        ProfilePicture(
          initialImageUrl:
              null, // You can add image URL from your model if available
          onImageSelected: (image) {
            setState(() {
              _profileImage = image;
            });
            // Here you would typically upload the image to your server
          },
        ),
        const SizedBox(height: 16),
        Text(
          _currentUser.name,
          style: const TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
        if (_currentUser.phone.isNotEmpty)
          Padding(
            padding: const EdgeInsets.only(top: 4),
            child: Text(
              _currentUser.phone,
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey[600],
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildUserInfoSection() {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Personal Information',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),
            _buildInfoRow(Icons.person, 'Name', _currentUser.name),
            _buildInfoRow(Icons.phone, 'Phone', _currentUser.phone),
          ],
        ),
      ),
    );
  }

  Widget _buildAcademicInfoSection() {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Academic Information',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),
            if (_currentUser.standard != null)
              _buildInfoRow(Icons.school, 'Standard', _currentUser.standard!),
            if (_currentUser.subject != null)
              _buildInfoRow(Icons.menu_book, 'Subject', _currentUser.subject!),
            if (_currentUser.course != null)
              _buildInfoRow(
                  Icons.cast_for_education, 'Course', _currentUser.course!),
            if (_currentUser.teacherId != null)
              _buildInfoRow(Icons.person_pin, 'Teacher ID',
                  _currentUser.teacherId.toString()),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(IconData icon, String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 24, color: Colors.blue),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey[600],
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
    );
  }

  void _navigateToEditProfile() {
    // Implement navigation to edit profile screen
    // Navigator.push(context, MaterialPageRoute(builder: (context) => EditProfileScreen(user: _currentUser)));
  }
}

class ProfilePicture extends StatelessWidget {
  final Function(File?)? onImageSelected;
  final String? initialImageUrl;

  const ProfilePicture({
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
