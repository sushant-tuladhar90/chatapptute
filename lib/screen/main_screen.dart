import 'package:flutter/material.dart';
import '../components/my_drawer.dart';
import '../pages/chat_page.dart';
import '../pages/contact_page.dart';
// import '../services/auth/auth_service.dart';
// import '../services/chat/chat_service.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  // Controller for PageView
  final PageController _pageController = PageController(initialPage: 0); // Start at ChatPage

  // Current selected index for bottom navigation bar
  int _selectedIndex = 0;

  // Titles for each page
  final List<String> _titles = [
    'Chats',    // ChatPage at index 0
    'Contacts', // ContactsPage at index 1
  ];

  // List of pages (Chat first, then Contacts)
  final List<Widget> _pages = [
    ChatPage(),        // ChatPage is now first
    const ContactsPage(), // ContactsPage is now second
  ];

  // Services
  // final ChatService _chatService = ChatService();
  // final AuthService _authService = AuthService();

  @override
  void initState() {
    super.initState();
    // _markMessagesAsDelivered();
  }

  // void _markMessagesAsDelivered() {
  //   final user = _authService.getCurrentUser();
  //   if (user != null) {
  //     _chatService.markMessagesAsDelivered(user.uid);
  //   }
  // }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      appBar: AppBar(
        title: Text(_titles[_selectedIndex]), // Dynamic title
      ),
      drawer: const MyDrawer(),

      body: PageView(
        controller: _pageController,
        onPageChanged: (index) {
          setState(() {
            _selectedIndex = index;
          });
        },
        children: _pages,
      ),

      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: (index) {
          setState(() {
            _selectedIndex = index;
            _pageController.animateToPage(
              index,
              duration: const Duration(milliseconds: 200),
              curve: Curves.easeInOut,
            );
          });
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.message),
            label: 'Chats', // Chat is now first
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.contacts),
            label: 'Contacts', // Contacts is now second
          ),
        ],
      ),
    );
  }
}
