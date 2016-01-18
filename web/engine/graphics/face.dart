library engine.graphics.face;

import '../utility/point.dart';
import 'bounding_box.dart';
import 'ray.dart';

typedef Point3D Transformation(Point3D pt);

class Face
{
  List<Point3D> verts = new List<Point3D>();
  String color;
  
  Face([this.verts, this.color = "rgb(255,255,255)"]);
  
  Point3D get normal => (verts[2] - verts[0]).Cross(verts[1] - verts[0]);
    
  bool get behind => !verts.any((Point3D pt) { return !(pt.z < 3); });
  
  bool get outside => !verts.any((Point3D pt) { return pt.x > -1 && pt.x < 1 && pt.y > -1 && pt.y < 1; });
  
  BoundingBox get bounds
  {
    return new BoundingBox.fromListOfVerts(this.verts);
  }
  
  List<Ray> get rays
  {
    List<Ray> faceRays = new List<Ray>();
    for (int i = 0; i < verts.length; i++)
    {
      faceRays.add(new Ray([verts[i], verts[(i+1)%verts.length]]));
    }
    return faceRays;
  }
  
  List<Point3D> Transform(Transformation trans)
  {
    List<Point3D> result = new List<Point3D>(this.verts.length);
    for (int i = 0; i < this.verts.length; i++)
    {
      result[i] = trans(this.verts[i]);
    }
    return result;
  }
}