method findOrder(numCourses: int, prerequisites: seq<(int, int)>) 
    returns (order: seq<int>)
  requires numCourses >= 0
  // 若能完成所有课程，则返回长度为 numCourses 的序列；否则返回空序列
  ensures |order| == numCourses || order == []
{
  // ---------- 1. 构建邻接表 adjacency ----------
  // adjacency[i] 存放课程 i 的所有先修课程列表
  var adjacency := new seq<int>[numCourses];

  // 初始化：先把每门课的邻接表置为空序列
  var i := 0;
  while i < numCourses
    invariant 0 <= i <= numCourses
    modifies adjacency
  {
    adjacency[i] := [];
    i := i + 1;
  }

  // 将 prerequisites 中的 [cur, pre] 加入 adjacency[cur] 列表
  var idx := 0;
  while idx < |prerequisites|
    invariant 0 <= idx <= |prerequisites|
    modifies adjacency
  {
    var (cur, pre) := prerequisites[idx];
    // 这里假设 0 <= cur,pre < numCourses，若需安全性可加相应 requires 检查
    adjacency[cur] := adjacency[cur] + [pre];
    idx := idx + 1;
  }

  // ---------- 2. 构建访问标记 visited ----------
  // visited[i] 的取值含义：0=未访问, 1=正在访问, 2=访问完毕
  var visited := new int[numCourses];
  i := 0;
  while i < numCourses
    invariant 0 <= i <= numCourses
    modifies visited
  {
    visited[i] := 0;
    i := i + 1;
  }

  // ---------- 3. 调用 DFS 进行拓扑排序 ----------
  // res 用于动态保存排好的序列，初始为空
  var res := [];
  i := 0;
  while i < numCourses
    invariant 0 <= i <= numCourses
    modifies visited
  {
    var (ok, newRes) := dfs(i, adjacency, visited, res);
    if !ok {
      // 出现环，无法完成所有课程
      return [];
    }
    // 若成功，就更新当前已排好的课程列表
    res := newRes;
    i := i + 1;
  }

  return res;
}

// ---------- 4. DFS 方法：检测环路 + 后序入栈 ----------
// 返回 (ok, updatedRes)
//  - ok 表示在从课程 u 开始的 DFS 搜索中是否无环
//  - updatedRes 是在原序列 res 基础上追加课程 u 后形成的新序列
method dfs(u: int, adjacency: array<seq<int>>, visited: array<int>, res: seq<int>) 
    returns (ok: bool, updatedRes: seq<int>)
  modifies visited
{
  // 如果 visited[u] == 1，表示在本次 DFS 路径上又遇到 u => 形成环
  if visited[u] == 1 {
    return (false, res);
  }
  // 如果 visited[u] == 2，表示 u 已处理过，直接跳过
  if visited[u] == 2 {
    return (true, res);
  }

  // 标记 u 为“正在访问”
  visited[u] := 1;
  var neighbors := adjacency[u];

  // 依次 DFS 访问 u 的所有先修课程
  var k := 0;
  var localRes := res;
  while k < |neighbors|
    invariant 0 <= k <= |neighbors|
    modifies visited
  {
    var next := neighbors[k];
    var (cont, newRes) := dfs(next, adjacency, visited, localRes);
    if !cont {
      // 若探测到环路，直接返回 false
      return (false, localRes);
    }
    localRes := newRes;
    k := k + 1;
  }

  // 所有先修课程访问结束后，标记 u = 2（访问完毕），把 u 加入结果序列
  visited[u] := 2;
  localRes := localRes + [u];
  return (true, localRes);
}