import 'package:chorebuddies_flutter/features/chores/chores_page.dart';
import 'package:chorebuddies_flutter/UI/pages/page_not_found.dart';
import 'package:chorebuddies_flutter/features/chat/chat_page.dart';
import 'package:chorebuddies_flutter/UI/pages/settings_page.dart';
import 'package:chorebuddies_flutter/features/households/household_management_page.dart';
import 'package:chorebuddies_flutter/utils/firebase_utils.dart';
import 'package:flutter/material.dart';
import '../pages/home_page.dart';

Map<String, dynamic>? pendingNotificationData;

class MainLayout extends StatefulWidget {
  const MainLayout({Key? key}) : super(key: key);

  @override
  MainLayoutState createState() => MainLayoutState();
}

class MainLayoutState extends State<MainLayout> {
  int _selectedIndex = 0;
  @override
  void initState() {
    super.initState();
    // Process pending notifications after first frame
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (pendingNotificationData != null) {
        print("Processing pending notification in MainLayout");
        handlePushScreen(pendingNotificationData!);
        pendingNotificationData = null;
      }
    });
  }

  void handlePushScreen(Map<String, dynamic> data) {
    final screen = data['screen'];
    if (screen != null && pushScreenIndexMap.containsKey(screen)) {
      setState(() {
        _selectedIndex = pushScreenIndexMap[screen]!;
      });
    }
  }

  final List<Widget> _pages = const [
    HomePage(),
    ChoresPage(),
    PageNotFound(),
    ChatPage(),
    HouseholdManagementPage(),
    SettingsPage(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        showUnselectedLabels: false,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.dashboard), label: 'Home'),
          BottomNavigationBarItem(
            icon: Icon(Icons.cleaning_services),
            label: 'Chores',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.emoji_events),
            label: 'Rewards',
          ),
          BottomNavigationBarItem(icon: Icon(Icons.chat), label: 'Chat'),
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Household'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
        ],
      ),
    );
  }
}
