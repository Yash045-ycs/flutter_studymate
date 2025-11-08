import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'dashboard.dart';  
import '../../explore/views/explore.dart';  
import '../../profile/views/profile.dart';  
import '../../settings/views/settings.dart'; 


const Color burntOrange = Color(0xFFC95C27);
const Color titleBrown = Color(0xFF5B3F30);

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _index = 0;
  final _titles = ['Dashboard', 'Explore', 'Profile', 'Settings'];

  late final _tabs = [
    DashboardTab(),
    ExploreTab(),
    ProfileTab(),
    SettingsTab(),
  ];

  Widget _logoMark([double s = 24]) => Container(
        width: s,
        height: s,
        decoration: const BoxDecoration(
          color: burntOrange,
          shape: BoxShape.circle,
        ),
        alignment: Alignment.center,
        child: const Icon(Icons.menu_book_rounded, size: 14, color: Colors.white),
      );

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;

    return Scaffold(
      appBar: AppBar(
        elevation: 0.6,
        backgroundColor: const Color.fromARGB(240, 255, 255, 255),
        foregroundColor: titleBrown,
        titleSpacing: 0,
        title: Row(
          children: [
            const SizedBox(width: 8),
            _logoMark(26),
            const SizedBox(width: 10),
            Text(
              _titles[_index],
              style: const TextStyle(
                fontWeight: FontWeight.w800,
                color: titleBrown,
              ),
            ),
          ],
        ),
        actions: [
          if (_index == 0)
            IconButton(
              icon: const Icon(Icons.search),
              onPressed: () {},
            ),
          IconButton(
            icon: const Icon(Icons.notifications_outlined),
            onPressed: () => ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('No new notifications')),
            ),
          ),
          const SizedBox(width: 4),
        ],
      ),
      drawer: Drawer(
        child: SafeArea(
          child: Column(
            children: [
              Container(
                padding: const EdgeInsets.all(16),
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Color(0xFFFFE9D6), Color(0xFFF7E9D7)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                ),
                child: Row(
                  children: [
                    _logoMark(42),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Study Mate',
                            style: TextStyle(
                              color: titleBrown,
                              fontSize: 18,
                              fontWeight: FontWeight.w900,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            user?.email ?? 'Not signed in',
                            style: const TextStyle(
                              color: Color.fromARGB(255, 121, 85, 72),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const Spacer(),
              const Divider(height: 1),
              ListTile(
                leading: const Icon(Icons.info_outline, color: titleBrown),
                title: const Text('About', style: TextStyle(color: titleBrown)),
                onTap: () => showAboutDialog(
                  context: context,
                  applicationName: 'Study Mate',
                  applicationVersion: 'v1.0.0',
                ),
              ),
              ListTile(
                leading: const Icon(Icons.logout, color: titleBrown),
                title: const Text('Logout', style: TextStyle(color: titleBrown)),
                onTap: () {
                  showDialog(
                    context: context,
                    builder: (ctx) => AlertDialog(
                      title: const Text("Logout"),
                      content: const Text("Do you want to logout?"),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.of(ctx).pop(),
                          child: const Text("Cancel"),
                        ),
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: burntOrange,
                          ),
                          onPressed: () async {
                            Navigator.of(ctx).pop();
                            await FirebaseAuth.instance.signOut();
                            if (!mounted) return;
                            Navigator.pushReplacementNamed(context, '/auth');
                          },
                          child: const Text("Logout"),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
      body: Stack(
        children: [
          Positioned.fill(
            child: Image.asset(
              'assets/images/studymate.png',
              fit: BoxFit.cover,
            ),
          ),
          Positioned.fill(
            child: Container(color: const Color.fromARGB(25, 255, 255, 255)),
          ),
          IndexedStack(index: _index, children: _tabs),
        ],
      ),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border(
            top: BorderSide(color: Colors.black.withAlpha(15)),
          ),
        ),
        child: NavigationBar(
          backgroundColor: Colors.white,
          indicatorColor: const Color.fromARGB(45, 201, 92, 39),
          surfaceTintColor: Colors.transparent,
          selectedIndex: _index,
          onDestinationSelected: (i) => setState(() => _index = i),
          destinations: const [
            NavigationDestination(
              icon: Icon(Icons.dashboard_outlined),
              selectedIcon: Icon(Icons.dashboard, color: burntOrange),
              label: 'Home',
            ),
            NavigationDestination(
              icon: Icon(Icons.explore_outlined),
              selectedIcon: Icon(Icons.explore, color: burntOrange),
              label: 'Explore',
            ),
            NavigationDestination(
              icon: Icon(Icons.person_outline),
              selectedIcon: Icon(Icons.person, color: burntOrange),
              label: 'Profile',
            ),
            NavigationDestination(
              icon: Icon(Icons.settings_outlined),
              selectedIcon: Icon(Icons.settings, color: burntOrange),
              label: 'Settings',
            ),
          ],
        ),
      ),
    );
  }
}
