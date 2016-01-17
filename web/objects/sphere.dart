library objects.sphere;

import "object.dart";
import "../utility/point.dart";
import "../engine/graphics/face.dart";
import "dart:math";

class Sphere extends Object3D
{
  num radius;
  
  /*
   * The equation of a sphere is the follow:
   * 
   * x = r * cos(theta) * sin(phi);
   * y = r * sin(theta) * sin(phi);
   * z = r * cos(phi);
   * 
   * where theta : (0, 2 * PI), phi : (0, PI)
   * 
   * This constructor uses the total number of steps of theta and phi to
   * discretize the verticies. 
   */
  Sphere(this.radius, int thetaSteps, int phiSteps, Point3D position) : super((phiSteps - 2)*thetaSteps + 2, 2*thetaSteps*(phiSteps - 2), position)
  {
    /*
     * Create all of the verticies for the sphere.
     */
    for (int i = 0; i < phiSteps; i++)
    {
      for (int j = 0; j < thetaSteps; j++)
      {
        num phi = PI * i / (phiSteps - 1);
        num theta = 2 * PI * j / thetaSteps;
        if (i == 0 || i == phiSteps - 1)
        {
          this.verts[(i == 0) ? 0 : (phiSteps - 2)*thetaSteps + 1] = new Point3D(0.0, 0.0, radius*cos(phi));
        }
        else
        {
          this.verts[(i - 1)*thetaSteps + j + 1] = new Point3D(radius*cos(theta)*sin(phi), radius*sin(theta)*sin(phi), radius*cos(phi));
        }
      }
    }
    
    /*
     * Create the transformable verticies.
     */
    for (int i = 0; i < this.verts.length; i++)
    {
      this.trans_verts[i] = new Point3D.fromPoint(this.verts[i]);
    }
    
    /*
     * Create the face definitions.
     */
    for (int i = 0; i < phiSteps - 1; i++)
    {
      for (int j = 0; j < thetaSteps; j++)
      {
        if (i == 0)
        {
          this.faces[j] = new Face([this.trans_verts[0], this.trans_verts[j+1], this.trans_verts[((j+1)%thetaSteps)+1]], "rgb(0, 0, 255)");
        }
        else if (i == phiSteps - 2)
        {
          this.faces[(2*i - 1)*thetaSteps + j]      = new Face([this.trans_verts[(i-1)*thetaSteps+j+1], this.trans_verts[(phiSteps - 2)*thetaSteps + 1], this.trans_verts[(i-1)*thetaSteps+1+(j+1)%thetaSteps]], "rgb(0, 0, 255)");
        }
        else
        {
          this.faces[(2*i - 1)*thetaSteps + j*2]      = new Face([this.trans_verts[(i-1)*thetaSteps+j+1], this.trans_verts[i*thetaSteps+j+1], this.trans_verts[(i-1)*thetaSteps+1+(j+1)%thetaSteps]], "rgb(0, 0, 255)");
          this.faces[(2*i - 1)*thetaSteps + j*2 + 1]  = new Face([this.trans_verts[(i-1)*thetaSteps+1+(j+1)%thetaSteps], this.trans_verts[i*thetaSteps+j+1], this.trans_verts[i*thetaSteps+1+(j+1)%thetaSteps]], "rgb(0, 0, 255");
        }
      }
    }
  }
}