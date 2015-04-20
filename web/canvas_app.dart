import 'dart:html';
import 'dart:math';
import 'dart:async';
import 'physics_manager.dart';
import './utility/complexnumber.dart';
import './utility/vector.dart';

void main() {
  CanvasElement el = querySelector("#my_canvas");
  
//  PhysicsManager mgr = new PhysicsManager(el);
//  mgr.Begin();
  CanvasManager mgr = new CanvasManager(el);
  mgr.Begin();
  
//  Complex r = new Complex.e(PI/2);
//  Matrix A = new Matrix.I(3);
//  Matrix B = new Matrix(3, 3, (int i, int j) => i*j);
//  
//  Matrix C = A * B;
//  Matrix Rx = new Matrix(4, 4, (int i, int j) => RotationX(i, j, 0));
//  Matrix Ry = new Matrix(4, 4, (int i, int j) => RotationY(i, j, 0));
//  Matrix Rz = new Matrix(4, 4, (int i, int j) => RotationZ(i, j, 0));
//  Matrix R = Rx*Ry*Rz;
}

class CanvasManager
{
  CanvasElement el;
  CanvasRenderingContext2D context;
  List<Cube> cubes;
  num last_time;
  
  CanvasManager(this.el)
  {
    ResizeCanvas();
        
//    this.el.onClick.listen(ClickEvent);
//    this.el.onMouseDown.listen(MouseDown);
//    this.el.onMouseUp.listen(MouseUp);
    window.onResize.listen(WindowResize);
    
    this.context = this.el.getContext("2d");
    this.cubes = new List<Cube>();
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
        
    num dt = t - last_time;
    last_time = t;
    
    this.cubes[0].position = new Point3D(0, 0, 10 + 5*sin(2*PI*.0001*t)); // .1Hz (t is in ms) (.1 / 1000 = .0001)
    this.cubes[0].angles.y = (5*PI/180)*t/1000 % 2*PI;
    this.cubes[0].angles.x = (PI/180)*t/1000 % 2*PI;
    List<Face> toDraw = this.cubes[0].Transform((Point3D pt) => pt);
//    Matrix toScreen = new Matrix.I(4);
//    toScreen[[3, 3]] = 0;
//    toScreen[[3, 2]] = 2.414213;
    Point3D e = new Point3D(0, 0, 2.414213); // this is for a field of view of 45 deg
    this.context..fillStyle = "rgb(255, 255, 255)"
          ..fillRect(0, 0, this.el.width, this.el.height);
    
    this.context.fillStyle = "rgb(0, 0, 255)";
    this.context.strokeStyle = "rgb(0, 0, 0)";
    
    num sx = 1;
    num sy = 1;
    num ratio = this.el.width/this.el.height;
    if (this.el.width > this.el.height)
    {
//      sx += (this.el.width - this.el.height) / (2 * this.el.height);
    }
    for (int i = 0; i < toDraw.length; i++)
    {
      this.context.beginPath();
      for (int j = 0; j < toDraw[i].verts.length; j++)
      {
        Point3D p = toDraw[i].verts[j];
        
        if (j == 0)
        {
          this.context.moveTo((p.x*e.z/p.z/ratio + sx)*el.width/2, (sy - p.y*e.z/p.z)*el.height/2);
        }
        else
        {
          this.context.lineTo((p.x*e.z/p.z/ratio + sx)*el.width/2, (sy - p.y*e.z/p.z)*el.height/2);
        }
      }
//      this.context.fill();
      this.context.stroke();
      this.context.closePath();
    }
    window.requestAnimationFrame(Step);
  }
}

class Cube
{
  Point3D position;
  Point3D angles;
  num r; // side length
  
  List<Face> faces = new List<Face>(6);
  
  Cube(this.position)
  {
    faces[0] = new Face([new Point3D(-1, 1, 1), new Point3D(-1, 1, -1), new Point3D(-1, -1, -1), new Point3D(-1, -1, 1)]); // Left
    faces[1] = new Face([new Point3D(-1, 1, -1), new Point3D(1, 1, -1), new Point3D(1, -1, -1), new Point3D(-1, -1, -1)]); // Front
    faces[2] = new Face([new Point3D(-1, 1, 1), new Point3D(1, 1, 1), new Point3D(1, 1, -1), new Point3D(-1, 1, -1)]); // Top
    faces[3] = new Face([new Point3D(1, 1, -1), new Point3D(1, 1, 1), new Point3D(1, -1, 1), new Point3D(1, -1, -1)]); // Right
    faces[4] = new Face([new Point3D(1, 1, 1), new Point3D(-1, 1, 1), new Point3D(-1, -1, 1), new Point3D(1, -1, 1)]); // Back
    faces[5] = new Face([new Point3D(1, -1, -1), new Point3D(1, -1, 1), new Point3D(-1, -1, 1), new Point3D(-1, -1, -1)]); // Bottom
    
    this.angles = new Point3D(0, 0, 0);
  }
  
  Matrix RotationMatrix()
  {
    Matrix Rx = new Matrix(3, 3, (int i, int j) => RotationX(i, j, angles.x));
    Matrix Ry = new Matrix(3, 3, (int i, int j) => RotationY(i, j, angles.y));
    Matrix Rz = new Matrix(3, 3, (int i, int j) => RotationZ(i, j, angles.z));
    return Rx*Ry*Rz;
  }
  
  List<Face> Transform(Transformation trans)
  {
    List<Face> result = new List<Face>(this.faces.length);
    for (int i = 0; i < this.faces.length; i++)
    {
      result[i] = new Face(this.faces[i].Transform((Point3D pt) => trans(new Point3D.fromMatrix(this.RotationMatrix()*pt + this.position))));
    }
    return result;
  }
}

typedef Point3D Transformation(Point3D pt);

class Face
{
  List<Point3D> verts = new List<Point3D>();
  
  Face([this.verts]);
  
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

class Point3D extends Matrix
{
  num get x => this[[0, 0]];
  num get y => this[[1, 0]];
  num get z => this[[2, 0]];
  void set x(num value) { this[[0,0]] = value; }
  void set y(num value) { this[[1,0]] = value; }
  void set z(num value) { this[[2,0]] = value; } 
  
  Point3D(num x, num y, num z) : super(3, 1)
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
}