import 'dart:html';
import 'dart:async';
import 'physics_manager.dart';
import './utility/vector.dart';

void main() {
  CanvasElement el = querySelector("#my_canvas");
  
  PhysicsManager mgr = new PhysicsManager(el);
  mgr.Begin();
  
  Matrix A = new Matrix.I(3);
  Matrix B = new Matrix(3, 3, (int i, int j) => i*j);
  
  Matrix C = A * B;
}

