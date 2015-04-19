import 'dart:html';
import 'dart:math';
import 'physics_manager.dart';
import './utility/complexnumber.dart';

void main() {
  CanvasElement el = querySelector("#my_canvas");
  
  PhysicsManager mgr = new PhysicsManager(el);
  mgr.Begin();
  
  Complex r = new Complex.e(PI/2);
}

