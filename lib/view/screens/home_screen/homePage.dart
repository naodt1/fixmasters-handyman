import 'package:fixmasters_handyman_app/controller/bottom_nav_controller.dart';
import 'package:fixmasters_handyman_app/utils/utilityFunctions.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:fixmasters_handyman_app/view/widgets/bottomNav.dart';
import 'package:fixmasters_handyman_app/view/widgets/categoryCard.dart';

import '../../../controller/user_controller.dart';
import '../../../model/gigs_model.dart';


class HomePage extends StatelessWidget {
  HomePage({Key? key}) : super(key: key);

  UtilityFunctions utilityFunctions = UtilityFunctions();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('FixMasters'),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 14.0, vertical: 2.0),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 20),
                _buildSectionTitle(context, 'Service Metrics'),
                _buildServiceMetrics(context),
                SizedBox(height: 20),
                _buildSectionTitle(context, 'New Requests'),
                _buildNewRequests(context),
                SizedBox(height: 20),
                _buildSectionTitle(context, 'My Gigs'),
                _buildGridCategory(context),
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
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        child: Icon(Icons.add),
        tooltip: 'Add Gig',
      ),
    );
  }

  Widget _buildSectionTitle(BuildContext context, String title) {
    return Padding(
        padding: const EdgeInsets.only(bottom: 10.0),
    child: Text(
    title,
    style: TextStyle(
      fontWeight: FontWeight.bold,
      fontSize: 16,
    ),
    ),
    );
  }

  Widget _buildServiceMetrics(BuildContext context) {
    return GetX<UserController>(
      builder: (controller) {
        return Container(
          padding: EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.onBackground.withOpacity(0.1),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildKPI('Jobs Completed', controller.jobsCompleted.value),
              _buildKPI('Average Rating', controller.averageRating.value),
              _buildKPI('Response Time', controller.responseTime.value),
            ],
          ),
        );
      },
    );
  }

  Widget _buildKPI(String title, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(title),
          Text(
            value,
            style: TextStyle(
              color: Colors.green,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNewRequests(BuildContext context) {
    final ColorScheme colorScheme = Theme.of(context).colorScheme;
    return Container(
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: colorScheme.onBackground.withOpacity(0.1),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildNewRequestItem('John Doe', 'Plumbing', '12:30 PM'),
          _buildNewRequestItem('Jane Smith', 'Electrical', '2:00 PM'),
        ],
      ),
    );
  }

  Widget _buildNewRequestItem(String clientName, String serviceType, String time) {
    return ListTile(
      title: Text(clientName),
      subtitle: Text(serviceType),
      trailing: Text(time),
      onTap: () {
        // Handle tapping on a new request
      },
    );
  }

  Widget _buildGridCategory(BuildContext context) {
    return GetX<UserController>(
      initState: (_) => Get.find<UserController>().fetchUserGigs(), // Fetch gigs when the widget is initialized
      builder: (userController) {
        final userGigs = userController.userGigs;
        if (userGigs == null) {
          return CircularProgressIndicator(); // Show loading indicator while data is being fetched
        }
        if (userGigs.isEmpty) {
          return Container(
            padding: EdgeInsets.all(12),
            child: Center(child: Text('No gigs yet!')),
          ); // Show message if there are no gigs
        }
        return SizedBox(
          height: MediaQuery.of(context).size.height * 0.5, // Set a specific height
          child: GridView.builder(
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3, // Number of columns in the grid
              crossAxisSpacing: 8.0, // Spacing between columns
              mainAxisSpacing: 8.0, // Spacing between rows
            ),
            itemCount: userGigs.length,
            itemBuilder: (context, index) {
              // Access gig data at the current index
              GigModel gig = userGigs[index]; // Change here

              return InkWell(
                onTap: () {
                  // Handle gig tap
                },
                child: CategoryCard(
                  iconData: utilityFunctions.getCategoryIcon(gig.category), // Change here
                  categoryName: gig.gigName ?? 'No Category', // Change here
                ),
              );
            },
          ),
        );
      },
    );
  }
}
