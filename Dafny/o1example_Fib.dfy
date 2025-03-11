// ChatGPT o1 OUTPUT: Correct!!!

// 定义类 Solution
class Solution {

  // 第一步：用“函数”纯逻辑地定义斐波那契，用于规范(spec)和证明
  function fibSpec(n: nat): nat
    decreases n
  {
    if n < 2 then n
    else fibSpec(n - 1) + fibSpec(n - 2)
  }

  // 第二步：用“方法”来实际执行斐波那契的计算
  method fib(n: nat) returns (res: nat)
    requires n >= 0
    ensures res == fibSpec(n)  // 注意：ensures 中只调用 fibSpec 函数
    decreases n                // 声明递归调用的终止度量
  {
    if n == 0 {
      return 0;
    } else if n == 1 {
      return 1;
    } else {
      // 这里在方法体中，可以调用自身方法，因为这是在可执行上下文里
      var a := fib(n - 1);
      var b := fib(n - 2);
      return a + b;
    }
  }
}