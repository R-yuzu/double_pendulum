# 编译器设置
FC = gfortran
FFLAGS = -O2 -Wall -Wextra
LDFLAGS = 

# 目标文件
OBJS = constants_module.o rk4_solver_module.o energy_module.o output_module.o main.o

# 可执行文件
TARGET = double_pendulum

# 默认目标
all: $(TARGET)

# 链接可执行文件
$(TARGET): $(OBJS)
	$(FC) $(FFLAGS) -o $(TARGET) $(OBJS) $(LDFLAGS)

# 编译主程序
main.o: main.f90 constants_module.o rk4_solver_module.o output_module.o
	$(FC) $(FFLAGS) -c main.f90

# 编译输出模块
output_module.o: output_module.f90 constants_module.o energy_module.o
	$(FC) $(FFLAGS) -c output_module.f90

# 编译能量模块
energy_module.o: energy_module.f90 constants_module.o
	$(FC) $(FFLAGS) -c energy_module.f90

# 编译求解器模块
rk4_solver_module.o: rk4_solver_module.f90 constants_module.o
	$(FC) $(FFLAGS) -c rk4_solver_module.f90

# 编译常量模块
constants_module.o: constants_module.f90
	$(FC) $(FFLAGS) -c constants_module.f90

# 清理
clean:
	rm -f *.o *.mod $(TARGET)

# 运行
run: $(TARGET)
	./$(TARGET)

# 查看结果
check:
	@echo "前10行结果:"
	@head -n 11 double_pendulum_results.txt

.PHONY: all clean run check