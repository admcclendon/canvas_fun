import 'dart:html';
import 'dart:async';
import 'physics_manager.dart';

void main() {
  CanvasElement el = querySelector("#my_canvas");
  
  PhysicsManager mgr = new PhysicsManager(el);
  scheduleMicrotask(mgr.Start);
}

