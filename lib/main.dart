import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_zoom_drawer/flutter_zoom_drawer.dart';
import 'menu_screen.dart';

void main() => runApp(const TasbihApp());

class TasbihApp extends StatelessWidget {
  const TasbihApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        brightness: Brightness.light,
        primaryColor: const Color(0xFF34495E),
      ),
      darkTheme: ThemeData(
        brightness: Brightness.dark,
        primaryColor: const Color(0xFF2C3E50),
        scaffoldBackgroundColor: const Color(0xFF2C3E50),
      ),
      themeMode: ThemeMode.system,
      home: const TasbihScreen(),
    );
  }
}

class TasbihScreen extends StatefulWidget {
  const TasbihScreen({Key? key}) : super(key: key);

  @override
  TasbihScreenState createState() => TasbihScreenState();
}

class TasbihScreenState extends State<TasbihScreen> {
  int _counter = 0;
  bool _isSoundOn = true;
  bool _isDarkMode = true;
  bool _isLocked = false;
  final String _counterKey = 'counter';
  final String _selectedDhikrKey = 'selectedDhikr';
  int _selectedDhikrIndex = 0;
  final ZoomDrawerController zoomDrawerController = ZoomDrawerController();

  final List<Map<String, dynamic>> _presetDhikr = [
    {'name': 'SubhanAllah', 'count': 33},
    {'name': 'Alhamdulillah', 'count': 33},
    {'name': 'Allahu Akbar', 'count': 34},
    {'name': 'Astaghfirullah', 'count': 100},
    {'name': 'La ilaha illallah', 'count': 100},
    {'name': 'Custom', 'count': 1000},
  ];

  @override
  void initState() {
    super.initState();
    _loadPreferences();
  }

  void _loadPreferences() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _counter = prefs.getInt(_counterKey) ?? 0;
      _selectedDhikrIndex = prefs.getInt(_selectedDhikrKey) ?? 0;
    });
  }

  void _savePreferences() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(_counterKey, _counter);
    await prefs.setInt(_selectedDhikrKey, _selectedDhikrIndex);
  }

  void _incrementCounter() {
    if (!_isLocked) {
      setState(() {
        _counter++;
        if (_counter >= _presetDhikr[_selectedDhikrIndex]['count']) {
          _counter = _presetDhikr[_selectedDhikrIndex]['count'];
        }
        _savePreferences();
      });
    }
  }

  void _resetCounter() {
    if (!_isLocked) {
      setState(() {
        _counter = 0;
        _savePreferences();
      });
    }
  }

  void _toggleSound() {
    setState(() {
      _isSoundOn = !_isSoundOn;
    });
  }

  void _toggleTheme() {
    setState(() {
      _isDarkMode = !_isDarkMode;
    });
  }

  void _toggleLock() {
    setState(() {
      _isLocked = !_isLocked;
    });
  }

  void _selectDhikr(int index) {
    setState(() {
      _selectedDhikrIndex = index;
      _counter = 0;
      _savePreferences();
    });
  }

  void _showCustomDhikrDialog() {
    int customCount = _presetDhikr[_presetDhikr.length - 1]['count'];
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Set Custom Count'),
          content: TextField(
            keyboardType: TextInputType.number,
            onChanged: (value) {
              customCount = int.tryParse(value) ?? 1000;
            },
            decoration: InputDecoration(labelText: 'Count (1-99999)'),
          ),
          actions: <Widget>[
            TextButton(
              child: Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text('Set'),
              onPressed: () {
                setState(() {
                  _presetDhikr[_presetDhikr.length - 1]['count'] =
                      customCount.clamp(1, 99999);
                  _selectedDhikrIndex = _presetDhikr.length - 1;
                  _counter = 0;
                  _savePreferences();
                });
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  void _handleMenuItemSelected(int index) {
    zoomDrawerController.close?.call();
    // Handle menu item selection here
    switch (index) {
      case 0: // Home
        break;
      case 1: // Settings
        _toggleTheme();
        break;
      case 2: // About
        _showAboutDialog();
        break;
      case 3: // Logout
        // Handle logout
        break;
    }
  }

  void _showAboutDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('About Tasbih Lite'),
        content: Text(
            'A digital tasbih counter app to help you keep track of your dhikr.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Close'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ZoomDrawer(
      controller: zoomDrawerController,
      menuScreen: MenuScreen(
        onItemSelected: _handleMenuItemSelected,
      ),
      mainScreen: Theme(
        data: _isDarkMode ? ThemeData.dark() : ThemeData.light(),
        child: Scaffold(
          backgroundColor: _isDarkMode ? const Color(0xFF2C3E50) : Colors.white,
          body: SafeArea(
            child: Column(
              children: [
                // App Bar
                Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 16.0, vertical: 8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.menu),
                        onPressed: () => zoomDrawerController.toggle?.call(),
                        color: _isDarkMode ? Colors.white70 : Colors.black54,
                      ),
                      Text(
                        'Tasbih Lite',
                        style: TextStyle(
                          color: _isDarkMode ? Colors.white70 : Colors.black54,
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.grid_view),
                        onPressed: () {},
                        color: _isDarkMode ? Colors.white70 : Colors.black54,
                      ),
                    ],
                  ),
                ),

                // Dhikr Selection
                Container(
                  height: 50,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: _presetDhikr.length,
                    itemBuilder: (context, index) {
                      return Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8.0),
                        child: ChoiceChip(
                          label: Text(_presetDhikr[index]['name']),
                          selected: _selectedDhikrIndex == index,
                          onSelected: (bool selected) {
                            if (selected) {
                              if (index == _presetDhikr.length - 1) {
                                _showCustomDhikrDialog();
                              } else {
                                _selectDhikr(index);
                              }
                            }
                          },
                        ),
                      );
                    },
                  ),
                ),

                // Main Counter Device
                Expanded(
                  child: Container(
                    margin: const EdgeInsets.symmetric(
                        horizontal: 30, vertical: 20),
                    decoration: BoxDecoration(
                      color: _isDarkMode
                          ? const Color(0xFF34495E)
                          : Colors.grey[300],
                      borderRadius: BorderRadius.circular(60),
                    ),
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        // Device Shape Outline
                        Container(
                          margin: const EdgeInsets.all(15),
                          decoration: BoxDecoration(
                            border: Border.all(
                              color:
                                  _isDarkMode ? Colors.white24 : Colors.black12,
                              width: 2,
                            ),
                            borderRadius: BorderRadius.circular(50),
                          ),
                        ),

                        // Counter Elements
                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            // LCD Display
                            Container(
                              margin: const EdgeInsets.symmetric(vertical: 20),
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 30, vertical: 10),
                              decoration: BoxDecoration(
                                color: const Color(0xFFCCE5D0),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Text(
                                _counter.toString(),
                                style: const TextStyle(
                                  fontSize: 48,
                                  color: Color(0xFF2C3E50),
                                  fontFamily: 'Digital',
                                ),
                              ),
                            ),

                            Text(
                              '${_presetDhikr[_selectedDhikrIndex]['count']}',
                              style: TextStyle(
                                color: _isDarkMode
                                    ? Colors.white70
                                    : Colors.black54,
                                fontSize: 18,
                              ),
                            ),

                            const SizedBox(height: 40),

                            // Main Counter Button
                            GestureDetector(
                              onTap: _incrementCounter,
                              child: Container(
                                width: 120,
                                height: 120,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: _isDarkMode
                                      ? const Color(0xFF2C3E50)
                                      : Colors.grey[400],
                                  border: Border.all(
                                    color: _isDarkMode
                                        ? Colors.white24
                                        : Colors.black12,
                                    width: 2,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),

                // Bottom Navigation
                Container(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      IconButton(
                        icon: Icon(
                          _isSoundOn ? Icons.volume_up : Icons.volume_off,
                          color: Colors.yellow,
                        ),
                        onPressed: _toggleSound,
                      ),
                      IconButton(
                        icon: const Icon(Icons.refresh),
                        onPressed: _resetCounter,
                        color: _isDarkMode ? Colors.white70 : Colors.black54,
                      ),
                      IconButton(
                        icon: const Icon(Icons.brightness_6),
                        onPressed: _toggleTheme,
                        color: _isDarkMode ? Colors.white70 : Colors.black54,
                      ),
                      IconButton(
                        icon: Icon(_isLocked ? Icons.lock : Icons.lock_open),
                        onPressed: _toggleLock,
                        color: _isDarkMode ? Colors.white70 : Colors.black54,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      borderRadius: 24.0,
      showShadow: true,
      angle: 0.0,
      menuBackgroundColor: Colors.indigo,
      slideWidth: MediaQuery.of(context).size.width * 0.65,
      openCurve: Curves.fastOutSlowIn,
      closeCurve: Curves.bounceIn,
    );
  }
}
