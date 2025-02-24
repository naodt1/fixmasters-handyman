import 'package:fixmasters_handyman_app/controller/auth_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconly/iconly.dart';

import '../../widgets/categoryCard.dart';

class SignupAdditionalInfoPage extends StatefulWidget {
  final String fullname;
  final String email;
  final String password;
  final String profilePic;
  final String phoneNumber;

  const SignupAdditionalInfoPage({
    Key? key,
    required this.fullname,
    required this.email,
    required this.password,
    required this.profilePic,
    required this.phoneNumber,
  }) : super(key: key);

  @override
  _SignupAdditionalInfoPageState createState() =>
      _SignupAdditionalInfoPageState();
}

class _SignupAdditionalInfoPageState extends State<SignupAdditionalInfoPage> {
  AuthController authController = Get.find();
  TextEditingController _gigTextController = TextEditingController();
  List<Map<String, dynamic>> gigs = [];
  String? _selectedLocation;
  Map<String, dynamic>? _selectedCategory;

  List<String> addisAbabaSubCities = [
    'Addis Ketema',
    'Akaky Kaliti',
    'Arada',
    'Bole',
    'Gullele',
    'Kirkos',
    'Kolfe Keranio',
    'Lideta',
    'Nifas Silk-Lafto',
    'Yeka'
  ];

  List<Map<String, dynamic>> gigCategories = [
    {'name': 'Plumbing', 'icon': Icons.plumbing},
    {'name': 'Electrical', 'icon': Icons.electric_bolt},
    {'name': 'Carpentry', 'icon': Icons.carpenter},
    {'name': 'Painting', 'icon': Icons.format_paint},
    {'name': 'Appliance Repair', 'icon': Icons.home_repair_service},
    {'name': 'Landscaping', 'icon': Icons.landscape},
    {'name': 'Cleaning', 'icon': Icons.clean_hands},
    {'name': 'Handyman Services', 'icon': Icons.category},
  ];

  void addGig() {
    setState(() {
      if (_gigTextController.text.isNotEmpty && _selectedCategory != null) {
        gigs.add({
          'gigName': _gigTextController.text,
          'category': _selectedCategory?['name'], // Store category name
        });
        _gigTextController.clear();
      }
    });
    Navigator.of(context).pop(); // Close the dialog
  }


  void signUp() async {
    if (_selectedLocation == null) {
      Get.snackbar('Error', 'Please select a location');
      return;
    }
    await authController.signUpWithEmailAndPassword(
      widget.fullname,
      widget.email,
      widget.password,
      widget
          .password, // Confirm password (not needed here as it's already checked)
      widget.profilePic,
      widget.phoneNumber,
      true,
      _selectedLocation!,
      gigs,
    );
  }

  Widget buildGigCards() {
    return gigs.isEmpty
        ? Container(
            padding: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                  width: 1, color: Theme.of(context).colorScheme.primary),
            ),
            child: Center(
              child: Text('No Gigs'),
            ),
          )
        : GridView.builder(
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        mainAxisSpacing: 5.0,
        crossAxisSpacing: 5.0,
        childAspectRatio: 2.0,
      ),
      itemCount: gigs.length,
      itemBuilder: (context, index) {
        return CategoryCard(
          // Use category name instead of icon
          iconData: gigCategories.firstWhere((category) => category['name'] == gigs[index]['category'])['icon'],
          categoryName: gigs[index]['gigName'], // Use gig name
        );
      },
    );

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 14.0, vertical: 14.0),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 10),
                Text(
                  'Additional Information',
                  style: Theme.of(context).textTheme.headline6,
                ),
                SizedBox(height: 6),
                Form(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Location'),
                      SizedBox(height: 10),
                      DropdownButtonFormField<String>(
                        value: _selectedLocation,
                        items: addisAbabaSubCities.map((String location) {
                          return DropdownMenuItem<String>(
                            value: location,
                            child: Text(location),
                          );
                        }).toList(),
                        onChanged: (newValue) {
                          setState(() {
                            _selectedLocation = newValue;
                          });
                        },
                        decoration: InputDecoration(
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                          contentPadding: EdgeInsets.symmetric(
                              vertical: 12.0, horizontal: 16.0),
                        ),
                      ),
                      SizedBox(height: 20),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('Gigs'),
                          IconButton(
                              onPressed: () {
                                showDialog(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return AlertDialog(
                                      title: Text('Add Gig'),
                                      content: Column(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          TextField(
                                            controller: _gigTextController,
                                            decoration: InputDecoration(
                                              hintText: 'Enter your gig',
                                            ),
                                          ),
                                          SizedBox(height: 20),
                                          DropdownButtonFormField<Map<String, dynamic>>(
                                            value: _selectedCategory,
                                            items: gigCategories.map((category) {
                                              return DropdownMenuItem<Map<String, dynamic>>(
                                                value: category,
                                                child: Row(
                                                  children: [
                                                    Icon(category['icon']),
                                                    SizedBox(width: 8.0),
                                                    Text(category['name']),
                                                  ],
                                                ),
                                              );
                                            }).toList(),
                                            onChanged: (newValue) {
                                              setState(() {
                                                _selectedCategory = newValue;
                                              });
                                            },
                                            decoration: InputDecoration(
                                              border: OutlineInputBorder(
                                                borderRadius: BorderRadius.circular(10.0),
                                              ),
                                              contentPadding: EdgeInsets.symmetric(
                                                vertical: 12.0,
                                                horizontal: 16.0,
                                              ),
                                            ),
                                          ),
                                          SizedBox(height: 20),
                                          ElevatedButton(
                                            onPressed: addGig,
                                            child: Text('Add'),
                                          ),
                                        ],
                                      ),
                                    );

                                  },
                                );
                              },
                              icon: Icon(Icons.add))
                        ],
                      ),
                      SizedBox(height: 10),
                      buildGigCards(),
                      SizedBox(height: 20),
                      ElevatedButton(
                        onPressed: signUp,
                        child: Text('Sign Up'),
                        style: ElevatedButton.styleFrom(
                          padding: EdgeInsets.symmetric(vertical: 14.0),
                          minimumSize: Size(double.infinity, 0),
                        ),
                      ),
                      SizedBox(height: 12),
                      Center(
                        child: TextButton(
                          onPressed: () {
                            Get.back();
                          },
                          child: RichText(
                            text: TextSpan(
                              text: 'Back to previous step',
                              style: TextStyle(
                                  color: Theme.of(context)
                                      .colorScheme
                                      .onBackground),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
