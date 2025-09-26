import 'package:fardinexpress/features/messager/screen/all_chat_page.dart';
import 'package:fardinexpress/features/notification/view/notification_page.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class MessageCenterWrapper extends StatelessWidget {
  const MessageCenterWrapper({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2, // Chats & Notifications
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Theme.of(context).primaryColor,
          title: const Text('Message Center',
              style: TextStyle(color: Colors.white)),
          iconTheme: const IconThemeData(color: Colors.white),
        ),
        body: SafeArea(
          child: Column(
            children: [
              // const SizedBox(height: 8),
              // // Title
              // const Align(
              //   alignment: Alignment.centerLeft,
              //   child: Padding(
              //     padding: EdgeInsets.symmetric(horizontal: 20),
              //     child: Text(
              //       'Messages',
              //       style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              //     ),
              //   ),
              // ),
              const SizedBox(height: 12),

              // TabBar (custom pill style)
              Container(
                margin: EdgeInsets.only(top: 10),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(25),
                  color: Color(0xFFEFF7F5), // background for inactive
                ),
                child: TabBar(
                  // labelPadding: EdgeInsets.symmetric(horizontal: 10),
                  indicator: BoxDecoration(
                    borderRadius: BorderRadius.circular(25),
                    color: Colors.green.shade600,
                  ),
                  dividerColor: Colors.white,
                  labelColor: Colors.white,
                  unselectedLabelColor: Colors.green.shade900,
                  tabs: [
                    Tab(
                      child: Container(
                        width: Get.width / 2,
                        child: Center(
                          child: Text("Chats"),
                        ),
                      ),
                    ),
                    Tab(
                      child: Container(
                        width: Get.width / 2,
                        child: Center(
                          child: Text("Notifications"),
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              // TabBarView
              Expanded(
                child: TabBarView(
                  children: [
                    // Chats tab
                    // _buildEmptyChats(context),
                    Container(
                        margin: EdgeInsets.only(top: 10),
                        child: ChatListScreen()),

                    // Notifications tab
                    // _buildEmptyNotifications(context),
                    NotificationPage(notificationType: NotificationType.widget),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildEmptyChats(BuildContext context) {
    return _emptyState(
      context,
      imageAsset: 'assets/images/photo_2025-08-12_18-59-04.jpg',
      title: 'Find your chats with our support\nspecialists here!',
      subtitle: 'You can also get help from them via our Help Centre.',
    );
  }

  Widget _buildEmptyNotifications(BuildContext context) {
    return _emptyState(
      context,
      imageAsset: 'assets/images/photo_2025-08-12_18-59-04.jpg',
      title: 'No notifications yet!',
      subtitle: 'When you have updates, they will appear here.',
    );
  }

  Widget _emptyState(BuildContext context,
      {required String imageAsset,
      required String title,
      required String subtitle}) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          title,
          textAlign: TextAlign.center,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 12),
        RichText(
          textAlign: TextAlign.center,
          text: TextSpan(
            style: TextStyle(
              color: Colors.grey[700],
              fontSize: 14,
            ),
            children: [
              TextSpan(text: subtitle.split('Help Centre.').first),
              TextSpan(
                text: 'Help Centre.',
                style: const TextStyle(
                  color: Colors.green,
                  fontWeight: FontWeight.w600,
                  decoration: TextDecoration.underline,
                ),
                recognizer: TapGestureRecognizer()
                  ..onTap = () {
                    // Handle Help Centre tap
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Open Help Centre')),
                    );
                  },
              ),
            ],
          ),
        ),
      ],
    );
  }
}
