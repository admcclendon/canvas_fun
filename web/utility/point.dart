library utility.point;

import "./matrix.dart";

class Point2D extends Matrix
{
  double get x => this[[0, 0]];
  double get y => this[[1, 0]];
  void set x(double value) { this[[0,0]] = value; }
  void set y(double value) { this[[1,0]] = value; }
  
  Point2D([double x = 0.0, double y = 0.0]) : super(2, 1)
  {
    this[[0, 0]] = x;
    this[[1, 0]] = y;
  }
}

class Point3D extends Matrix
{
  double get x => this[[0, 0]];
  double get y => this[[1, 0]];
  double get z => this[[2, 0]];
  void set x(double value) { this[[0,0]] = value; }
  void set y(double value) { this[[1,0]] = value; }
  void set z(double value) { this[[2,0]] = value; } 
  
  Point3D([double x = 0.0, double y = 0.0, double z = 0.0]) : super(3, 1)
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
  
  double Dot(Point3D pt)
  {
    double result = 0.0;
    for (int i = 0; i < 3; i++)
    {
      result += this[[i, 0]] * pt[[i, 0]];
    }
    return result;
  }
  
  ///
  /// v1 = (x1, y1, z1)
  /// v2 = (x2, y2, z2)
  /// 
  /// v1 x v2 = | i  j  k  |
  ///           | x1 y1 z1 |
  ///           | x2 y2 z2 |
  /// 
  /// v1 x v2 = (y1*z2 - y2*z1) i - (x1*z2 - x2*z1) j + (x1*y2 - x2*y1) k
  Point3D Cross(Point3D pt)
  {
    return new Point3D(this.y*pt.z - this.z*pt.y, this.z*pt.x - this.x*pt.z, this.x*pt.y - this.y*pt.x);
  }
}

Matrix RotationMatrix(Point3D angles)
{
  Matrix Rx = new Matrix(3, 3, (int i, int j) => RotationX(i, j, angles.x));
  Matrix Ry = new Matrix(3, 3, (int i, int j) => RotationY(i, j, angles.y));
  Matrix Rz = new Matrix(3, 3, (int i, int j) => RotationZ(i, j, angles.z));
  return Rx*Ry*Rz;
}