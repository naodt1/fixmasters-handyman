// import 'package:fixmasters_user_app/controller/authController.dart';
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:flutter_otp_text_field/flutter_otp_text_field.dart';
//
// class OtpPage extends StatelessWidget {
//   final String verificationId;
//   final String phoneNumber;
//   OtpPage({super.key, required this.verificationId, required this.phoneNumber});
//
//   @override
//   Widget build(BuildContext context) {
//     AuthController authController = Get.find();
//     bool isLoading = authController.isLoading.value;
//
//     void verifyOtp(BuildContext context, String userOtp){
//       authController.verifyOtp(context: context, verificationId: verificationId, userOtp: userOtp, onSuccess: (){
//         authController.checkExistingUser().then((value) async => {
//           if(value == true){
//             //user exists
//
//           }else{
//             Get.toNamed('/')
//           }
//         });
//       });
//     }
//
//     return Scaffold(
//       body: Scaffold(
//         appBar: AppBar(
//
//         ),
//         body: Container(
//           padding: EdgeInsets.symmetric(vertical: 20,horizontal: 18),
//           child: isLoading ? CircularProgressIndicator() : Column(
//             crossAxisAlignment: CrossAxisAlignment.center,
//             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//             children: [
//               SizedBox(height: 14,),
//               Container(
//                 child: Column(
//                   children: [
//                     Text('Phone Verification', style: Theme.of(context).textTheme.titleLarge,),
//                     SizedBox(height: 16,),
//                     Text('Enter the OTP Sent to ${phoneNumber}'),
//                     SizedBox(height: 16,),
//                     OtpTextField(
//                       numberOfFields: 6,
//                       focusedBorderColor: Theme.of(context).colorScheme.secondary,
//                       borderColor: Theme.of(context).colorScheme.inversePrimary,
//                       //set to true to show as box or false to show as dash
//                       showFieldAsBox: true,
//                       //runs when a code is typed in
//                       onCodeChanged: (String code) {
//                         //handle validation or checks here
//                       },
//                       //runs when every textfield is filled
//                       onSubmit: (String verificationCode){
//                         if(verificationCode != null){
//                           //controller.verifyOtp(context, verificationCode!);
//                         }
//                         else{
//                           Get.snackbar(
//                             'Verification',
//                             'Enter 6-digit OTP Code',
//                             snackPosition: SnackPosition.BOTTOM
//                           );
//                         }
//                       }, // end onSubmit
//                     ),
//                   ],
//                 ),
//               ),
//               Container(
//                 width: MediaQuery.of(context).size.width/1.5,
//                 height: 45,
//                 child: ElevatedButton(
//                   onPressed: () {
//
//                   },
//                   child: Text(
//                       'Confirm'
//                   ),
//                 ),
//               )
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
