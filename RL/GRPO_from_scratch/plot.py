import matplotlib.pyplot as plt
import numpy as np

# 1. 准备数据
timesteps = np.array([1, 2, 4, 8, 16, 32, 64, 128])
speed     = np.array([15, 12, 4,  2,  0.3,  0.1*1.5, 0.2*0.25, 0.2*2**(-4)])    # 实例/s
quality   = np.array([ 0,  2, 5, 12, 18, 23, 33, 45])     # 准确率

# 2. 创建画布和双 y 轴
fig, ax1 = plt.subplots(figsize=(8, 4.5))
# 为了给下方文字留空间，放大底部边距
# fig.subplots_adjust(bottom=0.8)
fig.subplots_adjust(bottom=0.30, top=0.90)

# —— 速度（红）——
ax1.plot(timesteps, speed, 'o-', color='red', label='Speed (instances/s)')
ax1.set_xlabel('Diffusion Timesteps')
ax1.set_ylabel('Speed (instances per second)', color='red')
ax1.tick_params(axis='y', labelcolor='red')
ax1.set_xticks(timesteps)
ax1.set_xlim(0, 128)

# 水平参考线：Qwen2.5 7B Instruct Speed
ax1.hlines(0.2, xmin=0, xmax=128, colors='green', linestyles='--')
ax1.text(67, 1, 'Qwen2.5-7B-Instruct Speed: 0.2 (instance/s)', va='center', color='green')

# —— 质量（蓝）——
ax2 = ax1.twinx()
ax2.plot(timesteps, quality, '^-', color='blue', label='Quality (Accuracy)')
ax2.set_ylabel('Accuracy', color='blue')
ax2.tick_params(axis='y', labelcolor='blue')

# 水平参考线：Qwen2.5 7B Instruct Accuracy
ax2.hlines(66.7, xmin=0, xmax=128, colors='green', linestyles='--')
ax2.text(75, 60, 'Qwen2.5-7B-Instruct Accuracy: 66.7%', va='center', color='green')

# 3. 底部绿色区间线 + 箭头
# annotation_clip=False 允许标注超出坐标轴范围
ax1.annotate(
    '', xy = (1, -3), xytext = (128, -3),
    arrowprops = dict(arrowstyle='<->', color='purple', lw=2),
    annotation_clip = False
)

# 4. 在下方添加三段说明文字
# y 座标取 -7（相对于数据坐标），并且 annotation_clip=False
"""ax1.text(5,  -9, 'Speed >> AR\nQuality < AR', 
         color='red', ha='center', va='top', fontsize=10,)
ax1.text(13, -9, 'Speed > AR\nQuality > AR',
         color='purple', ha='center', va='top', fontsize=10,)
ax1.text(25, -9, 'Speed > AR\nQuality > AR',
         color='gray', ha='center', va='top', fontsize=10,)
ax1.text(64, -9, 'Speed < AR\nQuality >> AR',
         color='red', ha='center', va='top', fontsize=10,)"""


# 4. 底部只放 A, B, C
for x, label in [(5, 'A'), (13, 'B'), (25, 'C'), (64, 'D')]:
    ax1.text(
        x, -0.15, label,
        fontsize=14, fontweight='bold',
        ha='center', va='top',
        transform=ax1.get_xaxis_transform(),
    )

# 5. 主图内部放各区间的文字说明（使用 Axes 坐标系）
sections = [
    (0.83, 0.38, 'A: Speed >> AR    Quality << AR', 'black'),
    (0.83, 0.33, 'B: Speed > AR     Quality << AR', 'black'),
    (0.83, 0.28, 'C: Speed < AR     Quality < AR', 'black'),
    (0.83, 0.23, 'D: Speed << AR     Quality < AR', 'black')
]
for x_frac, y_frac, txt, col in sections:
    ax1.text(
        x_frac, y_frac, txt, fontweight='bold',
        transform=ax1.transAxes,
        ha='center', va='center',
        fontsize=8, color=col,
        bbox=dict(boxstyle='round,pad=0.3',
                  fc='white', ec='none', alpha=0.7)
    )
    
    
    

# 5. 图例 & 布局
lines1, labels1 = ax1.get_legend_handles_labels()
lines2, labels2 = ax2.get_legend_handles_labels()
ax1.legend(lines1 + lines2, labels1 + labels2, loc='center right')
fig.tight_layout()

# 6. 保存为矢量 PDF
fig.savefig('Med_CoT_speed_quality_plot.pdf', format='pdf')
plt.show()