module constants_module
    implicit none
    public
    
    ! 物理常量
    real(8), parameter :: g = 9.81d0          ! 重力加速度 (m/s^2)
    real(8), parameter :: l = 1.0d0           ! 摆长 (m)
    real(8), parameter :: m = 1.0d0           ! 质量 (kg)
    
    ! 模拟参数
    real(8), parameter :: t_end = 20.0d0      ! 结束时间 (s)
    real(8), parameter :: dt = 0.001d0        ! 时间步长 (s)
    integer, parameter :: n = 4               ! 系统维度
    integer, parameter :: n_steps = nint(t_end / dt)  ! 总步数
    
    ! 初始条件 (θ, φ, θ_dot, φ_dot)
    real(8), parameter :: y0(4) = [0.1d0, 0.2d0, 0.0d0, 0.0d0]
    
end module constants_module