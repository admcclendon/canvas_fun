import "package:test/test.dart";

import "dart:math";
import "../engine/utility/matrix.dart";
import "../engine/utility/point.dart";

void main()
{
  group("Point3D", () {
    test("+ operator", () {
      Point3D x = new Point3D(1.0, 2.0, 3.0);
      Point3D y = new Point3D(5.0, 6.0, 7.0);
      
      Point3D z = x + y;
      expect(z, equals(new Point3D(6.0, 8.0, 10.0)));
    });
    
    test("- operator", () {
      Point3D x = new Point3D(3.0, 4.0, 5.0);
      Point3D y = new Point3D(1.0, 1.0, 2.0);
      
      Point3D z = x - y;
      expect(z, equals(new Point3D(2.0, 3.0, 3.0)));
    });
    
    test("* operator - Scalar", () {
      Point3D x = new Point3D(2.0, 4.0, 3.0);
      num a = 0.5;
      
      Point3D y = x * new Matrix.Scalar(a);
      expect(y, equals(new Point3D(1.0, 2.0, 1.5)));
    });
    
    test("* operator - Matrix Identity", () {
      Point3D x = new Point3D(1.0, 2.0, 3.0);
      Matrix a = new Matrix.I(3);
      
      Point3D y = x * a;
      expect(y, equals(new Point3D(1.0, 2.0, 3.0)));
    });
    
    test("* operator - Matrix RotateX", () {
      Point3D x = new Point3D(1.0, 2.0, 3.0);
      Matrix A = new Matrix.RotateX(PI/2);
      
      Point3D result = x * A;
      
      Point3D expected = new Point3D(1.0, -3.0, 2.0);
      
      double eps = pow(2, -52);
      Point3D err = new Point3D(eps, eps, eps);
      
      expect((expected - result).Abs() <= err, isTrue);
    });
    
    test("* operator - Matrix RotateY", () {
      Point3D x = new Point3D(1.0, 2.0, 3.0);
      Matrix A = new Matrix.RotateY(PI/2);
      
      Point3D result = x * A;
      
      Point3D expected = new Point3D(3.0, 2.0, -1.0);
      
      double eps = pow(2, -52);
      Point3D err = new Point3D(eps, eps, eps);
      
      expect((expected - result).Abs() <= err, isTrue);
    });
    
    test("* operator - Matrix RotateZ", () {
      Point3D x = new Point3D(1.0, 2.0, 3.0);
      Matrix A = new Matrix.RotateZ(PI/2);
      
      Point3D result = x * A;
      
      Point3D expected = new Point3D(-2.0, 1.0, 3.0);
      
      double eps = pow(2, -52);
      Point3D err = new Point3D(eps, eps, eps);
      
      expect((expected - result).Abs() <= err, isTrue);
    });
  });
}