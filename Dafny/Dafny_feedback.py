import subprocess
import os
print(os.getcwd())  # 查看当前工作目录
print(os.path.exists("test1.dfy"))  # 检查文件是否存在

def run_dafny():
    dafny_path = r"C:\Program Files\dotnet\dotnet.exe"  # 请替换为你的 Dafny 路径
    result = subprocess.run([dafny_path, "test1.dfy"], capture_output=True, text=True)
    return result.stdout  # 返回编译器输出

run_dafny()