module rk4_solver_module
    use constants_module, only: n, dt, g, l
    implicit none
    private
    public :: rk4_step
    
contains
    
    ! 双摆微分方程 - 严格按你的公式
    subroutine derivs(t, y, dydt)
        real(8), intent(in) :: t
        real(8), intent(in) :: y(n)        ! y = [θ, φ, θ_dot, φ_dot]
        real(8), intent(out) :: dydt(n)
        
        real(8) :: theta, phi, theta_dot, phi_dot
        real(8) :: diff, cos_diff, sin_diff, denom
        
        ! 提取变量
        theta = y(1)     ! θ
        phi = y(2)       ! φ
        theta_dot = y(3) ! θ_dot
        phi_dot = y(4)   ! φ_dot
        
        ! 角度差
        diff = theta - phi
        cos_diff = cos(diff)
        sin_diff = sin(diff)
        
        ! 分母 cos^2(θ-φ) - 2
        denom = cos_diff**2 - 2.0d0
        
        ! 状态方程
        dydt(1) = theta_dot  ! dθ/dt = θ_dot
        dydt(2) = phi_dot    ! dφ/dt = φ_dot
        
        ! dθ_dot/dt - 严格按照你的公式
        dydt(3) = (1.0d0 / denom) * &
                 (sin_diff * (cos_diff * theta_dot**2 + phi_dot**2) + &
                 (g/l) * (2.0d0 * sin(theta) - cos_diff * sin(phi)))
        
        ! dφ_dot/dt - 严格按照你的公式
        dydt(4) = (1.0d0 / denom) * &
                 (-sin_diff * (2.0d0 * theta_dot**2 + cos_diff * phi_dot**2) + &
                 (g/l) * (2.0d0 * sin(phi) - 2.0d0 * cos_diff * sin(theta)))
        
    end subroutine derivs
    
    ! 经典四阶龙格库塔单步推进
    subroutine rk4_step(t, y, y_next)
        real(8), intent(in) :: t
        real(8), intent(in) :: y(n)
        real(8), intent(out) :: y_next(n)
        
        real(8) :: k1(n), k2(n), k3(n), k4(n)
        real(8) :: y_temp(n)
        
        ! 第一步
        call derivs(t, y, k1)
        
        ! 第二步
        y_temp = y + 0.5d0 * dt * k1
        call derivs(t + 0.5d0 * dt, y_temp, k2)
        
        ! 第三步
        y_temp = y + 0.5d0 * dt * k2
        call derivs(t + 0.5d0 * dt, y_temp, k3)
        
        ! 第四步
        y_temp = y + dt * k3
        call derivs(t + dt, y_temp, k4)
        
        ! 组合
        y_next = y + (dt / 6.0d0) * (k1 + 2.0d0 * k2 + 2.0d0 * k3 + k4)
        
    end subroutine rk4_step
    
end module rk4_solver_module