library utility.vector;

import 'dart:math';

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

/*

Matrix multiplication

(m x n) * (n x p) = (m x p)
A       * B       = C

Cij = sum k=1:m ( Aik * Bkj )

*/
typedef num MatrixGenerator(int i, int j);

num MatrixMultiplication(int i, int j, Matrix A, Matrix B)
{
  num result = 0;
  for (int k = 0; k < A.m; k++)
  {
    result += A[[i, k]] * B[[k, j]];
  }
  return result;
}

num MatrixAddition(int i, int j, Matrix A, Matrix B)
{
  return A[[i,j]] + B[[i,j]];
}

num RotationX(int i, int j, num theta)
{
  if (i == 1)
  {
    if (j == 1)
    {
      return cos(-theta);
    }
    else if (j == 2)
    {
      return -sin(-theta);
    }
    else
    {
      return 0;
    }
  }
  else if (i == 2)
  {
    if (j == 1)
    {
      return sin(-theta);
    }
    else if (j == 2)
    {
      return cos(-theta);
    }
    else
    {
      return 0;
    }
  }
  else if (i == j)
  {
    return 1;
  }
  else
  {
    return 0;
  }
}

num RotationY(int i, int j, num theta)
{
  if (i == 0)
  {
    if (j == 0)
    {
      return cos(-theta);
    }
    else if (j == 2)
    {
      return sin(-theta);
    }
    else
    {
      return 0;
    }
  }
  else if (i == 2)
  {
    if (j == 0)
    {
      return -sin(-theta);
    }
    else if (j == 2)
    {
      return cos(-theta);
    }
    else
    {
      return 0;
    }
  }
  else if (i == j)
  {
    return 1;
  }
  else 
  {
    return 0;
  }
}

num RotationZ(int i, int j, num theta)
{
  if (i == 0)
  {
    if (j == 0)
    {
      return cos(-theta);
    }
    else if (j == 1)
    {
      return -sin(-theta);
    }
    else
    {
      return 0;
    }
  }
  else if (i == 1)
  {
    if (j == 0)
    {
      return sin(-theta);
    }
    else if (j == 1)
    {
      return cos(-theta);
    }
    else
    {
      return 0;
    }
  }
  else if (i == j)
  {
    return 1;
  }
  else 
  {
    return 0;
  }
}

num IdentityMatrix(int i, int j)
{
  if (i == j)
  {
    return 1;
  }
  else
  {
    return 0;
  }
}

class Matrix
{
  int m, n;
  List<num> values;
  
  Matrix(this.m, this.n, [MatrixGenerator g])
  {
    this.values = new List<num>(this.m * this.n);
    if (g != null)
    {
      for (int i = 0; i < m; i++)
      {
        for (int j = 0; j < n; j++)
        {
          this[[i, j]] = g(i, j);
        }
      }
    }
  }
  
  Matrix.I(int n) : this(n, n, IdentityMatrix);
  
  operator [](List<num> indicies) 
  {
    return this.values[indicies[0] + indicies[1]*this.m];
  }
  operator []=(List<int> indicies, num value)
  {
    this.values[indicies[0] + indicies[1]*this.m] = value;
  }
  
  operator *(Matrix m)
  {
    if (this.n != m.m)
    {
      throw new Exception('The inner dimensions of the matricies must match.');
    }
    return new Matrix(this.m, m.n, (int i, int j) => MatrixMultiplication(i, j, this, m));
  }
  
  operator +(Matrix m)
  {
    if (this.m != m.m || this.n != m.n)
    {
      throw new Exception('The matrix dimensions must match.');
    }
    return new Matrix(this.m, this.n, (int i, int j) => MatrixAddition(i, j, this, m));
  }
}