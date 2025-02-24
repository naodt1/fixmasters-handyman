import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../controller/auth_controller.dart';
import '../../../controller/bottom_nav_controller.dart';
import '../../../controller/user_controller.dart';
import '../../widgets/bottomNav.dart';

class ProfilePage extends StatelessWidget {
  ProfilePage({Key? key}) : super(key: key);

  final AuthController authController = Get.find();
  final UserController userController = Get.find();

  void signOut() async {
    try {
      await authController.signOut();
    } catch (e) {
      Get.snackbar('Error', 'Cannot Sign out');
    }
  }

  void deleteUser() async {
    try {
      bool deleted = await userController.deleteUser();
      if (deleted) {
        Get.snackbar('Success', 'User account deleted');
        // Navigate to login page after successful deletion
        Get.offAllNamed('/login');
      } else {
        Get.snackbar('Error', 'Failed to delete user account');
      }
    } catch (e) {
      Get.snackbar('Error', 'Failed to delete user account');
    }
  }

  void confirmSignOut(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Confirm Sign Out'),
          content: Text('Are you sure you want to sign out?'),
          actions: [
            TextButton(
              onPressed: () {
                Get.back();
              },
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                Get.back();
                signOut();
              },
              child: Text('Sign Out'),
            ),
          ],
        );
      },
    );
  }

  void confirmDeleteUser(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Confirm Delete Account'),
          content: Text('Are you sure you want to delete your account? This action cannot be undone.'),
          actions: [
            TextButton(
              onPressed: () {
                Get.back();
              },
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                Get.back();
                deleteUser();
              },
              child: Text('Delete'),
            ),
          ],
        );
      },
    );
  }

  void changeProfileImage() {
    // Handle change profile image action
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 20),
                Center(
                  child: Obx(
                        () {
                      final userData = userController.userData.value;
                      return Column(
                        children: [
                          Stack(
                            children: [
                              CircleAvatar(
                                radius: 60,
                                foregroundImage: NetworkImage(
                                  userData['profilePic'] ?? '',
                                ),
                              ),
                              Positioned(
                                bottom: 0,
                                right: 0,
                                child: IconButton(
                                  icon: Icon(Icons.camera_alt),
                                  onPressed: changeProfileImage,
                                  tooltip: 'Change Profile Image',
                                  color: Colors.grey,
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 10),
                          Text(
                            userData['fullname'] ?? 'No Name',
                            style: Theme.of(context).textTheme.headline5,
                          ),
                          SizedBox(height: 8),
                          Text(
                            userData['email'] ?? 'No Email',
                            style: Theme.of(context).textTheme.subtitle1,
                          ),
                          SizedBox(height: 8),
                          Text(
                            userData['bio'] ?? 'No bio available',
                            textAlign: TextAlign.center,
                            style: Theme.of(context).textTheme.bodyText2,
                          ),
                          SizedBox(height: 20),
                          Divider(),
                          SizedBox(height: 20),
                          _buildUserInfoRow(
                            context,
                            Icons.phone,
                            'Phone',
                            userData['phone_number'] ?? 'No Number',
                          ),
                          SizedBox(height: 20),
                          _buildUserInfoRow(
                            context,
                            Icons.location_city,
                            'Location',
                            userData['location'] ?? 'No Location',
                          ),
                          SizedBox(height: 20),
                        ],
                      );
                    },
                  ),
                ),
                SizedBox(height: 30),
                Text(
                  "Settings",
                  style: Theme.of(context).textTheme.headline6,
                ),
                SizedBox(height: 10),
                _buildSettingsTile(
                  context,
                  icon: Icons.logout,
                  label: 'Sign Out',
                  onTap: () => confirmSignOut(context),
                ),
                SizedBox(height: 10),
                _buildSettingsTile(
                  context,
                  icon: Icons.delete,
                  label: 'Delete Account',
                  onTap: () => confirmDeleteUser(context),
                ),
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: CustomBottomNavigationBar(
        currentIndex: Get.find<BottomNavigationController>().currentIndex.toInt(),
        onTap: (index) {
          Get.find<BottomNavigationController>().changePage(index);
        },
      ),
    );
  }

  Widget _buildUserInfoRow(BuildContext context, IconData icon, String label, String value) {
    return Row(
      children: [
        Icon(icon),
        SizedBox(width: 10),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: Theme.of(context).textTheme.subtitle2,
              ),
              SizedBox(height: 5),
              Text(
                value,
                style: Theme.of(context).textTheme.bodyText1,
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildSettingsTile(BuildContext context, {required IconData icon, required String label, required VoidCallback onTap}) {
    return ListTile(
      onTap: onTap,
      leading: Icon(icon),
      title: Text(label),
      trailing: Icon(Icons.arrow_forward_ios),
      tileColor: Theme.of(context).colorScheme.surface,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
    );
  }
}
