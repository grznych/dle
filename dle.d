#!/usr/bin/rdmd
import std.stdio, std.string, std.regex, std.array;
import std.numeric : gcd;
import std.math : abs, sgn;
import std.conv : to;
import std.algorithm : remove;

int r(int a, int m) { return (a %= m) + (a < 0 ? m : 0); }

int modIn(int a, int m)
{
    if (m == 1) return 0;
    int k = m, y, x = 1;
    a = a.r(m);
    while (a > 1)
    {
        x = y - (m / a) * (y = x);
        a = m % (m = a);
    }
    return x < 0 ? x + k : x;
}

void main()
{
    string s;
    do
    {
        "Уравнение: ".write;
        s = readln.replaceAll(`\s`.regex, "");
    }
    while (!s.matchFirst(`^-?(\d*[A-Za-zА-Яа-яЁё]+[+-])*\d*[A-Za-zА-Яа-яЁё]+=-?\d+$`));

    auto num = s.splitter(`[A-Za-zА-Яа-яЁё=]+`.regex).array, n = num.length,
         symb = s.splitter(`[\d=+-]+`.regex).array.remove!`a==""`,
         a = new int[n], gcd_a = new int[n], sol = new int[][n-1];

    foreach_reverse (i, e; num[0..$-1])
    {
        sol[i] = new int[i+2];
        gcd_a[i] = gcd_a[i+1].gcd((a[i+1] = (e ~ (e.isNumeric ? "" : "1")).to!int).abs);
    }

    if ((a[0] = -num[$-1].to!int) % (a[0] /= gcd_a[0]) != 0) "Решений нет!".writeln;
    else
    {
        foreach (i, e; gcd_a[0..$-2])
        {
            int m = (a[i+1..$] /= e)[0].modIn(sol[i][i+1] = (gcd_a[i+1..$] /= e)[0]);
            foreach (k, ref t; a[0..i+1])
                (t += a[i+1] * (sol[i][k] = (-m * t).r(gcd_a[i+1]))) /= gcd_a[i+1];
        }
        sol[$-1] = (sol[$-1][] = a[] * (-a[$-1]).sgn)[0..$-1];

        "Решение:".writeln;
        foreach (i, e; sol)
        {
            bool enter;
            symb[i].write("\t= ");
            foreach (k, t; e)
            {
                if (t == 0) continue;
                (enter ? t < 0 ? " - " : " + " : t < 0 ? "- " : "").write;
                (t.abs != 1 || k == 0) && t.abs.write;
                k != 0 && "C[%s]".writef(k);
                enter = true;
            }
            writeln;
        }
    }
}
