import "dart:html";
import "graphs/figure.dart";

void main()
{
  CanvasElement el = querySelector("#my_canvas");
  
  Figure f = new Figure(el);
  f.Draw();
}