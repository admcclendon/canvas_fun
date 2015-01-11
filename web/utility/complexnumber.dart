library utility.complex;

import "dart:math";

class ComplexNumber
{
  num _real, _imag;
  
  num get real => this._real;
  num get imag => this._imag;
  
  ComplexNumber([this._real = 0, this._imag = 0]);
  
  ///
  /// @function e
  /// 
  /// @returns ComplexNumber
  /// 
  /// This function creates a ComplexNumber with the form:
  /// e^(i*x) = cox(x) + i*sin(x)
  /// 
  static ComplexNumber e(num arg)
  {
    return new ComplexNumber(cos(arg), sin(arg));
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
  /// @returns ComplexNumber
  /// 
  /// This function returns the complex conjugate of the complex number.
  /// z = x + i*y
  /// Conj = x - i*y
  /// 
  ComplexNumber Conj()
  {
    return new ComplexNumber(real, -imag);
  }
  
  ///
  /// This section handles the operations +, -, *, and / of a ComplexNumber with
  /// another ComplexNumber or a num
  /// 
  operator +(var x)
  {
    if (x is ComplexNumber)
    {
      return new ComplexNumber(real + x.real, imag + x.imag);
    }
    else if (x is num)
    {
      return new ComplexNumber(real + x, imag);
    }
  }
  
  operator -(var x)
  {
    if (x is ComplexNumber)
    {
      return new ComplexNumber(real-x.real, imag-x.imag);
    }
    else if (x is num)
    {
      return new ComplexNumber(real-x, imag);
    }
  }
  
  operator *(var x)
  {
    if (x is ComplexNumber)
    {
      return new ComplexNumber(real*x.real-imag*x.imag, real*x.imag+x.real*imag);
    }
    else if (x is num)
    {
      return new ComplexNumber(real*x, imag*x);
    }
  }
  
  operator /(var x)
  {
    if (x is ComplexNumber)
    {
      return new ComplexNumber((real*x.real + imag*x.imag)/x.Mag2(), (x.real*imag - real*x.imag)/x.Mag2());
    }
    else if (x is num)
    {
      return new ComplexNumber(real/x, imag/x);
    }
  }
}