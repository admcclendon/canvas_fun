library utility.point;

import "./matrix.dart";

class Point2D extends Matrix
{
  num get x => this[[0, 0]];
  num get y => this[[1, 0]];
  void set x(num value) { this[[0,0]] = value; }
  void set y(num value) { this[[1,0]] = value; }
  
  Point2D([num x = 0, num y = 0]) : super(2, 1)
  {
    this[[0, 0]] = x;
    this[[1, 0]] = y;
  }
}

class Point3D extends Matrix
{
  num get x => this[[0, 0]];
  num get y => this[[1, 0]];
  num get z => this[[2, 0]];
  void set x(num value) { this[[0,0]] = value; }
  void set y(num value) { this[[1,0]] = value; }
  void set z(num value) { this[[2,0]] = value; } 
  
  Point3D([num x = 0, num y = 0, num z = 0]) : super(3, 1)
  {
    this[[0, 0]] = x;
    this[[1, 0]] = y;
    this[[2, 0]] = z;
  }
  
  Point3D.fromMatrix(Matrix m) : super(3, 1)
  {
    this[[0,0]] = m[[0,0]];
    this[[1,0]] = m[[1,0]];
    this[[2,0]] = m[[2,0]];
  }
  
  Point3D.fromPoint(Point3D pt) : super(3, 1)
  {
    this.x = pt.x;
    this.y = pt.y;
    this.z = pt.z;
  }
  
  void Transform(Point3D pt)
  {
    this.x = pt.x;
    this.y = pt.y;
    this.z = pt.z;
  }
}