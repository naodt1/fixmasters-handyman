import 'package:flutter/material.dart';
import 'package:get/get.dart';

class GigController extends GetxController {
  var isLoading = true.obs; // Observable for loading state
  var error = ''.obs; // Observable for error message
  var gigs = [].obs; // Observable list to store gigs

  void fetchGigs() async {
    try {
      // Simulate fetching gigs from a data source (e.g., Firestore)
      isLoading(true); // Set loading state to true
      // Replace this with your logic to fetch gigs

      // Once fetched, update the gigs list
      gigs([
        {"category": "Plumbing", "iconData": Icons.plumbing},
        {"category": "Electrical", "iconData": Icons.electrical_services},
        {"category": "Painting", "iconData": Icons.format_paint},
        {"category": "Cleaning", "iconData": Icons.cleaning_services},
      ]);
      isLoading(false); // Set loading state to false
    } catch (e) {
      // If an error occurs during fetching, set the error message
      error(e.toString());
      isLoading(false); // Set loading state to false
    }
  }

  @override
  void onInit() {
    fetchGigs(); // Fetch gigs when the controller is initialized
    super.onInit();
  }
}
