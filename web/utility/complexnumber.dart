library utility.complex;

import "dart:math";

class Complex
{
  num _real, _imag;
  
  num get real => this._real;
  num get imag => this._imag;
  
  Complex([this._real = 0, this._imag = 0]);
  
  ///
  /// @function e
  /// 
  /// @returns Complex
  /// 
  /// This function creates a Complex with the form:
  /// e^(i*x) = cox(x) + i*sin(x)
  /// 
  static Complex e(num arg)
  {
    return new Complex(cos(arg), sin(arg));
  }
 
  ///
  /// @function Mag
  /// 
  /// @return num
  /// 
  /// This function returns the magnitude of the complex number.
  /// z = x + i*y
  /// Mag = sqrt(x^2 + y^2)
  /// 
  num Mag()
  {
    return sqrt(real*real + imag*imag);
  }
  
  ///
  /// @function Mag2()
  /// 
  /// @return num
  /// 
  /// This function returns the magnitude squared of the complex number.
  /// z = x + i*y
  /// Mag2 = x^2 + y^2
  /// 
  num Mag2()
  {
    return real*real + imag*imag;
  }
  
  ///
  /// @function Conj
  /// 
  /// @returns Complex
  /// 
  /// This function returns the complex conjugate of the complex number.
  /// z = x + i*y
  /// Conj = x - i*y
  /// 
  Complex Conj()
  {
    return new Complex(real, -imag);
  }
  
  ///
  /// This section handles the operations +, -, *, and / of a Complex with
  /// another Complex or a num
  /// 
  operator +(var x)
  {
    if (x is Complex)
    {
      return new Complex(real + x.real, imag + x.imag);
    }
    else if (x is num)
    {
      return new Complex(real + x, imag);
    }
  }
  
  operator -(var x)
  {
    if (x is Complex)
    {
      return new Complex(real-x.real, imag-x.imag);
    }
    else if (x is num)
    {
      return new Complex(real-x, imag);
    }
  }
  
  operator *(var x)
  {
    if (x is Complex)
    {
      return new Complex(real*x.real-imag*x.imag, real*x.imag+x.real*imag);
    }
    else if (x is num)
    {
      return new Complex(real*x, imag*x);
    }
  }
  
  operator /(var x)
  {
    if (x is Complex)
    {
      return new Complex((real*x.real + imag*x.imag)/x.Mag2(), (x.real*imag - real*x.imag)/x.Mag2());
    }
    else if (x is num)
    {
      return new Complex(real/x, imag/x);
    }
  }
}