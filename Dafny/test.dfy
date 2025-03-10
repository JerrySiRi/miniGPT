
// ---- Error 1：正常错误，Dafny可以证明该后置条件是错误的 ----
/*
method MultipleReturns(x: int, y: int) returns (more: int, less: int)
   ensures less < x // 输入和输出来比较 ~
   ensures x < more
   // 二者可以通过 && 来合并 -- ensures less < x && x < more
   // 或可以使用连等 -- ensures less < x < more
{
   more := x + y;
   less := x - y;
}
*/
/*
method MultipleReturns(x: int, y: int) returns (more: int, less: int)
   requires 0 < y
   ensures less < x < more
{
   more := x + y;
   less := x - y;
}
*/



//---- Error 2: 语法错误，可以直接索引到Dafny的Document去拿到错误信息，加到Prompt中 ----

/*
method Abs(x: int) returns (y: int)
   ensures 0 <= y
{
   ...
}
*/


//---- Error 3: （函数调用）Assertion might not hold ----
//    Dafny无法记得之前method中定义的内容，导致SMT求解器无法解决（但这样速度快）
// 错误1：正确定义方法，但不知道之前的定义内容
// 错误2：错误定义方法（如把Abs直接定义成y:=0)，但和正确定义方法拿到了相同的结果（reward）

/*
// 错误原因：因为post-condition定义不足所导致的！
method Abs(x: int) returns (y: int)
   ensures 0 <= y
{
    if x >= 0
        {return x;}
    else
        {return -x;}
}
*/
/*
method Abs(x: int) returns (y: int)
   ensures 0 <= y
   ensures 0 <= x ==> x == y
   ensures x < 0 ==> y == -x
   // 二者的等效表达 ensures 0 <= y && (y == x || y == -x)
{
   if x >= 0
        {return x;}
    else
        {return -x;}
}

method Testing()
{
   var v := Abs(3);
   assert 0 <= v;
   assert v == 3; // 此时在post中加入了y和x的关系，所以可以判断了！
}
*/

// ----- Error 4: 没写循环不变量 ---- 
// 错误 1：没写循环不变量
// 错误 2：循环不变量写的不够

function fib(n: nat): nat // 自然数（非负整数）
{
   if n == 0 then 0 else
   if n == 1 then 1 else
                  fib(n - 1) + fib(n - 2)
}

method ComputeFib(n: nat) returns (b: nat)
   ensures b == fib(n)
{
   if n == 0 { return 0; }
   var i: int := 1;
   var a := 0;
       b := 1;
   while i < n
      invariant 0 < i <= n
      invariant a == fib(i - 1)
      invariant b == fib(i)
   {
      a, b := b, a + b;
      i := i + 1;
   }
}


