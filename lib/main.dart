import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:password_manager/vault/vault_screen.dart';
import 'firebase_options.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'login_page.dart';
import 'home_page.dart';
import 'password_generator_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: StreamBuilder<User?>(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return const MainPage();
          }
          return const LoginPage();
        },
      ),
    );
  }
}

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  int _selectedIndex = 0;

  static const List<Widget> _widgetOptions = <Widget>[
    HomePage(),
    PasswordGeneratorPage(),
    VaultScreen(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        // Use NavigationRail for wide screens (tablets, desktops)
        if (constraints.maxWidth > 600) {
          return Scaffold(
            body: Row(
              children: <Widget>[
                NavigationRail(
                  selectedIndex: _selectedIndex,
                  onDestinationSelected: _onItemTapped,
                  labelType: NavigationRailLabelType.all,
                  destinations: const <NavigationRailDestination>[
                    NavigationRailDestination(
                      icon: Icon(Icons.home_outlined),
                      selectedIcon: Icon(Icons.home),
                      label: Text('Home'),
                    ),
                    NavigationRailDestination(
                      icon: Icon(Icons.vpn_key_outlined),
                      selectedIcon: Icon(Icons.vpn_key),
                      label: Text('Password\nGenerator'),
                    ),
                    NavigationRailDestination(
                      icon: Icon(Icons.security_outlined),
                      selectedIcon: Icon(Icons.security),
                      label: Text('Vault'),
                    ),
                  ],
                ),
                const VerticalDivider(thickness: 1, width: 1),
                Expanded(
                  child: Center(
                    child: _widgetOptions.elementAt(_selectedIndex),
                  ),
                ),
              ],
            ),
          );
        }
        // Use BottomNavigationBar for narrow screens (phones)
        else {
          return Scaffold(
            body: Center(
              child: _widgetOptions.elementAt(_selectedIndex),
            ),
            bottomNavigationBar: BottomNavigationBar(
              items: const <BottomNavigationBarItem>[
                BottomNavigationBarItem(
                  icon: Icon(Icons.home),
                  label: 'Home',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.vpn_key),
                  label: 'Generator',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.security),
                  label: 'Vault',
                ),
              ],
              currentIndex: _selectedIndex,
              onTap: _onItemTapped,
            ),
          );
        }
      },
    );
  }
}