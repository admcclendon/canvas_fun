import "dart:html";

class Figure
{
  CanvasElement el;
  CanvasRenderingContext2D context;
  
  num margin;
  
  Figure(this.el)
  {
    this.context = this.el.getContext("2d");
    this.margin = 20;
  }
  
  num get Width => this.el.width;
  num get Height => this.el.height;
  
  void ClearFigure()
  {
    this.context..fillStyle = "rgb(255,255,255)"
        ..fillRect(0, 0, Width, Height);
  }
  
  void DrawGrid()
  {
    // Draw the outline
    this.context..fillStyle = "rbg(0, 0, 0)"
        ..beginPath()
        ..moveTo(margin, margin)
        ..lineTo(Width-margin, margin)
        ..lineTo(Width-margin, Height-margin)
        ..lineTo(margin, Height-margin)
        ..lineTo(margin, margin)
        ..stroke()
        ..closePath();
  }
  
  void Draw()
  {
    ClearFigure();
    DrawGrid();
  }
}