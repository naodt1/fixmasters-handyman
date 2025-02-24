import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import '../model/gigs_model.dart';
import '../model/handyman_model.dart';
import '../model/user_model.dart';
import '../utils/utilityFunctions.dart';

class UserController extends GetxController {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  late String uid;
  RxList<GigModel> userGigs = <GigModel>[].obs;
  Rx<Map<String, dynamic>> userData = Rx<Map<String, dynamic>>({});

  // Reactive variables for metrics
  RxString jobsCompleted = '0'.obs;
  RxString averageRating = '0'.obs;
  RxString responseTime = '0'.obs;

  @override
  void onInit() {
    super.onInit();
    initialize();
    fetchUserGigs();
    fetchUserMetrics();
    fetchUserData();
  }

  Future<void> initialize() async {
    User? user = _firebaseAuth.currentUser;
    if (user != null) {
      uid = user.uid;
    }
  }

  Future<void> updateActiveStatus(bool isOnline) async {
    await initialize();
    await _firestore.collection('users').doc(uid).update({
      'is_online': isOnline.toString(),
      'last_active': DateTime.now().millisecondsSinceEpoch.toString(),
    });
    update();
  }

  Stream<Map<String, String>> getOnlineStatusAndLastSeenStream(String userId) {
    return _firestore.collection('users').doc(userId).snapshots().map((snapshot) {
      final data = snapshot.data() as Map<String, dynamic>;
      final isOnline = data['is_online'] == 'true';
      final lastSeenTimestamp = data['last_active'] as String;
      final lastSeen = UtilityFunctions().formatLastActive(int.parse(lastSeenTimestamp));

      return {'isOnline': isOnline.toString(), 'lastSeen': lastSeen};
    });
  }

  Future<List<UserModel>> searchUsers(String query) async {
    QuerySnapshot querySnapshot;
    if (query.isEmpty) {
      querySnapshot = await _firestore.collection('users').get();
    } else {
      querySnapshot = await _firestore
          .collection('users')
          .where('username', isGreaterThanOrEqualTo: query)
          .where('username', isLessThan: query + 'z')
          .get();
    }

    List<UserModel> users = [];
    querySnapshot.docs.forEach((doc) {
      users.add(UserModel.fromMap(doc.data() as Map<String, dynamic>));
    });
    print(users);
    return users;
  }

  Future<void> fetchUserData() async {
    try {
      User? user = _firebaseAuth.currentUser;
      if (user != null) {
        DocumentSnapshot<Map<String, dynamic>> userDoc = await _firestore.collection('users').doc(user.uid).get();
        DocumentSnapshot<Map<String, dynamic>> handymenDoc = await _firestore.collection('handymen').doc(user.uid).get();

        Map<String, dynamic> userDataMap = {};

        if (userDoc.exists) {
          userDataMap = userDoc.data() as Map<String, dynamic>;
        }

        if (handymenDoc.exists) {
          final handymenData = handymenDoc.data() as Map<String, dynamic>;
          userDataMap.addAll(handymenData); // Merge handymen data into user data
        }

        // Add additional user information
        userDataMap['uid'] = user.uid;
        userDataMap['email'] = user.email;

        userData.value = userDataMap;
      }
    } catch (e) {
      print('Error fetching user data: $e');
    }
  }

  Future<bool> deleteUser() async {
    try {
      await initialize();
      await _firestore.collection('users').doc(uid).delete();
      await _firestore.collection('handymen').doc(uid).delete();

      QuerySnapshot chatRoomsSnapshot = await _firestore.collection('chat_rooms').where('users', arrayContains: uid).get();
      await Future.forEach(chatRoomsSnapshot.docs, (chatRoomDoc) async {
        await chatRoomDoc.reference.delete();
      });


      // String? profilePicPath = await fetchUserData().then((userData) => userData['profilePic']);
      // if (profilePicPath != null) {
      //   await FirebaseStorage.instance.refFromURL(profilePicPath).delete();
      // }

      await _firebaseAuth.currentUser!.delete();
      update();
      return true;
    } catch (e) {
      print('Error deleting user: $e');
      return false;
    }
  }

  Future<void> fetchUserGigs() async {
    try {
      await initialize();
      QuerySnapshot querySnapshot = await _firestore.collection('handymen').doc(uid).collection('gigs').get();

      List<GigModel> gigs = [];
      querySnapshot.docs.forEach((doc) {
        gigs.add(GigModel.fromMap(doc.data() as Map<String, dynamic>));
      });

      userGigs.assignAll(gigs); // Assign fetched gigs to userGigs
    } catch (e) {
      print('Error fetching user gigs: $e');
    }
  }

  Future<List<Map<String, dynamic>>> getUserNotifications() async {
    List<Map<String, dynamic>> notifications = [];

    try {
      await initialize();
      QuerySnapshot querySnapshot = await _firestore.collection('notifications').where('userId', isEqualTo: uid).get();

      querySnapshot.docs.forEach((doc) {
        notifications.add(doc.data() as Map<String, dynamic>);
      });
    } catch (e) {
      print('Error fetching user notifications: $e');
    }

    return notifications;
  }

  Future<Map<String, dynamic>> getUserProfileData() async {
    Map<String, dynamic> profileData = {};

    try {
      await initialize();
      DocumentSnapshot<Map<String, dynamic>> profileDoc = await _firestore.collection('profiles').doc(uid).get();

      if (profileDoc.exists) {
        profileData = profileDoc.data()!;
      }
    } catch (e) {
      print('Error fetching user profile data: $e');
    }

    return profileData;
  }

  // Fetch user metrics and update reactive variables
  Future<void> fetchUserMetrics() async {
    try {
      await initialize();
      DocumentSnapshot<Map<String, dynamic>> handymenDoc = await _firestore.collection('handymen').doc(uid).get();

      if (handymenDoc.exists) {
        final handyman = HandymanModel.fromMap(handymenDoc.data()!);
        jobsCompleted.value = handyman.jobsCompleted;
        averageRating.value = handyman.averageRating;
        responseTime.value = handyman.responseTime;
      }
    } catch (e) {
      print('Error fetching user metrics: $e');
    }
  }
}
