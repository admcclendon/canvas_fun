library engine.graphics.bounding_box;

import '../../utility/point.dart';

class BoundingBox
{
  Point3D min, max;
  
  BoundingBox(this.min, this.max);
  
  BoundingBox.fromListOfVerts(List<Point3D> points)
  {
    Point3D min = new Point3D.fromPoint(points[0]);
    Point3D max = new Point3D.fromPoint(points[0]);
    
    for (int i = 0; i < points.length; i++)
    {
      if (points[i].x < min.x)
      {
        min.x = points[i].x;
      }
      if (points[i].y < min.y)
      {
        min.y = points[i].y;
      }
      if (points[i].z < min.z)
      {
        min.z = points[i].z;
      }
      if (points[i].x > max.x)
      {
        max.x = points[i].x;
      }
      if (points[i].y > max.y)
      {
        max.y = points[i].y;
      }
      if (points[i].z > max.z)
      {
        max.z = points[i].z;
      }
    }
    
    this.min = min;
    this.max = max;
  }
  
  bool Intersects(BoundingBox b)
  {
    /*
     * TODO: fix this logic for 3 dimensions..
     */
    return this.PointInside(new Point3D(b.min.x, b.min.y)) ||
        this.PointInside(new Point3D(b.min.x, b.max.y)) || 
        this.PointInside(new Point3D(b.max.x, b.max.y)) ||
        this.PointInside(new Point3D(b.max.x, b.min.y)) ||
        b.PointInside(new Point3D(this.min.x, this.min.y)) ||
        b.PointInside(new Point3D(this.min.x, this.max.y)) || 
        b.PointInside(new Point3D(this.max.x, this.max.y)) ||
        b.PointInside(new Point3D(this.max.x, this.min.y));
  }
  
  bool Intersects2D(BoundingBox b)
  {
    return  this.PointInside2D(new Point3D(b.min.x, b.min.y)) ||
            this.PointInside2D(new Point3D(b.min.x, b.max.y)) || 
            this.PointInside2D(new Point3D(b.max.x, b.max.y)) ||
            this.PointInside2D(new Point3D(b.max.x, b.min.y)) ||
            b.PointInside2D(new Point3D(this.min.x, this.min.y)) ||
            b.PointInside2D(new Point3D(this.min.x, this.max.y)) || 
            b.PointInside2D(new Point3D(this.max.x, this.max.y)) ||
            b.PointInside2D(new Point3D(this.max.x, this.min.y));
  }
  
  /*
   * TODO: fix this logic for 3 dimensions..
   */
  bool PointInside(Point3D pt)
  {
    return pt.x > this.min.x && pt.x < this.max.x && pt.y > this.min.y && pt.y < this.max.y;
  }
  
  bool PointInside2D(Point3D pt)
  {
    return pt.x > this.min.x && pt.x < this.max.x && pt.y > this.min.y && pt.y < this.max.y;
  }
}