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

List<double> RotationMatrixX(double theta)
{
  return [1.0, 0.0, 0.0,
        0.0, cos(theta), -sin(theta),
        0.0, sin(theta), cos(theta)];
}

List<double> RotationMatrixY(double theta)
{
  return [cos(theta), 0.0, sin(theta),
        0.0, 1.0, 0.0,
        -sin(theta), 0.0, cos(theta)];
}

List<double> RotationMatrixZ(double theta)
{
  return [cos(theta), -sin(theta), 0.0,
          sin(theta), cos(theta), 0.0,
          0.0, 0.0, 1.0];
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
  
  Matrix.RotateX(double theta) : this.fromList(3, 3, RotationMatrixX(theta));
  Matrix.RotateY(double theta) : this.fromList(3, 3, RotationMatrixY(theta));
  Matrix.RotateZ(double theta) : this.fromList(3, 3, RotationMatrixZ(theta));
  
  Matrix.fromList(this.m, this.n, List<double> values)
  {
    if (values.length != this.m * this.n)
    {
      throw new Exception("There must be the correct number of values");
    }
    this.values = values;
  }
  
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