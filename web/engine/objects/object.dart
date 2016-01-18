library objects.object;

import '../utility/vector.dart';
import '../utility/point.dart';
import '../utility/matrix.dart';
import '../graphics/face.dart';
import '../graphics/bounding_box.dart';

abstract class PhysicsObject 
{
  Vector pos, vel, accel;
  
  PhysicsObject(this.pos, this.vel, this.accel);
  
  void Draw();
  void Collision();
}

abstract class Object3D
{
  Point3D position;
  Point3D orientation;
  
  List<Face> faces;
  List<Point3D> verts;
  List<Point3D> trans_verts;
  
  BoundingBox get bounds
  {
    return new BoundingBox.fromListOfVerts(this.trans_verts);
  }
  
  Object3D([int numOfVerts = 3, int numOfFaces = 1, Point3D position = null, Point3D orientation = null])
  {
    if (position == null)
    {
      this.position = new Point3D();
    }
    else
    {
      this.position = position;
    }
    
    if (orientation == null)
    {
      this.orientation = new Point3D();
    }
    else
    {
      this.orientation = orientation;
    }
    
    this.faces = new List<Face>(numOfFaces);
    this.verts = new List<Point3D>(numOfVerts);
    this.trans_verts = new List<Point3D>(numOfVerts);
    for (int i = 0; i < numOfVerts; i++)
    {
      this.verts[i] = new Point3D();
      this.trans_verts[i] = new Point3D();
    }
  }
  
  Matrix RotationMatrix()
  {
    Matrix Rx = new Matrix.RotateX(this.orientation.x);
    Matrix Ry = new Matrix.RotateY(this.orientation.y);
    Matrix Rz = new Matrix.RotateZ(this.orientation.z);
    return Ry*Rx*Rz;
  }
  
  Point3D ToWorld(Point3D pt)
  {
    return pt * this.RotationMatrix() + this.position;
  }
  
  List<Face> Transform(Transformation trans)
  {
    for (int i = 0; i < this.verts.length; i++)
    {
      this.trans_verts[i].Transform(trans(this.ToWorld(this.verts[i])));
    }
    return this.faces;
  }
}