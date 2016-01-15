import '../../utility/point.dart';
import 'face.dart';

class Ray
{
  List<Point3D> points = new List<Point3D>(2);
  
  Ray(List<Point3D> pts)
  {
    if (pts.length != 2)
    {
      throw new Exception('A ray cannot have more or less than 2 points.');
    }
    
    /*
     * TODO: make iterable
     */
    points[0] = pts[0];
    points[1] = pts[1];
  }
  
  bool Intersect(Face face)
  {
    Point3D r = new Point3D.fromMatrix(points[1] - points[0]);
    Point3D n = face.normal;
    
    num NdotR = n.Dot(r);
    if (NdotR == 0)
    {
      // Parallel to the plane.
      return false;
    }
    
    num r1 = n.Dot(new Point3D.fromMatrix(face.verts[0] - points[0]))/NdotR;
    if (r1 >= 0 && r1 <= 1)
    {
      return true;
    }
    return false;
  }
}