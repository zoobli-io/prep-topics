using System;
sealed class SealedClass
{
    public int x;
    public int y;
}
 
class SealedTest
{
    static void Main()
    {
        SealedClass sc = new SealedClass();
        sc.x = 100;
        sc.y = 180;
        Console.WriteLine("x = {0}, y = {1}", sc.x, sc.y);
        Console.ReadLine();
    }
}