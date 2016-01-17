library objects.cube;

import '../utility/point.dart';
import 'object.dart';
import '../engine/graphics/face.dart';

class Cube extends Object3D
{
  double r; // side length
  
  Cube(Point3D position, [this.r = 1.0]) : super(8, 12, position)
  {
    this.verts[0] = new Point3D(-r, r, -r);
    this.verts[1] = new Point3D(r, r, -r);
    this.verts[2] = new Point3D(r, -r, -r);
    this.verts[3] = new Point3D(-r, -r, -r);
    this.verts[4] = new Point3D(-r, r, r);
    this.verts[5] = new Point3D(r, r, r);
    this.verts[6] = new Point3D(r, -r, r);
    this.verts[7] = new Point3D(-r, -r, r);
    
    // Copy each of the verts to a transformable vertex list.
    for (int i = 0; i < this.verts.length; i++)
    {
      this.trans_verts[i] = new Point3D.fromPoint(this.verts[i]);
    }
    
    // Use the transformable verts for the face definition so it is drawn correctly on the screen
    this.faces[0] = new Face([this.trans_verts[0], this.trans_verts[1], this.trans_verts[2]], "rgb(255, 0, 0)");
    this.faces[1] = new Face([this.trans_verts[0], this.trans_verts[2], this.trans_verts[3]], "rgb(255, 0, 0)");
    this.faces[2] = new Face([this.trans_verts[1], this.trans_verts[5], this.trans_verts[6]], "rgb(255, 255, 0)");
    this.faces[3] = new Face([this.trans_verts[1], this.trans_verts[6], this.trans_verts[2]], "rgb(255, 255, 0)");
    this.faces[4] = new Face([this.trans_verts[0], this.trans_verts[4], this.trans_verts[1]], "rgb(255, 0, 255)");
    this.faces[5] = new Face([this.trans_verts[1], this.trans_verts[4], this.trans_verts[5]], "rgb(255, 0, 255)");
    this.faces[6] = new Face([this.trans_verts[5], this.trans_verts[7], this.trans_verts[6]], "rgb(0, 255, 255)");
    this.faces[7] = new Face([this.trans_verts[5], this.trans_verts[4], this.trans_verts[7]], "rgb(0, 255, 255)");
    this.faces[8] = new Face([this.trans_verts[4], this.trans_verts[3], this.trans_verts[7]], "rgb(0, 255, 0)");
    this.faces[9] = new Face([this.trans_verts[4], this.trans_verts[0], this.trans_verts[3]], "rgb(0, 255, 0)");
    this.faces[10] = new Face([this.trans_verts[3], this.trans_verts[6], this.trans_verts[7]], "rgb(0, 0, 255)");
    this.faces[11] = new Face([this.trans_verts[3], this.trans_verts[2], this.trans_verts[6]], "rgb(0, 0, 255)");
  }
}