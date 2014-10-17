import 'dart:html';
import 'dart:math';
import 'dart:async';

class PhysicsManager
{
  CanvasElement el;
  CanvasRenderingContext2D context;
  List<Ball> balls;
  num last_time;
  Random rand;
  
  PhysicsManager(this.el)
  {
    this.context = this.el.getContext("2d");
    this.balls = new List<Ball>();
    
    this.rand = new Random();
  }
  
  void Begin()
  {
    scheduleMicrotask(Start);
  }
  
  void Start()
  {
    for (num i = 0; i < 15; i++)
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
    
    context..fillStyle = "rgba(0, 0, 0, 1.0)"
        ..fillRect(0, 0, el.width, el.height);
    
    for (num i = 0; i < this.balls.length; i++)
    {
      Ball b = this.balls[i];
      
      b.Move(dt/1000);
      b.Draw(this.context);
      
      // Collision logic
      for (num j = i + 1; j < this.balls.length; j++)
      {
        Ball b2 = this.balls[j];
        if (b.CollisionDetect(b2))
        {
          Vector dv1 = b.vel - b2.vel;
          Vector dv2 = b2.vel - b.vel;
          Vector dx1 = b.pos - b2.pos;
          Vector dx2 = b2.pos - b.pos;
          
          b.vel = b.vel - dx1 * ((2*b2.mass)/(b.mass + b2.mass))*((dv1.Dot(dx1))/(dx1.Mag() * dx1.Mag()));
          b2.vel = b2.vel - dx2 * ((2*b.mass)/(b.mass + b2.mass))*((dv2.Dot(dx2))/(dx2.Mag() * dx2.Mag()));
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
        b.vel.y *= -1;
      }
    }
    window.requestAnimationFrame(Step);
  }
}

class Ball
{
  num radius, mass;
  Vector pos, vel;
  List<Vector> trace_pos;
  
  num get left => pos.x - radius;
      set left(num v) => pos.x = v + radius;
  num get right => pos.x + radius;
      set right(num v) => pos.x = v - radius; 
  num get top => pos.y + radius;
      set top(num v) => pos.y = v - radius;
  num get bottom => pos.y - radius;
      set bottom(num v) => pos.y = v + radius;
  
  Ball(this.radius, this.pos, this.vel)
  {
    mass = this.radius * this.radius;
    trace_pos = new List<Vector>.filled(50, this.pos);
  }
  
  void Move(num t)
  {
    this.pos = this.pos + this.vel * t;
    List<Vector> newList = trace_pos.sublist(1, trace_pos.length);
    newList.add(this.pos);
    trace_pos = newList;
  }
  
  void Draw(CanvasRenderingContext2D context)
  {
    context..fillStyle = "rgba(255, 0, 0, 0.8)"
        ..beginPath()
        ..arc(this.pos.x, this.pos.y, radius, 0, 2*PI)
        ..fill()
        ..closePath();
    for (num i = 0; i < trace_pos.length; i++)
    {
      num opacity = i * (0.8/trace_pos.length);
      context..fillStyle = "rgba(255, 0, 0, " + opacity.toString() + ")"
          ..beginPath()
          ..arc(trace_pos[i].x, trace_pos[i].y, radius/4, 0, 2*PI)
          ..fill()
          ..closePath();
    }
  }
  
  bool CollisionDetect(Ball b)
  {
    return (b.pos - pos).Mag() <= b.radius + radius;
  }
}

class Vector
{
  num x, y;
  
  Vector(this.x, this.y);
  
  operator +(Vector v) { return new Vector(this.x + v.x, this.y + v.y); }
  operator -(Vector v) { return new Vector(this.x - v.x, this.y - v.y); }
  operator *(num a) { return new Vector(this.x * a, this.y * a); }
  
  num Mag()
  {
    return sqrt(x*x + y*y); // sqrt(x^2 + y^2)
  }
  
  num Dot(Vector v)
  {
    return x * v.x + y * v.y;
  }
}