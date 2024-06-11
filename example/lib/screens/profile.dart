import 'package:flutter/material.dart';
import 'package:mindwave_mobile2_example/screens/calender.dart';
import 'package:mindwave_mobile2_example/screens/graphhome.dart';
import 'package:mindwave_mobile2_example/screens/session.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height * 0.53;

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
                    Navigator.push(context, MaterialPageRoute(builder: (context)=> GraphSelectorScreen()));
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
                      // Handle button tap
                    },
                  ),
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
  runApp(MaterialApp(
    home: ProfileScreen(),
  ));
}
