import 'package:flutter/material.dart';
import 'package:mindwave_mobile2_example/screens/Games/BallGame.dart';


class GameList extends StatefulWidget {
  const GameList({super.key});

  @override
  State<GameList> createState() => _GameListState();
}

class _GameListState extends State<GameList> {
  Widget cardview() {
  return Card(
    color: Colors.blue,
    elevation: 8,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(30),
    ),
    child: Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Image.asset(
                'assets/mindwave.jpg',
                height: 100,
                width: 100,
                fit: BoxFit.contain,
              ),
            
           const SizedBox(width: 16),
            const Expanded(
              child: Text(
                "MindBall",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            ElevatedButton(onPressed:()=>{
              Navigator.push(context, MaterialPageRoute(builder: (context)=>GameScreen()))
            } , child: const Text('Play'))
          ],
        ),
        const SizedBox(height: 16),
        const Text(
          "Game Description",
          style: TextStyle(
            fontSize: 16,
          ),
        ),
      ],
    ),
  );
}
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar:AppBar(
          title: const Text("Games"),
      ),
      body: Padding(
      padding: const EdgeInsets.all(12.0),
      child: ListView(
        //gridDelegate:const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2),
        children: [
          cardview(),
          cardview()
        ],
      ),
    ),
    );
  }
}