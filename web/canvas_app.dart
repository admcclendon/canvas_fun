import 'dart:html';
import 'dart:math';
import 'dart:async';
//import 'physics_manager.dart';
//import './utility/complexnumber.dart';
//import './utility/vector.dart';
import './utility/point.dart';
import './utility/matrix.dart';

void main() {
  CanvasElement el = querySelector("#my_canvas");
  
//  PhysicsManager mgr = new PhysicsManager(el);
//  mgr.Begin();
  CanvasManager mgr = new CanvasManager(el);
  mgr.Begin();
}

class KeyboardManager
{
  int keyCode;
  bool Up = false;
  bool Down = false;
  bool Left = false;
  bool Right = false;
  bool Forward = false;
  bool Backward = false;
  
  KeyboardManager()
  {
    window.onKeyDown.listen(this.onKeyDown);
    window.onKeyUp.listen(this.onKeyUp);
  }
  
  void onKeyDown(KeyboardEvent e)
  {
    this.keyCode = e.keyCode;
    if (e.keyCode == 87)
    {
      Up = true;
    }
    else if (e.keyCode == 83)
    {
      Down = true;
    }
    else if (e.keyCode == 65)
    {
      Left = true;
    }
    else if (e.keyCode == 68)
    {
      Right = true;
    }
    else if (e.keyCode == 82)
    {
      Forward = true;
    }
    else if (e.keyCode == 70)
    {
      Backward = true;
    }
  }
  
  void onKeyUp(KeyboardEvent e)
  {
    this.keyCode = 0;
    if (e.keyCode == 87)
    {
      Up = false;
    }
    else if (e.keyCode == 83)
    {
      Down = false;
    }
    else if (e.keyCode == 65)
    {
      Left = false;
    }
    else if (e.keyCode == 68)
    {
      Right = false;
    }
    else if (e.keyCode == 82)
    {
      Forward = false;
    }
    else if (e.keyCode == 70)
    {
      Backward = false;
    }
  }
}

class CanvasManager
{
  CanvasElement el;
  CanvasRenderingContext2D context;
  List<Cube> cubes;
  num last_time;
  KeyboardManager keyMgr;
  Point3D camera = new Point3D(0, 0, 0);
  
  CanvasManager(this.el)
  {
    ResizeCanvas();
    
    window.onResize.listen(WindowResize);
    
    this.context = this.el.getContext("2d");
    this.cubes = new List<Cube>();
    this.keyMgr = new KeyboardManager();
  }
  
  void WindowResize(Event e)
  {
    ResizeCanvas();
  }
  
  void ResizeCanvas()
  {
    this.el.setAttribute("width", window.innerWidth.toString());
    this.el.setAttribute("height", window.innerHeight.toString());
  }
  void Begin()
  {
    scheduleMicrotask(Start);
  }
  
  void Start()
  {
    // Initialize objects in the scene..
    this.cubes.add(new Cube(new Point3D(0, 0, 10)));
    this.cubes.add(new Cube(new Point3D(3, 0, 10)));
    this.cubes.add(new Cube(new Point3D(-3, 0, 10)));
    this.last_time = new DateTime.now().millisecondsSinceEpoch;
    RequestRedraw();
  }
  
  void RequestRedraw()
  {
    window.requestAnimationFrame(Step);
  }
  
  void Step(num _)
  {
    num t = new DateTime.now().millisecondsSinceEpoch;
        
    num dt = (t - last_time)/1000;
    last_time = t;
    
    num ts = t/1000; // convert time to seconds
    this.cubes[0].position.x = 2*cos(2*PI*.2*ts); // .1Hz (t is in ms) (.1 / 1000 = .0001)
    this.cubes[0].position.y = 3*sin(2*PI*.1*ts);
    this.cubes[1].position.y = 2*cos(2*PI*.1*ts);
    this.cubes[1].angles.y = (5*PI/180)*ts % 2*PI;
    this.cubes[0].angles.x = (5*PI/180)*ts % 2*PI;
    this.cubes[2].angles.z = (5*PI/180)*ts % 2*PI;
//    Matrix toScreen = new Matrix.I(4);
//    toScreen[[3, 3]] = 0;
//    toScreen[[3, 2]] = 2.414213;
    if (keyMgr.Up)
    {
      camera = new Point3D.fromMatrix(camera + new Point3D(0, dt, 0));
    }
    if (keyMgr.Down)
    {
      camera = new Point3D.fromMatrix(camera + new Point3D(0, -dt, 0));
    }
    if (keyMgr.Left)
    {
      camera = new Point3D.fromMatrix(camera + new Point3D(-dt, 0, 0));
    }
    if (keyMgr.Right)
    {
      camera = new Point3D.fromMatrix(camera + new Point3D(dt, 0, 0));
    }
    if (keyMgr.Forward)
    {
      camera = new Point3D.fromMatrix(camera + new Point3D(0, 0, dt));
    }
    if (keyMgr.Backward)
    {
      camera = new Point3D.fromMatrix(camera + new Point3D(0, 0, -dt));
    }
    Point3D cameraDir = new Point3D(0, 0, 0);
    Point3D e = new Point3D(0, 0, 2.414213); // this is for a field of view of 45 deg
    this.context..fillStyle = "rgb(255, 255, 255)"
          ..fillRect(0, 0, this.el.width, this.el.height);
    
    this.context.fillStyle = "rgb(0, 0, 255)";
    this.context.strokeStyle = "rgb(0, 0, 0)";
    
    num sx = 1;
    num sy = 1;
    num ratio = this.el.width/this.el.height;
  
    List<Face> facesToDraw = new List<Face>();
    for (int i = 0; i < this.cubes.length; i++)
    {
      this.cubes[i].Transform((Point3D pt) => PerspectiveTransform(new Point3D.fromMatrix(pt - camera), e, ratio));
      for (int j = 0; j < this.cubes[i].faces.length; j++)
      {
        // Make sure the face is looking at the camera
        if (this.cubes[i].faces[j].normal.z < 0)
          continue;
        if (this.cubes[i].faces[j].behind)
          continue;
        facesToDraw.add(this.cubes[i].faces[j]);
        List<Point3D> v = this.cubes[i].faces[j].verts;
        this.context.beginPath();
        this.context.fillStyle = this.cubes[i].faces[j].color;
        for (int k = 0; k < this.cubes[i].faces[j].verts.length + 1; k++)
        {
          Point3D p = v[k % this.cubes[i].faces[j].verts.length];
          
          if (k == 0)
          {
            this.context.moveTo((p.x + sx)*el.width/2, (sy - p.y)*el.height/2);
          }
          else
          {
            this.context.lineTo((p.x + sx)*el.width/2, (sy - p.y)*el.height/2);
          }
        }
        this.context.fill();
        this.context.stroke();
        this.context.closePath();
      }
    }
    this.context.fillStyle = "rgb(255,0,0)";
    this.context.fillText(this.keyMgr.keyCode.toString(), 100, 100);
    window.requestAnimationFrame(Step);
  }
}
Point3D PerspectiveTransform(Point3D pt, Point3D e, num ratio)
{
  return new Point3D(pt.x*e.z/pt.z/ratio, pt.y*e.z/pt.z, pt.z);
}
class Cube
{
  Point3D position;
  Point3D angles;
  num r; // side length
  
  List<Face> faces = new List<Face>(12);
  List<Point3D> verts = new List<Point3D>(8);
  List<Point3D> trans_verts = new List<Point3D>(8);
  
  Cube(this.position)
  {
    this.verts[0] = new Point3D(-1, 1, -1);
    this.verts[1] = new Point3D(1, 1, -1);
    this.verts[2] = new Point3D(1, -1, -1);
    this.verts[3] = new Point3D(-1, -1, -1);
    this.verts[4] = new Point3D(-1, 1, 1);
    this.verts[5] = new Point3D(1, 1, 1);
    this.verts[6] = new Point3D(1, -1, 1);
    this.verts[7] = new Point3D(-1, -1, 1);
    
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
    
    this.angles = new Point3D(0, 0, 0);
  }
  
  Matrix RotationMatrix()
  {
    Matrix Rx = new Matrix(3, 3, (int i, int j) => RotationX(i, j, angles.x));
    Matrix Ry = new Matrix(3, 3, (int i, int j) => RotationY(i, j, angles.y));
    Matrix Rz = new Matrix(3, 3, (int i, int j) => RotationZ(i, j, angles.z));
    return Rx*Ry*Rz;
  }
  
  Point3D ToWorld(Point3D pt)
  {
    return new Point3D.fromMatrix(this.RotationMatrix()*pt + this.position);
  }
  
  List<Face> Transform(Transformation trans)
  {
    List<Face> result = new List<Face>(this.faces.length);
    for (int i = 0; i < this.verts.length; i++)
    {
      this.trans_verts[i].Transform(trans(this.ToWorld(this.verts[i])));
    }
    return this.faces;
  }
}

typedef Point3D Transformation(Point3D pt);

class Face
{
  List<Point3D> verts = new List<Point3D>();
  String color;
  
  Point3D get normal => new Point3D.fromMatrix(verts[2] - verts[0]).Cross(new Point3D.fromMatrix(verts[1] - verts[0]));
  
  bool get behind => !verts.any((Point3D pt) { return !(pt.z < 1); });
  
  Face([this.verts, this.color]);
  
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