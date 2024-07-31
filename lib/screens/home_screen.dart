import 'package:flutter/material.dart';
import '../services/connectivity_service.dart';
import 'calc_screen.dart';
import 'sign_in_screen.dart';
import 'sign_up_screen.dart';
import 'package:provider/provider.dart';
import '../services/theme.dart';

class HomeScreen extends StatefulWidget {
  final int initialIndex;

  HomeScreen({required this.initialIndex});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late int _selectedIndex;

  final List<Widget> _screens = [
    SignUpScreen(),
    SignInScreen(),
    CalcScreen(),
  ];

  @override
  void initState() {
    super.initState();
    ConnectivityService.instance.checkCurrentConnectivity();
    _selectedIndex = widget.initialIndex;
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  void _onDrawerItemTapped(int index) {
    Navigator.pop(context);
    _onItemTapped(index);
  }

  @override
  Widget build(BuildContext context) {
    final themeNotifier = Provider.of<ThemeService>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text('App Menu'),
        actions: [
          Switch(
            value: themeNotifier.isDarkMode,
            onChanged: (value) {
              themeNotifier.toggleTheme();
            },
          ),
        ],
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            DrawerHeader(
              child: Text('Menu', style: TextStyle(color: Colors.blue)),
              decoration: BoxDecoration(color: Theme.of(context).primaryColor),
            ),
            ListTile(
              leading: Icon(Icons.person_add,
                  color: _selectedIndex == 0 ? Colors.blue : Theme.of(context).iconTheme.color),
              title: Text('Sign Up',
                  style: TextStyle(
                      color: _selectedIndex == 0 ? Colors.blue : Theme.of(context).textTheme.bodyLarge?.color)),
              onTap: () {
                _onDrawerItemTapped(0);
              },
            ),
            ListTile(
              leading: Icon(Icons.person,
                  color: _selectedIndex == 1 ? Colors.blue : Theme.of(context).iconTheme.color),
              title: Text('Sign In',
                  style: TextStyle(
                      color: _selectedIndex == 1 ? Colors.blue : Theme.of(context).textTheme.bodyLarge?.color)),
              onTap: () {
                _onDrawerItemTapped(1);
              },
            ),
            ListTile(
              leading: Icon(Icons.calculate,
                  color: _selectedIndex == 2 ? Colors.blue : Theme.of(context).iconTheme.color),
              title: Text('Calculator',
                  style: TextStyle(
                      color: _selectedIndex == 2 ? Colors.blue : Theme.of(context).textTheme.bodyLarge?.color)),
              onTap: () {
                _onDrawerItemTapped(2);
              },
            ),
          ],
        ),
      ),
      body: _screens[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.person_add),
            label: 'Sign Up',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Sign In',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.calculate),
            label: 'Calculator',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.blue,
        unselectedItemColor: Colors.grey,
        onTap: _onItemTapped,
      ),
    );
  }
}
