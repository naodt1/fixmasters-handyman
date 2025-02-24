import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:iconly/iconly.dart';

import '../../../controller/bottom_nav_controller.dart';
import '../../../controller/chatController.dart';
import '../../../service/profilePictureService.dart';
import '../../widgets/bottomNav.dart';
import '../../widgets/chatListCard.dart';
import '../../widgets/loadingSkeletons/chatListSkeleton.dart';
import 'messagePage.dart';

class ChatPage extends StatefulWidget {
  const ChatPage({super.key});

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> with AutomaticKeepAliveClientMixin {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final ProfilePictureService _profilePictureService = ProfilePictureService();
  String? currentUserProfilePicUrl;

  @override
  void initState() {
    super.initState();
    _fetchCurrentUserProfilePic();
  }

  Future<void> _fetchCurrentUserProfilePic() async {
    String userId = _firebaseAuth.currentUser!.uid;
    String? profilePicUrl = await _profilePictureService.getProfilePictureUrl(userId);
    print(profilePicUrl);
    setState(() {
      currentUserProfilePicUrl = profilePicUrl;
    });
  }

  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Messages'),
        actions: [
          IconButton(
              onPressed: () async {
                Get.find<BottomNavigationController>().changePage(1);
                // String? selectedUser = await showSearch(
                //   context: context,
                //   delegate: UserSearchDelete(userServiceProvider: UserServiceProvider(),appBarColor: Theme.of(context).colorScheme.primary),
                // );
                // if (selectedUser != null) {
                //   // Handle the selected user
                //   print('Selected user: $selectedUser');
                // }
              },
              icon: Icon(IconlyLight.search)
          )
        ],
      ),
      body: StreamBuilder(
          stream: FirebaseFirestore.instance.collection('users').snapshots(),
          builder: (context, snapshot) {
            if(snapshot.hasError){
              return Text('Error');
            }

            if(snapshot.connectionState == ConnectionState.waiting){
              return Center(
                child: CircularProgressIndicator(),
              );
            }

            return ListView(
                children: snapshot.data!.docs.map<Widget>((doc) => _buildUserListItem(doc)).toList()
            );
          }
      ),
      bottomNavigationBar: CustomBottomNavigationBar(
        currentIndex: Get.find<BottomNavigationController>().currentIndex.toInt(),
        onTap: (index) {
          Get.find<BottomNavigationController>().changePage(index);
        },
      ),
    );
  }

  Widget _buildUserListItem(DocumentSnapshot document) {
    Map<String, dynamic> data = document.data()! as Map<String, dynamic>;
    ChatController _chatController = Get.find();

    if (_firebaseAuth.currentUser!.email != data['email']) {
      return StreamBuilder(
        stream: _chatController.getLatestChatStream(_firebaseAuth.currentUser!.uid, data['uid']),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return UserListItemSkeleton();
          }

          if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}');
          }

          // Check if there are any messages in the latest chat
          Map<String, dynamic> latestChatData = snapshot.data ?? {'message': 'No messages yet', 'timestamp': ''};
          String latestChat = latestChatData['message'];

          // If there are no messages, skip this user
          if (latestChat.isEmpty) {
            return Container();
          }

          String latestChatTime = latestChatData['timestamp'];

          return ChatListCard(
            chatUserName: data['fullname'],
            chatUserImg: data['profilePic'],
            latestChat: latestChat,
            latestChatTime: latestChatTime,
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => MessagePage(
                    chatUserName: data['fullname'],
                    chatUserImg: data['profilePic'],
                    isOnline: data['is_online'].toString(),
                    receiverId: data['uid'],
                    lastActive: data['last_active'] ?? '',
                  ),
                ),
              );
            },
          );
        },
      );
    } else {
      return Container();
    }
  }
}
