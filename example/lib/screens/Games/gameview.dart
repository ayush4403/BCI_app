import 'package:flame/flame.dart';
import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'package:mindwave_mobile2_example/screens/Games/meditationgame.dart';

void main(){

  runApp(const GameView());
}
class GameView extends StatefulWidget {
  const GameView({super.key});

  @override
  State<GameView> createState() => _GameViewState();
}

class _GameViewState extends State<GameView> {
  
  Meditationgame game= Meditationgame();
  void initState(){
    super.initState();
  Flame.device.setLandscape();
      Flame.device.fullScreen();
    
  }
  void dispose(){
    Flame.device.setPortrait();
    super.dispose();

  }
  @override
  Widget build(BuildContext context) {
    return GameWidget(game: game);
  }
}
