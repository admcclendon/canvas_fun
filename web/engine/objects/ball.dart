import 'dart:html';
import 'dart:math';

import '../utility/vector.dart';

typedef Vector CoordTransform(Vector p);

class Ball
{
  num radius, mass;
  Vector pos, vel;
  
  num get left => pos.x - radius;
      set left(num v) => pos.x = v + radius;
  num get right => pos.x + radius;
      set right(num v) => pos.x = v - radius; 
  num get top => pos.y + radius;
      set top(num v) => pos.y = v - radius;
  num get bottom => pos.y - radius;
      set bottom(num v) => pos.y = v + radius;
  
  Ball(this.radius, this.pos, this.vel)
  {
    mass = this.radius * this.radius;
  }
  
  void Move(num t, [Vector dv])
  {
    if (dv != null)
      this.vel = this.vel + dv;
    this.pos = this.pos + this.vel * t;
  }
  
  void Draw(CanvasRenderingContext2D context, [CoordTransform t])
  {
    Vector p = this.pos;
    if (t != null)
    {
      p = t(p);
    }
    context..fillStyle = "rgba(255, 0, 0, 0.8)"
        ..beginPath()
        ..arc(p.x, p.y, radius, 0, 2*PI)
        ..fill()
        ..closePath();
  }
  
  bool CollisionDetect(Ball b)
  {
    return (b.pos - pos).Mag() <= b.radius + radius;
  }
  
  void Collide(Ball b)
  {
    Vector dv1 = this.vel - b.vel;
    Vector dv2 = b.vel - this.vel;
    Vector dx1 = this.pos - b.pos;
    Vector dx2 = b.pos - this.pos;
    
    this.vel = this.vel - dx1 * ((2*b.mass)/(this.mass + b.mass))*((dv1.Dot(dx1))/(dx1.Mag() * dx1.Mag()));
    b.vel = b.vel - dx2 * ((2*this.mass)/(this.mass + b.mass))*((dv2.Dot(dx2))/(dx2.Mag() * dx2.Mag()));
  }
}