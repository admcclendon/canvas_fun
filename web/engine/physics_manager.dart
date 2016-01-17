import 'dart:html';
import 'dart:math';
import 'dart:async';

import 'objects/ball.dart';
import 'utility/vector.dart';

final num NumberOfBalls = 0;
final num WallFactor = 0.8; // KE = 0.5 * m * v^2; v = sqrt(2*KE/m)

class PhysicsManager
{
  CanvasElement el;
  CanvasRenderingContext2D context;
  List<Ball> balls;
  num last_time;
  Random rand;
  
  String label = "TEST";
  
  CoordTransform worldToCanvas;
  CoordTransform canvasToWorld;
  
  PhysicsManager(this.el)
  {
    ResizeCanvas();
    
    this.el.onClick.listen(ClickEvent);
    this.el.onMouseDown.listen(MouseDown);
    this.el.onMouseUp.listen(MouseUp);
    window.onResize.listen(WindowResize);
    
    this.context = this.el.getContext("2d");
    this.balls = new List<Ball>();
    
    this.rand = new Random();
    
    worldToCanvas = (Vector v) => new Vector(v.x, el.height - v.y);
    canvasToWorld = (Vector v) => new Vector(v.x, el.height - v.y);
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
  
  void ClickEvent(MouseEvent e)
  {
    
//    label = "Client - X: " + e.client.x.toString() + ", Y: " + e.client.y.toString()
//        + "Offset - X: " + e.offset.x.toString() + ", Y: " + e.offset.y.toString();
    label = "Number of Balls: " + this.balls.length.toString();
  }
  
  Vector startPos = null;
  void MouseDown(MouseEvent e)
  {
    startPos = new Vector(e.offset.x, e.offset.y);
  }
  
  void MouseUp(MouseEvent e)
  {
    if (startPos != null)
    {
      Vector v = new Vector(e.offset.x, e.offset.y);
      
      Ball b = new Ball(15, canvasToWorld(v), canvasToWorld(v) - canvasToWorld(startPos));
      this.balls.add(b);
    }
  }
  
  void Begin()
  {
    scheduleMicrotask(Start);
  }
  
  void Start()
  {
    for (num i = 0; i < NumberOfBalls; i++)
    {
      num j = 0;
      while (j < 100) // only try 100 times to find one that fits
      {
        num radius = rand.nextInt(20) + 5;
        Ball b = new Ball(radius, 
            new Vector(rand.nextInt(el.width - 2*radius) + radius, rand.nextInt(el.height - 2*radius) + radius), 
            new Vector(rand.nextDouble()*100, rand.nextDouble()*100));
        bool result = true;
        for (num k = 0; k < this.balls.length; k++)
        {
          result = result && !b.CollisionDetect(this.balls[k]);
        }
        if (result)
        {
          this.balls.add(b);
          break;
        }
        j++;
      }
    }
    RequestRedraw();
  }
  
  void RequestRedraw()
  {
    window.requestAnimationFrame(Step);
  }
  
  void Step(num _)
  {
    num t = new DateTime.now().millisecondsSinceEpoch;
    
    num dt;
    if (last_time != null)
    {
      dt = t - last_time;
    }
    else
    {
      dt = 0;
    }
    last_time = t;
    
    Draw(dt/1000);
    
    // Apply collision logic for next step
    for (num i = 0; i < this.balls.length; i++)
    {
      Ball b = this.balls[i];
      
      // Collision logic
      for (num j = i + 1; j < this.balls.length; j++)
      {
        Ball b2 = this.balls[j];
        if (b.CollisionDetect(b2))
        {
          b.Collide(b2);
        }
      }
      
      // Wall logic
      if (b.left < 0 || b.right > this.el.width)
      {
        if (b.left < 0)
        {
          b.left = 0;
        }
        else
        {
          b.right = this.el.width;
        }
        b.vel.x *= -1;
      }
      if (b.bottom < 0 || b.top > this.el.height)
      {
        if (b.bottom < 0)
        {
          b.bottom = 0;
        }
        else
        {
          b.top = this.el.height;
        }
        b.vel.y *= -WallFactor;
      }
    }
    
    window.requestAnimationFrame(Step);
  }
  
  void Draw(num dt)
  {
    context..fillStyle = "rgba(0, 0, 0, 1.0)"
            ..fillRect(0, 0, el.width, el.height);
        
    // Move and draw
    for (num i = 0; i < this.balls.length; i++)
    {
      Ball b = this.balls[i];
      
      b.Move(dt, new Vector(0, -980*dt));
      b.Draw(this.context, (v) => new Vector(v.x, this.el.height - v.y));
    }
    
    context.fillStyle = "rgb(255, 255, 255)";
    context.fillText(label, 0, 600);
  }
}