import subprocess
import os
print(os.getcwd())  # 查看当前工作目录
print(os.path.exists("test1.dfy"))  # 检查文件是否存在

def run_dafny():
    dafny_path = r"C:\Program Files\dotnet\dotnet.exe"  # 请替换为你的 Dafny 路径
    result = subprocess.run([dafny_path, "test1.dfy"], capture_output=True, text=True)
    return result.stdout  # 返回编译器输出

run_dafny()


def cal_AUCPR_AP(labels, scores):
    auc_pr = ap = 0
    tp_and_fn = labels.count(1)
    precision = [1, 0]
    recall = [0, 0]
    pairs = sorted(zip(scores, labels), reverse=True)
    for i in range(len(pairs)):
        precision[1] = (precision[0]*i + int(pairs[i][1] == 1))/(i+1)
        recall[1] = recall[0] + int(pairs[i][1] == 1)/tp_and_fn
        auc_pr += (recall[1]-recall[0]) * (precision[1]+precision[0]) / 2
        ap += (recall[1]-recall[0]) * precision[1]
        precision[0], recall[0] = precision[1], recall[1]
    return auc_pr, ap
labels = [1,2,1,1,2,1,2,2,1,2]
scores = [1, 0.9, 0.8, 0.7, 0.6, 0.5, 0.4, 0.3, 0.2, 0.1]
print(cal_AUCPR_AP(labels, scores))