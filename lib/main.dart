import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'screens/home_screen.dart';
import 'screens/settings_screen.dart';
import 'screens/profile_screen.dart';
import 'screens/notifications_screen.dart';
import 'screens/calculator_screen.dart';
import 'screens/signIn_scrren.dart';
import 'screens/signUp_screen.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider<ThemeManager>(
          create: (_) => ThemeManager(),
        ),
        ChangeNotifierProvider<NetworkStatus>(
          create: (_) => NetworkStatus(),
        ),
      ],
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer2<ThemeManager, NetworkStatus>(
      builder: (context, themeManager, networkStatus, child) {
        return MaterialApp(
          title: 'Tab Navigation Drawer',
          theme:
              themeManager.isDarkTheme ? ThemeData.dark() : ThemeData.light(),
          home: MyHomePage(networkStatus: networkStatus),
          routes: {
            SignInScreen.routeName: (context) => SignInScreen(),
            SignUpScreen.routeName: (context) => SignUpScreen(),
          },
        );
      },
    );
  }
}

class MyHomePage extends StatefulWidget {
  final NetworkStatus networkStatus;

  MyHomePage({required this.networkStatus});

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 5, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final themeManager = Provider.of<ThemeManager>(context);

    return SafeArea(
      bottom: false,
      child: Scaffold(
        appBar: AppBar(
          title: Text('Tab Navigation Drawer'),
        ),
        drawer: Drawer(
          child: ListView(
            children: [
              DrawerHeader(
                child: Text('Menu'),
                decoration: BoxDecoration(
                  color: Colors.blue,
                ),
              ),
              ListTile(
                leading: Icon(Icons.home),
                title: Text('Home'),
                onTap: () {
                  _tabController.animateTo(0);
                  Navigator.pop(context);
                },
              ),
              ListTile(
                leading: Icon(Icons.calculate),
                title: Text('Calculator'),
                onTap: () {
                  _tabController.animateTo(1);
                  Navigator.pop(context);
                },
              ),
              ListTile(
                leading: Icon(Icons.settings),
                title: Text('Settings'),
                onTap: () {
                  _tabController.animateTo(2);
                  Navigator.pop(context);
                },
              ),
              ListTile(
                leading: Icon(Icons.person),
                title: Text('Profile'),
                onTap: () {
                  _tabController.animateTo(3);
                  Navigator.pop(context);
                },
              ),
              ListTile(
                leading: Icon(Icons.notifications),
                title: Text('Notifications'),
                onTap: () {
                  _tabController.animateTo(4);
                  Navigator.pop(context);
                },
              ),
              Divider(),
              ListTile(
                leading: Icon(Icons.brightness_4),
                title: Text('Dark Theme'),
                trailing: Switch(
                  value: themeManager.isDarkTheme,
                  onChanged: (value) {
                    themeManager.toggleTheme();
                  },
                ),
              ),
              ListTile(
                leading: Icon(Icons.login),
                title: Text('Sign In'),
                onTap: () {
                  Navigator.pop(context);
                  Navigator.pushNamed(context, SignInScreen.routeName);
                },
              ),
              ListTile(
                leading: Icon(Icons.app_registration),
                title: Text('Sign Up'),
                onTap: () {
                  Navigator.pop(context);
                  Navigator.pushNamed(context, SignUpScreen.routeName);
                },
              ),
            ],
          ),
        ),
        body: TabBarView(
          controller: _tabController,
          children: [
            HomeScreen(networkStatus: widget.networkStatus),
            CalculatorScreen(),
            SettingsScreen(),
            ProfileScreen(),
            NotificationsScreen(),
          ],
        ),
        bottomNavigationBar: Material(
          color: Colors.blue,
          child: TabBar(
            controller: _tabController,
            tabs: [
              Tab(
                icon: Icon(Icons.home),
                text: 'Home',
              ),
              Tab(
                icon: Icon(Icons.calculate),
                text: 'Calculator',
              ),
              Tab(
                icon: Icon(Icons.settings),
                text: 'Settings',
              ),
              Tab(
                icon: Icon(Icons.person),
                text: 'Profile',
              ),
              Tab(
                icon: Icon(Icons.notifications),
                text: 'Notifications',
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class ThemeManager with ChangeNotifier {
  late bool _isDarkTheme;

  bool get isDarkTheme => _isDarkTheme;

  ThemeManager() {
    _loadThemePreference();
  }

  void toggleTheme() {
    _isDarkTheme = !_isDarkTheme;
    _saveThemePreference();
    notifyListeners();
  }

  Future<void> _loadThemePreference() async {
    final prefs = await SharedPreferences.getInstance();
    _isDarkTheme = prefs.getBool('isDarkTheme') ?? false;
    notifyListeners();
  }

  Future<void> _saveThemePreference() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setBool('isDarkTheme', _isDarkTheme);
  }
}

class NetworkStatus with ChangeNotifier {
  bool _isConnected = true;

  bool get isConnected => _isConnected;

  void updateNetworkStatus(bool isConnected) {
    _isConnected = isConnected;
    notifyListeners();
  }
}

class MyWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final networkStatus = Provider.of<NetworkStatus>(context);

    return Container(
      child: Text(networkStatus.isConnected ? 'Connected' : 'Disconnected'),
    );
  }
}

class HomeScreen extends StatelessWidget {
  final NetworkStatus networkStatus;

  HomeScreen({required this.networkStatus});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Home'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => MyWidget()),
                );
              },
              child: Text('Open MyWidget'),
            ),
            SizedBox(height: 20),
            Text(
              networkStatus.isConnected ? 'Connected' : 'Disconnected',
              style: TextStyle(fontSize: 20),
            ),
          ],
        ),
      ),
    );
  }
}

class SignInScreen extends StatelessWidget {
  static const routeName = '/signIn';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Sign In'),
      ),
      body: Center(
        child: Text('Sign In Screen'),
      ),
    );
  }
}

class SignUpScreen extends StatelessWidget {
  static const routeName = '/signUp';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Sign Up'),
      ),
      body: Center(
        child: Text('Sign Up Screen'),
      ),
    );
  }
}
