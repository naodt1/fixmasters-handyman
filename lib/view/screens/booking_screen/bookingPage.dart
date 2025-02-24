import 'package:fixmasters_handyman_app/controller/bottom_nav_controller.dart';
import 'package:fixmasters_handyman_app/view/widgets/bottomNav.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

class BookingPage extends StatelessWidget {
  const BookingPage({super.key});

  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      appBar: AppBar(
        title: Text('Bookings'),
      ),
      body: Center(
        child: Text('No Bookings Yet!'),
      ),
      bottomNavigationBar: CustomBottomNavigationBar(
        currentIndex: Get.find<BottomNavigationController>().currentIndex.toInt(),
        onTap: (index) {
          Get.find<BottomNavigationController>().changePage(index);
        },
      ),
    );
  }
}
