import '../utility/vector.dart';

abstract class PhysicsObject 
{
  Vector pos, vel, accel;
  
  PhysicsObject(this.pos, this.vel, this.accel);
  
  void Draw();
  void Collision();
}