library utility.matrix;

import "dart:math";

/*

Matrix multiplication

(m x n) * (n x p) = (m x p)
A       * B       = C

Cij = sum k=1:m ( Aik * Bkj )

*/
typedef double MatrixGenerator(int i, int j);

double MatrixMultiplication(int i, int j, Matrix A, Matrix B)
{
  double result = 0.0;
  for (int k = 0; k < A.n; result += A[[i, k]] * B[[k, j]], k++);
  return result;
}

double MatrixAddition(int i, int j, Matrix A, Matrix B)
{
  return A[[i,j]] + B[[i,j]];
}

double RotationX(int i, int j, double theta)
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
      return 0.0;
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
      return 0.0;
    }
  }
  else if (i == j)
  {
    return 1.0;
  }
  else
  {
    return 0.0;
  }
}

double RotationY(int i, int j, double theta)
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
      return 0.0;
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
      return 0.0;
    }
  }
  else if (i == j)
  {
    return 1.0;
  }
  else 
  {
    return 0.0;
  }
}

double RotationZ(int i, int j, double theta)
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
      return 0.0;
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
      return 0.0;
    }
  }
  else if (i == j)
  {
    return 1.0;
  }
  else 
  {
    return 0.0;
  }
}

double IdentityMatrix(int i, int j)
{
  if (i == j)
  {
    return 1.0;
  }
  else
  {
    return 0.0;
  }
}

class Matrix
{
  int m, n;
  List<double> values;
  
  Matrix(this.m, this.n, [MatrixGenerator g])
  {
    this.values = new List<double>(this.m * this.n);
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
  
  Matrix.Scalar(num a) : this(1, 1, (int i, int j) => a);
  
  Matrix.RotateX(double theta) : this(3, 3, (int i, int j) => RotationX(i, j, theta));
  Matrix.RotateY(double theta) : this(3, 3, (int i, int j) => RotationY(i, j, theta));
  Matrix.RotateZ(double theta) : this(3, 3, (int i, int j) => RotationZ(i, j, theta));
  
  Matrix Abs()
  {
    return new Matrix(this.m, this.n, (int i, int j) => this[[i, j]].abs());
  }
  
  Matrix Multiply(Matrix m)
  {
    if (this.n != m.m)
    {
      throw new Exception('The inner dimensions of the matricies must match.');
    }
    return new Matrix(this.m, m.n, (int i, int j) => MatrixMultiplication(i, j, this, m));
  }
  
  Matrix Add(Matrix m)
  {
    if (this.m != m.m || this.n != m.n)
    {
      throw new Exception('The matrix dimensions must match.');
    }
    return new Matrix(this.m, this.n, (int i, int j) => MatrixAddition(i, j, this, m));
  }
  
  Matrix Subtract(Matrix m)
  {
    if (this.m != m.m || this.n != m.n)
    {
      throw new Exception('The matrix dimensions must match.');
    }
    return new Matrix(this.m, this.n, (int i, int j) => this[[i,j]] - m[[i,j]]);
  }
  
  double operator [](List<int> indicies) 
  {
    return this.values[indicies[0]*this.n + indicies[1]];
  }
  
  operator []=(List<int> indicies, num value)
  {
    this.values[indicies[0]*this.n + indicies[1]] = value;
  }
  
  operator *(Matrix m)
  {
    return this.Multiply(m);
  }
  
  operator +(Matrix m)
  {
    return this.Add(m);
  }
  
  operator -(Matrix m)
  {
    return this.Subtract(m);
  }
}