library utility.vector;

import 'dart:math';

class Vector
{
  num x, y;
  
  Vector(this.x, this.y);
  
  operator +(Vector v) { return new Vector(this.x + v.x, this.y + v.y); }
  operator -(Vector v) { return new Vector(this.x - v.x, this.y - v.y); }
  operator *(num a) { return new Vector(this.x * a, this.y * a); }
  
  num Mag()
  {
    return sqrt(x*x + y*y); // sqrt(x^2 + y^2)
  }
  
  num Dot(Vector v)
  {
    return x * v.x + y * v.y;
  }
}