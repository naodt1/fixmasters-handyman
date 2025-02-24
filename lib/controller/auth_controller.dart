import 'package:fixmasters_handyman_app/controller/user_controller.dart';
import 'package:get/get.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AuthController extends GetxController {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  late Rx<User?> _user;

  @override
  void onReady() {
    super.onReady();
    _user = Rx<User?>(_firebaseAuth.currentUser);
    _user.bindStream(_firebaseAuth.userChanges());
    ever(_user, _initialScreen); // Update the UI based on user authentication status
  }

  void _initialScreen(User? user) {
    if (user == null) {
      Get.snackbar('Auth', 'Login');
      Get.offAllNamed('/login');
    } else {
      Get.offAllNamed('/');
    }
  }

  Future<UserCredential> signInWithEmailAndPassword(String email, String password) async {
    try {
      UserCredential userCredential = await _firebaseAuth.signInWithEmailAndPassword(email: email, password: password);
      await Get.find<UserController>().updateActiveStatus(true);
      return userCredential;
    } on FirebaseAuthException catch (e) {
      throw Exception(e.message);
    }
  }

  Future<void> signOut() async {
    await Get.find<UserController>().updateActiveStatus(false);
    await _firebaseAuth.signOut();
  }

  Future<UserCredential> signUpWithEmailAndPassword(
      String fullname,
      String email,
      String password,
      String confirmPassword,
      String proPicImg,
      String phoneNumber,
      bool isHandyman,
      String location,
      List<Map<String, dynamic>> gigs) async {
    try {
      QuerySnapshot query = await _firestore.collection('users').where('email', isEqualTo: email).get();
      if (query.docs.isNotEmpty) {
        throw Exception("Username already exists. Please choose a different one.");
      }

      UserCredential userCredential = await _firebaseAuth.createUserWithEmailAndPassword(email: email, password: password);

      await _firestore.collection('users').doc(userCredential.user!.uid).set({
        'uid': userCredential.user!.uid,
        'email': email,
        'fullname': fullname,
        'phone_number': phoneNumber,
        'profilePic': proPicImg,
        'is_online': true,
        'is_handyman': isHandyman,
        'last_active': DateTime.now().millisecondsSinceEpoch.toString(),
        'location': location,
      });

      if (isHandyman) {
        DocumentReference handymanRef = _firestore.collection('handymen').doc(userCredential.user!.uid);
        await handymanRef.set({
          'uid': userCredential.user!.uid,
          'avg_rating': 0,
          'total_jobs': 0,
          'response_time': '',
        });

        CollectionReference gigsCollection = handymanRef.collection('gigs');
        for (var gig in gigs) {
          // Store only the necessary information about the gig in Firestore
          await gigsCollection.add({
            'gigName': gig['gigName'],
            'category': gig['category'], // Store category name
          });
        }

      }

      return userCredential;
    } on FirebaseAuthException catch (e) {
      throw Exception(e.message);
    }
  }
}
