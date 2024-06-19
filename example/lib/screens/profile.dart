import 'package:flutter/material.dart';
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
    double screenHeight = MediaQuery.of(context).size.height * 0.53;

    return Scaffold(
      appBar: AppBar(
        title: Text('Profile'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(10, 25, 10, 0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                decoration: BoxDecoration(
                  color: Colors.white, // Background color
                  borderRadius: BorderRadius.circular(30), // Rounded corners
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
                                builder: (context) => const CalendarScreen()),
                          );
                        },
                      ),
                    ),
                  ],
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
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => SessionScreen()));
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
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) => MyApp1n()));
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
