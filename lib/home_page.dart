import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Data Trip',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _attackResult = -1;
  final int _selectedIndex = 0;
  String _selectedCanId = '';
  String _selectedDLC = '1'; // Default DLC value
  final List<Widget> _pages = [
    const Center(
        child: Text('Test Attack Content', style: TextStyle(fontSize: 24))),
    const Center(child: Text('Attack Content', style: TextStyle(fontSize: 24))),
    const Center(
        child: Text('No Attack Content', style: TextStyle(fontSize: 24))),
  ];

  // Controllers for the text fields
  final List<TextEditingController> _textControllers =
  List.generate(8, (index) => TextEditingController());

  @override
  void dispose() {
    // Clean up the controllers when the widget is disposed
    for (var controller in _textControllers) {
      controller.dispose();
    }
    super.dispose();
  }

  Future<void> fetchAlbum() async {
    try {
      final result = await http.post(
        // Local server
        //Uri.parse('http://10.0.2.2:5000/predict'),
        // online server
        Uri.parse('https://aiproject.studio-dev.online/predict'),
        headers: {
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode({
          "can_id": _selectedCanId,
          "dlc": _selectedDLC,
          "data": [
            _textControllers[0].text,
            _textControllers[1].text,
            _textControllers[2].text,
            _textControllers[3].text,
            _textControllers[4].text,
            _textControllers[5].text,
            _textControllers[6].text,
            _textControllers[7].text,
          ],
        }),
      );

      if (result.statusCode == 200) {
        final String modelOutput = result.body;
        setState(() {
          _attackResult = double.parse((modelOutput)).round();
        });
        // Update UI or display modelOutput as needed
        print('Response from Flask: $modelOutput');
      } else {
        // Handle other status codes here
        print('Error response: ${result.statusCode}');
      }
    } catch (e) {
      print('Error sending request: $e');
      // Handle errors from request
    }
  }

  @override
  Widget build(BuildContext context) {
    print(_attackResult);
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              child: Center(
                child: Image.asset(
                  'assets/image 39.png', // Make sure to add the image in the assets folder
                  width: 500,
                  height: 200, // Adjust the height of the image
                  // Adjust the width of the image
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Increased size of the image

                  const SizedBox(height: 16),
                  const Text(
                    'Data Trip',
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 16),
                  // Text field for CAN ID
                  TextField(
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'CAN ID',
                      hintText: 'Enter CAN ID',
                    ),
                    onChanged: (value) {
                      setState(() {
                        _selectedCanId = value; // Update selected CAN ID
                      });
                    },
                  ),
                  const SizedBox(height: 16),
                  // Text field for DLC
                  TextField(
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'DLC',
                      hintText: 'Enter DLC',
                    ),
                    onChanged: (value) {
                      setState(() {
                        _selectedDLC = value; // Update selected DLC
                      });
                    },
                  ),
                  const SizedBox(height: 16),
                  // Build the TextFields dynamically (for demonstration, adjust as needed)
                  Column(
                    children: [
                      _buildTextField('DATA 0', 'Enter Data 0', 0),
                      const SizedBox(height: 12),
                      _buildTextField('DATA 1', 'Enter Data 1', 1),
                      const SizedBox(height: 12),
                      _buildTextField('DATA 2', 'Enter Data 2', 2),
                      const SizedBox(height: 12),
                      _buildTextField('DATA 3', 'Enter Data 3', 3),
                      const SizedBox(height: 12),
                      _buildTextField('DATA 4', 'Enter Data 4', 4),
                      const SizedBox(height: 12),
                      _buildTextField('DATA 5', 'Enter Data 5', 5),
                      const SizedBox(height: 12),
                      _buildTextField('DATA 6', 'Enter Data 6', 6),
                      const SizedBox(height: 12),
                      _buildTextField('DATA 7', 'Enter Data 7', 7),
                    ],
                  ),
                  const SizedBox(height: 16),
                  // Test Attack button
                  ElevatedButton(
                    onPressed: () {
                      fetchAlbum();
                    },
                    child: const Text('Test Attack'),
                  ),
                  const SizedBox(height: 8),
                  // Attack label with icon
                  if (_attackResult != -1)
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(_attackResult == 1 ? 'Attack' : 'No Attack',
                            style: const TextStyle(
                                fontSize: 18, color: Colors.black)),
                        if (_attackResult == 1)
                          const Icon(Icons.warning,
                              color:
                              Colors.red), // Example icon (can be changed)
                        if (_attackResult == 0)
                          const Icon(Icons.check_circle, color: Colors.green)
                      ],
                    ),
                  const SizedBox(height: 8),

                  const SizedBox(height: 16),
                  Center(
                    child: _pages[_selectedIndex],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField(String labelText, String hintText, int index) {
    return TextField(
      controller: _textControllers[index],
      decoration: InputDecoration(
        border: const OutlineInputBorder(),
        labelText: labelText,
        hintText: hintText,
      ),
      onChanged: (value) {
        setState(() {
          // Handle onChanged as needed
        });
      },
    );
  }
}
