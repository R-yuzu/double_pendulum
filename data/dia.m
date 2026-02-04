% 读取双摆模拟结果文件
clear; clc;
cd 'C://Users/wudou/zhz/zhz/clt/zzh/';
% 设置文件名
filename = './data/double_pendulum_results.txt';
% 检查文件是否存在
if ~exist(filename, 'file')
    error('文件不存在: %s\n请确保已经运行了Fortran程序并生成了结果文件。', filename);
end
% 读取数据
fprintf('正在读取文件: %s\n', filename);
% 使用textscan读取文件（跳过第一行表头）
fid = fopen(filename, 'r');
if fid == -1
    error('无法打开文件: %s', filename);
end
% 读取表头
header = fgetl(fid);
% 使用textscan读取数据（科学计数法格式）
data = textscan(fid, '%f %f %f %f %f %f %f %f');
% 关闭文件
fclose(fid);
% 提取各列数据到工作区
time = data{1};              % 时间 (s)
theta = data{2};             % θ角 (rad)
phi = data{3};               % φ角 (rad)
theta_dot = data{4};         % θ角速度 (rad/s)
phi_dot = data{5};          % φ角速度 (rad/s)
kinetic = data{6};           % 动能 (J)
potential = data{7};         % 势能 (J)
total = data{8};             % 总能量 (J)
% 显示基本信息
fprintf('数据读取成功！\n');
fprintf('总数据点数: %d\n', length(time));
fprintf('时间范围: %.2f ~ %.2f s\n', time(1), time(end));
fprintf('θ角范围: %.4f ~ %.4f rad\n', min(theta), max(theta));
fprintf('φ角范围: %.4f ~ %.4f rad\n', min(phi), max(phi));
fprintf('总能量范围: %.6f ~ %.6f J\n', min(total), max(total));
% 计算能量相对误差（检查能量守恒）
energy_error = (max(total) - min(total)) / mean(total) * 100;
fprintf('能量相对误差: %.4e %%\n', energy_error);
% 可选：将数据保存为.mat文件以便后续使用
%save('double_pendulum_data.mat', 'time', 'theta', 'phi', 'theta_dot', 'phi_dot', ...'kinetic', 'potential', 'total', 'header');
%fprintf('数据已保存到工作区变量中，并已保存为 double_pendulum_data.mat 文件。\n');
fprintf('可用变量:\n');
fprintf('  time: 时间序列\n');
fprintf('  theta, phi: 角度\n');
fprintf('  theta_dot, phi_dot: 角速度\n');
fprintf('  kinetic, potential, total: 能量\n');
fprintf('  header: 表头信息\n');
dir='./result/';
figure;
plot(time,theta,'LineWidth',1.5,'Color','b');
title('$$\theta\sim t$$','Interpreter','latex','FontSize',16);
xlabel('$$t$$','Interpreter','latex','FontSize',16);
ylabel('$$\theta$$','Interpreter','latex','FontSize',16);
legend('$$\theta$$','Interpreter','latex','Location','north');
fname=sprintf('theta-t');
print('-dpng',[dir '/' fname]);
close;
figure;
plot(time,phi,'LineWidth',1.5,'Color','b');
title('$$\varphi\sim t$$','Interpreter','latex','FontSize',16);
xlabel('$$t$$','Interpreter','latex','FontSize',16);
ylabel('$$\varphi$$','Interpreter','latex','FontSize',16);
legend('$$varphi$$','Interpreter','latex','Location','north');
fname=sprintf('phi-t');
print('-dpng',[dir '/' fname]);
close;
figure;
plot(time,phi_dot,'LineWidth',1.5,'Color','b');
title('$$\dot{\varphi}\sim t$$','Interpreter','latex','FontSize',16);
xlabel('$$t$$','Interpreter','latex','FontSize',16);
ylabel('$$\dot{\varphi}$$','Interpreter','latex','FontSize',16);
legend('$$\dot{\varphi}$$','Interpreter','latex','Location','north');
fname=sprintf('phi_dot-t');
print('-dpng',[dir '/' fname]);
close;
figure;
plot(time,phi_dot,'LineWidth',1.5,'Color','b');
title('$$\dot{\theta}\sim t$$','Interpreter','latex','FontSize',16);
xlabel('$$t$$','Interpreter','latex','FontSize',16);
ylabel('$$\dot{\theta}$$','Interpreter','latex','FontSize',16);
legend('$$\dot{\theta}$$','Interpreter','latex','Location','north');
fname=sprintf('theta_dot-t');
print('-dpng',[dir '/' fname]);
close;
figure;
plot(time,kinetic,'LineWidth',1.5,'Color','b');
title('$$T\sim t$$','Interpreter','latex','FontSize',16);
xlabel('$$t$$','Interpreter','latex','FontSize',16);
ylabel('$$T$$','Interpreter','latex','FontSize',16);
legend('$$T$$','Interpreter','latex','Location','north');
fname=sprintf('T-t');
print('-dpng',[dir '/' fname]);
close;
figure;
plot(time,potential,'LineWidth',1.5,'Color','b');
title('$$V\sim t$$','Interpreter','latex','FontSize',16);
xlabel('$$t$$','Interpreter','latex','FontSize',16);
ylabel('$$V$$','Interpreter','latex','FontSize',16);
legend('$$V$$','Interpreter','latex','Location','north');
fname=sprintf('V-t');
print('-dpng',[dir '/' fname]);
close;
figure;
plot(time,total,'LineWidth',5,'Color','b');
title('E');

close;

% 设置参数
l = 1.0;  % 摆长
skip_frames = 20;  % 跳过帧数（加速动画）
% 提取部分数据用于动画
indices = 1:skip_frames:length(time);
time_anim = time(indices);
theta_anim = theta(indices);
phi_anim = phi(indices);

% 计算笛卡尔坐标
x1 = l * sin(theta_anim);
y1 = -l * cos(theta_anim);
x2 = x1 + l * sin(phi_anim);
y2 = y1 - l * cos(phi_anim);

% 创建图形窗口
figure('Position', [100, 100, 800, 800]);
axis equal;
xlim([-2.1*l, 2.1*l]);
ylim([-2.1*l, 2.1*l]);
grid on;
hold on;
title('双摆运动动画');
xlabel('x');
ylabel('y');
% 绘制固定点
plot(0, 0, 'ko', 'MarkerSize', 12, 'MarkerFaceColor', 'k');
% 初始化图形对象
pendulum_line1 = plot([0, x1(1)], [0, y1(1)], 'b-', 'LineWidth', 1);
pendulum_line2 = plot([x1(1), x2(1)], [y1(1), y2(1)], 'r-', 'LineWidth', 1);
mass1 = plot(x1(1), y1(1), 'bo', 'MarkerSize', 12, 'MarkerFaceColor', 'b');
mass2 = plot(x2(1), y2(1), 'ro', 'MarkerSize', 12, 'MarkerFaceColor', 'r');
trajectory = plot(x2(1), y2(1), 'g-', 'LineWidth', 1.5, 'Color', [0, 0.7, 0, 0.5]);
% 时间显示文本
time_text = text(-2*l, -0.5*l, sprintf('时间: %.2f s', time_anim(1)), ...
    'FontSize', 14, 'FontWeight', 'bold');
% 轨迹数据存储
trajectory_x = [];
trajectory_y = [];
% 生成动画
fprintf('生成动画...\n');
for i = 1:length(time_anim)
    % 更新摆的位置
    set(pendulum_line1, 'XData', [0, x1(i)], 'YData', [0, y1(i)]);
    set(pendulum_line2, 'XData', [x1(i), x2(i)], 'YData', [y1(i), y2(i)]);
    set(mass1, 'XData', x1(i), 'YData', y1(i));
    set(mass2, 'XData', x2(i), 'YData', y2(i));
    
    % 更新轨迹
    trajectory_x = [trajectory_x, x2(i)];
    trajectory_y = [trajectory_y, y2(i)];
    set(trajectory, 'XData', trajectory_x, 'YData', trajectory_y);
    
    % 更新时间显示
    set(time_text, 'String', sprintf('时间: %.2f s', time_anim(i)));
    
    % 刷新图形
    drawnow;
    
    % 暂停控制动画速度
    pause(0.01);
end
fprintf('动画完成\n');