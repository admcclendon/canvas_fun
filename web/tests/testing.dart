import "package:test/test.dart";

import "../engine/utility/point.dart";

void main()
{
  group("Point3D ", () {
    test(" + operator", () {
      Point3D x = new Point3D(1.0, 2.0, 3.0);
      Point3D y = new Point3D(5.0, 6.0, 7.0);
      
      Point3D z = x + y;
      expect(z, equals(new Point3D(6.0, 8.0, 10.0)));
    });
  });
}