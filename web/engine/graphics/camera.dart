library engine.graphics.camera;

import '../utility/matrix.dart';
import '../utility/point.dart';

class Camera
{
  Point3D position;
  Point3D orientation;
  
  Point3D e = new Point3D(0.0, 0.0, 2.414213); // this is for a field of view of 45 deg
  
  Camera([this.position, this.orientation])
  {
    this.position = new Point3D();
    this.orientation = new Point3D();
  }
  
  void Look(double thetaX, double thetaY)
  {
    Point3D change = new Point3D(thetaX, thetaY, 0.0);
    
    Matrix Rz = new Matrix.RotateZ(orientation.z);
    this.orientation += change*Rz;
  }
  
  Matrix RotationMatrix()
  {
    Matrix Rx = new Matrix.RotateX(orientation.x);
    Matrix Ry = new Matrix.RotateY(orientation.y);
    Matrix Rz = new Matrix.RotateZ(orientation.z);
    return Ry*Rx*Rz;
  }
  
  Matrix WorldToCamera()
  {
    Matrix Rx = new Matrix.RotateX(-orientation.x);
    Matrix Ry = new Matrix.RotateY(-orientation.y);
    Matrix Rz = new Matrix.RotateZ(-orientation.z);
    return Rz*Rx*Ry;
  }
  
  Point3D Transform(Point3D pt, num ratio)
  {
    Point3D relativeCamera = (pt - this.position)*this.WorldToCamera();
    return new Point3D(relativeCamera.x*this.e.z/relativeCamera.z/ratio, relativeCamera.y*this.e.z/relativeCamera.z, relativeCamera.z);
  }
}