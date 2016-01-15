import 'dart:html';
import 'dart:math';
import 'dart:async';
import './utility/point.dart';
import 'objects/cube.dart';
import 'engine/keyboard_manager.dart';
import 'engine/graphics/camera.dart';
import 'engine/graphics/bounding_box.dart';
import 'engine/graphics/ray.dart';
import 'engine/graphics/face.dart';

void main() {
  CanvasElement el = querySelector("#my_canvas");
  
//  PhysicsManager mgr = new PhysicsManager(el);
//  mgr.Begin();
  CanvasManager mgr = new CanvasManager(el);
  mgr.Begin();
}

class CanvasManager
{
  CanvasElement el;
  CanvasRenderingContext2D context;
  List<Cube> cubes;
  num last_time;
  KeyboardManager keyMgr;
  Camera camera = new Camera();
  num sx = 1;
  num sy = 1;
  
  CanvasManager(this.el)
  {
    ResizeCanvas();
    
    window.onResize.listen(WindowResize);
    
    this.el.onClick.listen((e) => el.requestPointerLock());
//    this.el.onMouseMove.listen((MouseEvent e) { this.camera.orientation.x += e.movement.y*0.001; this.camera.orientation.y += e.movement.x*0.001; });
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
    this.cubes.add(new Cube(new Point3D(0.0, -3.0, 15.0), 2.0));
    this.cubes.add(new Cube(new Point3D(3.0, 0.0, 10.0)));
    this.cubes.add(new Cube(new Point3D(-3.0, 0.0, 10.0)));
    this.el.requestPointerLock();
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
//    this.cubes[0].position.x = 2*cos(2*PI*.2*ts);
//    this.cubes[0].position.y = 3*sin(2*PI*.1*ts);
//    this.cubes[0].orientation.x = (5*PI/180)*ts % 2*PI;
    this.cubes[1].position.y = 2*cos(2*PI*.1*ts);
    this.cubes[1].orientation.y = (5*PI/180)*ts % 2*PI;
    this.cubes[2].orientation.z = (5*PI/180)*ts % 2*PI;

    Point3D positionChange = new Point3D();
    if (keyMgr.IsCommandPressed(Commands.MoveUp))
    {
      positionChange = new Point3D.fromMatrix(positionChange + new Point3D(0.0, dt, 0.0));
    }
    if (keyMgr.IsCommandPressed(Commands.MoveDown))
    {
      positionChange = new Point3D.fromMatrix(positionChange + new Point3D(0.0, -dt, 0.0));
    }
    if (keyMgr.IsCommandPressed(Commands.MoveLeft))
    {
      positionChange = new Point3D.fromMatrix(positionChange + new Point3D(-dt, 0.0, 0.0));
    }
    if (keyMgr.IsCommandPressed(Commands.MoveRight))
    {
      positionChange = new Point3D.fromMatrix(positionChange + new Point3D(dt, 0.0, 0.0));
    }
    if (keyMgr.IsCommandPressed(Commands.MoveForward))
    {
      positionChange = new Point3D.fromMatrix(positionChange + new Point3D(0.0, 0.0, dt));
    }
    if (keyMgr.IsCommandPressed(Commands.MoveBackward))
    {
      positionChange = new Point3D.fromMatrix(positionChange + new Point3D(0.0, 0.0, -dt));
    }
    this.camera.position = new Point3D.fromMatrix(positionChange + this.camera.position);

    if (keyMgr.IsCommandPressed(Commands.YawUp))
    {
      this.camera.orientation.y += dt;
    }
    if (keyMgr.IsCommandPressed(Commands.YawDown))
    {
      this.camera.orientation.y -= dt;
    }
    if (keyMgr.IsCommandPressed(Commands.PitchUp))
    {
      this.camera.orientation.x += dt;
    }
    if (keyMgr.IsCommandPressed(Commands.PitchDown))
    {
      this.camera.orientation.x -= dt;
    }
    if (keyMgr.IsCommandPressed(Commands.RollUp))
    {
      this.camera.orientation.z += dt;
    }
    if (keyMgr.IsCommandPressed(Commands.RollDown))
    {
      this.camera.orientation.z -= dt;
    }
    
    this.context..fillStyle = "rgb(255, 255, 255)"
          ..fillRect(0, 0, this.el.width, this.el.height);
    
    num ratio = this.el.width/this.el.height;
  
    for (int i = 0; i < this.cubes.length; i++)
    {
      this.cubes[i].Transform((Point3D pt) => camera.Transform(pt, ratio));
    }
    for (int i = 0; i < this.cubes.length; i++)
    {
      /*
       * Draw the bounding box of each cube. This is for debugging purposes only.
       * 
       * TODO: remove the section of code.
       */
      DrawBoundingBox(this.cubes[i].bounds);
      
      for (int j = 0; j < this.cubes[i].faces.length; j++)
      {
        DrawFace(this.cubes[i].faces[j]);
      }
    }
    
    /*
     * Draw a cursor.
     */
    this.context.beginPath();
    this.context.strokeStyle = "rgb(0, 0, 0)";
    this.context.arc(el.width/2, el.height/2, 15, 0, 2*PI);
    this.context.stroke();
    this.context.closePath();
    
    this.context.fillStyle = "rgb(0,0,0)";
    this.context.fillText("Orientation - X: " + this.camera.orientation.x.toString() + ", Y: " + this.camera.orientation.y.toString(), 100, 100);
    this.context.fillText("Position - X: " + this.camera.position.x.toString() + ", Y: " + this.camera.position.y.toString() + ", Z: " + this.camera.position.z.toString(), 100, 120);
    this.context.fillText("Keycode: " + this.keyMgr.keyCode.toString(), 100, 140);
    
    for (int i = 0; i < this.cubes[0].trans_verts.length; i++)
    {
      Point3D point = this.cubes[0].trans_verts[i];
      this.context.fillText("Cube[0][" + i.toString() + "] - X: " + point.x.toString() + ", Y: " + point.y.toString() + ", Z: " + point.z.toString(), 100, 160 + i*20);
    }
    for (int i = 0; i < this.cubes[0].faces.length; i++)
    {
      Face face = this.cubes[0].faces[i];
      this.context.fillText("Cube[0].Face[" + i.toString() + "] Behind: " + face.behind.toString() + ", Outside: " + face.outside.toString() + ", Normal Z: " + face.normal.z.toString(), 100, 320 + i*20);
    }
    
    window.requestAnimationFrame(Step);
  }
  
  void MoveCursor(Point3D pt)
  {
    this.context.moveTo((pt.x + sx)*el.width/2, (sy - pt.y)*el.height/2);
  }
  
  void DrawLine(Point3D pt)
  {
    this.context.lineTo((pt.x + sx)*el.width/2, (sy - pt.y)*el.height/2);
  }
  
  void DrawCube(Cube cube)
  {
    for (int j = 0; j < cube.faces.length; j++)
    {
      DrawFace(cube.faces[j]);
    }
  }
  
  void DrawFace(Face face)
  {
    // Don't draw if it is behind the camera or outside the viewing area
     if (face.outside || face.behind)
       return;
     // Make sure the face is looking at the camera
     if (face.normal.z < 0)
       return;
     
     this.context.beginPath();
     this.context.fillStyle = face.color;
     this.context.strokeStyle = face.color;
     List<Ray> r = face.rays;
     
     MoveCursor(r[0].points[0]);
     for (int k = 0; k < r.length; k++)
     {
       DrawLine(r[k].points[1]);
     }
     this.context.fill();
     this.context.stroke();
     this.context.closePath();
  }
  
  void DrawBoundingBox(BoundingBox box)
  {
    this.context.beginPath();
    this.context.strokeStyle = "rgb(0, 0, 0)";

    MoveCursor(box.min);
    DrawLine(new Point3D(box.min.x, box.max.y));
    DrawLine(new Point3D(box.max.x, box.max.y));
    DrawLine(new Point3D(box.max.x, box.min.y));
    DrawLine(new Point3D(box.min.x, box.min.y));
    this.context.stroke();
    this.context.closePath();
  }
}