import 'dart:async';

import 'package:flame/flame.dart';
import 'package:flame/components.dart';
import 'package:flame/game.dart';
import 'package:mindwave_mobile2_example/screens/Games/level.dart';

class Meditationgame extends FlameGame {
  late final CameraComponent cam;
  @override
  final world = Level();
  FutureOr<void> onLoad() {
    cam = CameraComponent.withFixedResolution(
        world: world, width:640, height: 360);
    cam.viewfinder.anchor = Anchor.topLeft;
    addAll([cam, world]);
    return super.onLoad();
  }
}
