import 'package:flutter/material.dart';
import 'package:mindwave_mobile2_example/screens/calender.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: const Text('Profile', style: TextStyle(color: Colors.white)),
        iconTheme: const IconThemeData(
            color: Colors.white), // Set the back icon color to white
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Profile Picture, Name, and Calendar Icon in a Row
              Row(
                children: [
                  const SizedBox(width: 10),
                  // Profile Picture
                  const CircleAvatar(
                    radius: 35,
                    backgroundImage: AssetImage(
                        'assets/device.jpg'), // Replace with your image asset
                  ),
                  // Name
                  const SizedBox(width: 20),
                  const Text(
                    'Cerbotech',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(width: 80),
                  // Calendar Icon with Circular Background
                  Container(
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      color:
                          Colors.white, // Background color for the circle
                    ),
                    padding:
                        const EdgeInsets.all(3.0), // Padding inside the circle
                    child: IconButton(
                      icon: Icon(Icons.calendar_today,
                          color: Colors.grey[800], size: 30),
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const CalendarScreen()),
                        );
                      },
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 32),
              // Sessions Tile
              Card(
                color: Colors.black,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
                elevation: 0,
                child: ListTile(
                  leading: const Icon(Icons.access_time, color: Colors.white),
                  title: const Text('Your Sessions',
                      style: TextStyle(color: Colors.white)),
                  subtitle: const Text('Details about your sessions',
                      style: TextStyle(color: Colors.white70)),
                  trailing: const Icon(
                    Icons.arrow_forward_ios,
                    color: Colors.white,
                    size: 20,
                  ),
                  onTap: () {
                    // Handle tile tap
                  },
                ),
              ),
              const SizedBox(height: 16),
              // Graph Tile
              Card(
                color: Colors.black,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
                elevation: 0,
                child: ListTile(
                  leading: const Icon(Icons.show_chart, color: Colors.white),
                  title: const Text('Progress Graph',
                      style: TextStyle(color: Colors.white)),
                  subtitle: const Text('Your meditation progress',
                      style: TextStyle(color: Colors.white70)),
                  trailing: const Icon(
                    Icons.arrow_forward_ios,
                    color: Colors.white,
                    size: 20,
                  ),
                  onTap: () {
                    // Handle tile tap
                  },
                ),
              ),
              const SizedBox(height: 16),
              // Level of Meditation Tile
              Card(
                color: Colors.black,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
                elevation: 0,
                child: ListTile(
                  leading: const Icon(Icons.star, color: Colors.white),
                  title: const Text('Level of Meditation',
                      style: TextStyle(color: Colors.white)),
                  subtitle: const Text('Your current meditation level',
                      style: TextStyle(color: Colors.white70)),
                  trailing: const Icon(
                    Icons.arrow_forward_ios,
                    color: Colors.white,
                    size: 20,
                  ),
                  onTap: () {
                    // Handle tile tap
                  },
                ),
              ),
              const SizedBox(height: 16),
              // Additional Tile
              Card(
                color: Colors.black,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
                elevation: 0,
                child: ListTile(
                  leading: const Icon(Icons.more_horiz, color: Colors.white),
                  title: const Text(
                    'More Info',
                    style: TextStyle(color: Colors.white),
                  ),
                  subtitle: const Text(
                    'Additional information',
                    style: TextStyle(color: Colors.white70),
                  ),
                  trailing: const Icon(
                    Icons.arrow_forward_ios,
                    color: Colors.white,
                    size: 20,
                  ),
                  onTap: () {
                    // Handle tile tap
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

void main() {
  runApp(const MaterialApp(
    home: ProfileScreen(),
  ));
}
