import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:mindwave_mobile2_example/screens/calender.dart';
import 'package:mindwave_mobile2_example/screens/home.dart';
import 'package:mindwave_mobile2_example/screens/logs.dart';
import 'package:mindwave_mobile2_example/screens/session.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Profile'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Profile Picture and Name
              CircleAvatar(
                radius: 50,
                backgroundImage: AssetImage(
                    'assets/profile_picture.png'), // Replace with your image asset
              ),
              SizedBox(height: 16),
              Text(
                'Cerbotech',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 32),
              // PageView taking half of the screen height
              SizedBox(
                height: screenHeight,
                child: ClipRRect(
                  borderRadius: BorderRadius.all(Radius.circular(20)),
                  child: PageView(
                    children: const [
                      // Replace these containers with your desired screens or widgets
                      CalendarScreen(),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 32),
              // Sessions Tile
              Card(
                child: ListTile(
                  leading: Icon(Icons.access_time),
                  title: Text('Your Sessions'),
                  subtitle: Text('Details about your sessions'),
                  trailing: IconButton(
                    icon: Icon(Icons.arrow_forward_ios),
                    onPressed: () {
                     Navigator.push(context, MaterialPageRoute(builder: (context)=> SessionScreen()));
                    },
                  ),
                ),
              ),
              SizedBox(height: 16),
              // Graph Tile
              Card(
                child: ListTile(
                  leading: Icon(Icons.show_chart),
                  title: Text('Progress Graph'),
                  subtitle: Text('Your meditation progress'),
                  trailing: IconButton(
                    icon: Icon(Icons.arrow_forward_ios),
                    onPressed: () {
                    Navigator.push(context, MaterialPageRoute(builder: (context)=> MyApp1n()));
                    },
                  ),
                ),
              ),
              SizedBox(height: 16),
              // Level of Meditation Tile
              Card(
                child: ListTile(
                  leading: Icon(Icons.star),
                  title: Text('Level of Meditation'),
                  subtitle: Text('Your current meditation level'),
                  trailing: IconButton(
                    icon: Icon(Icons.arrow_forward_ios),
                    onPressed: () {
                      // Handle button tap
                    },
                  ),
                ),
              ),
              SizedBox(height: 16),
              // Additional Tile
              Card(
                child: ListTile(
                  leading: Icon(Icons.more_horiz),
                  title: Text('More Info'),
                  subtitle: Text('Additional information'),
                  trailing: IconButton(
                    icon: Icon(Icons.forward),
                    onPressed: () {
                         Navigator.push(context, MaterialPageRoute(builder: (context)=> SessionSelectionPage()));
                    },
                  ),
                ),
              ),
            ],
          ),
        ),
        iconTheme: const IconThemeData(
          color: Colors.black,
        ),
      ),
      body: Stack(
        children: [
          Positioned.fill(
            child: SvgPicture.asset(
              'assets/background.svg',
              fit: BoxFit.cover,
            ),
          ),
          SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(10, 25, 10, 0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white, // Background color
                      borderRadius:
                          BorderRadius.circular(30), // Rounded corners
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.3),
                          spreadRadius: 5,
                          blurRadius: 7,
                          offset: Offset(0, 3), // changes position of shadow
                        ),
                      ],
                    ),
                    padding: const EdgeInsets.all(8.0),
                    margin: const EdgeInsets.only(bottom: 20),
                    child: Row(
                      children: [
                        const SizedBox(width: 10),
                        const CircleAvatar(
                          backgroundColor: Colors.blue,
                          radius: 40,
                          backgroundImage: AssetImage('assets/mindwave.jpg'),
                        ),
                        const SizedBox(width: 20),
                        const Text(
                          'Cerbotech',
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(width: 60),
                        Container(
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.blue[500],
                          ),
                          padding: const EdgeInsets.all(3.0),
                          child: IconButton(
                            icon: const Icon(Icons.calendar_today,
                                color: Colors.white, size: 30),
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        const CalendarScreen()),
                              );
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 50),
                  // Sessions Tile
                  Card(
                    color: Colors.blue[100],
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    elevation: 0,
                    child: ListTile(
                      leading:
                          const Icon(Icons.access_time, color: Colors.black),
                      title: const Text('Your Sessions',
                          style: TextStyle(color: Colors.black)),
                      subtitle: const Text('Details about your sessions',
                          style: TextStyle(color: Colors.black)),
                      trailing: const Icon(
                        Icons.arrow_forward_ios,
                        color: Colors.black,
                        size: 20,
                      ),
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => SessionScreen()));
                      },
                    ),
                  ),
                  const SizedBox(height: 16),
                  // Graph Tile
                  Card(
                    color: Colors.blue[100],
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    elevation: 0,
                    child: ListTile(
                      leading:
                          const Icon(Icons.show_chart, color: Colors.black),
                      title: const Text('Progress Graph',
                          style: TextStyle(color: Colors.black)),
                      subtitle: const Text('Your meditation progress',
                          style: TextStyle(color: Colors.black)),
                      trailing: const Icon(
                        Icons.arrow_forward_ios,
                        color: Colors.black,
                        size: 20,
                      ),
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => GraphSelectorScreen()));
                      },
                    ),
                  ),
                  const SizedBox(height: 16),
                  // Level of Meditation Tile
                  Card(
                    color: Colors.blue[100],
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    elevation: 0,
                    child: ListTile(
                      leading: const Icon(Icons.star, color: Colors.black),
                      title: const Text('Meditation Performance',
                          style: TextStyle(color: Colors.black)),
                      subtitle: const Text('Your current meditation score',
                          style: TextStyle(color: Colors.black)),
                      onTap: () {
                        // Handle tile tap
                      },
                    ),
                  ),
                  const SizedBox(height: 16),
                  // Additional Tile
                  const SizedBox(height: 220),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

void main() {
  runApp(const MaterialApp(
    home: ProfileScreen(),
  ));
}
