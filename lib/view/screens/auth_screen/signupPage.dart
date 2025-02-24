import 'package:fixmasters_handyman_app/view/screens/auth_screen/signupAdditionalPage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:fixmasters_handyman_app/controller/auth_controller.dart';
import 'package:intl_phone_field/intl_phone_field.dart';

class SignupPage extends StatelessWidget {
  const SignupPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    AuthController authController = Get.find();

    final TextEditingController _fullNameTextController = TextEditingController();
    final TextEditingController _emailTextController = TextEditingController();
    final TextEditingController _passwordTextController = TextEditingController();
    final TextEditingController _confPasswordTextController = TextEditingController();
    final TextEditingController _phoneNumberTextController = TextEditingController();
    String? _countryCode = '251'; // Default country code

    final _formKey = GlobalKey<FormState>();

    void goToNextStep() {
      if (_formKey.currentState?.validate() ?? false) {
        String fullname = _fullNameTextController.text;
        String email = _emailTextController.text;
        String password = _passwordTextController.text;
        String phoneNumber = _phoneNumberTextController.text;
        String defaultProfilePic = "https://cdn.pixabay.com/photo/2015/10/05/22/37/blank-profile-picture-973460_960_720.png";

        Get.to(() => SignupAdditionalInfoPage(
          fullname: fullname,
          email: email,
          password: password,
          profilePic: defaultProfilePic,
          phoneNumber: '$_countryCode$phoneNumber',
        ),transition: Transition.rightToLeftWithFade);
      }
    }

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
                  'Create Account',
                  style: Theme.of(context).textTheme.headline6,
                ),
                SizedBox(height: 6),
                Text(
                  'Find services around you',
                  style: Theme.of(context).textTheme.bodyText2,
                ),
                SizedBox(height: 30),
                Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Fullname'),
                      SizedBox(height: 10),
                      TextFormField(
                        controller: _fullNameTextController,
                        decoration: InputDecoration(
                          hintText: 'Fullname...',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                          contentPadding: EdgeInsets.symmetric(vertical: 12.0, horizontal: 16.0),
                        ),
                        keyboardType: TextInputType.text,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter your fullname';
                          }
                          return null;
                        },
                      ),
                      SizedBox(height: 20),
                      Text('Email'),
                      SizedBox(height: 10),
                      TextFormField(
                        controller: _emailTextController,
                        decoration: InputDecoration(
                          hintText: 'Enter your email',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                          contentPadding: EdgeInsets.symmetric(vertical: 12.0, horizontal: 16.0),
                        ),
                        keyboardType: TextInputType.emailAddress,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter your email';
                          } else if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value)) {
                            return 'Please enter a valid email address';
                          }
                          return null;
                        },
                      ),
                      SizedBox(height: 20),
                      Text('Password'),
                      SizedBox(height: 10),
                      TextFormField(
                        controller: _passwordTextController,
                        decoration: InputDecoration(
                          hintText: 'Enter your password',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                          contentPadding: EdgeInsets.symmetric(vertical: 12.0, horizontal: 16.0),
                        ),
                        obscureText: true,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter your password';
                          } else if (value.length < 6) {
                            return 'Password must be at least 6 characters long';
                          }
                          return null;
                        },
                      ),
                      SizedBox(height: 20),
                      Text('Confirm Password'),
                      SizedBox(height: 10),
                      TextFormField(
                        controller: _confPasswordTextController,
                        decoration: InputDecoration(
                          hintText: 'Confirm your password',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                          contentPadding: EdgeInsets.symmetric(vertical: 12.0, horizontal: 16.0),
                        ),
                        obscureText: true,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please confirm your password';
                          } else if (value != _passwordTextController.text) {
                            return 'Passwords do not match';
                          }
                          return null;
                        },
                      ),
                      SizedBox(height: 20),
                      Text('Phone Number'),
                      SizedBox(height: 10),
                      IntlPhoneField(
                        controller: _phoneNumberTextController,
                        initialCountryCode: _countryCode,
                        onChanged: (phone) {
                          _countryCode = phone.countryCode;
                        },
                        decoration: InputDecoration(
                          hintText: 'Phone Number...',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                          contentPadding: EdgeInsets.symmetric(vertical: 12.0, horizontal: 16.0),
                        ),
                        validator: (value) {
                          if (value == null || value.completeNumber.isEmpty) {
                            return 'Please enter your phone number';
                          }
                          return null;
                        },
                      ),
                      SizedBox(height: 30),
                      ElevatedButton.icon(
                        onPressed: goToNextStep,
                        icon: Icon(Icons.arrow_forward),
                        label: Text('Next'),
                        style: ElevatedButton.styleFrom(
                          padding: EdgeInsets.symmetric(vertical: 14.0),
                          minimumSize: Size(double.infinity, 0),
                        ),
                      ),
                      SizedBox(height: 12),
                      Center(
                        child: TextButton(
                          onPressed: () {
                            Get.toNamed('/login');
                          },
                          child: RichText(
                            text: TextSpan(
                              text: 'Already have an account? ',
                              style: TextStyle(color: Theme.of(context).colorScheme.onBackground),
                              children: <TextSpan>[
                                TextSpan(
                                  text: 'Login',
                                  style: TextStyle(color: Theme.of(context).colorScheme.primary),
                                ),
                              ],
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
