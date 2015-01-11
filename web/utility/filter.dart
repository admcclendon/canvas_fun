library utility.filter;

class Filter
{
  List<num> zk;
  List<num> a, b;
  
  num n;
  
  Filter(this.a, this.b)
  {
    if (this.a.length > this.b.length)
    {
      this.b.addAll(new List<num>(this.a.length-this.b.length));
    }
    else if (this.b.length > this.a.length)
    {
      this.a.addAll(new List<num>(this.b.length-this.a.length));
    }
    
    this.n = this.a.length;
    this.zk = new List<num>(this.n - 1);
  }
  
  num Run(num x)
  {
    num y = b[0] * x + zk[0];
    for (num i = 0; i < n - 1; i++)
    {
      zk[i] = b[i+1]*x + zk[i+1] - a[i+1]*y;
    }
    zk[n-1] = b[n]*x - a[n]*y;
    return y;
  }
}