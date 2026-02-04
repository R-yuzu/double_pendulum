module energy_module
    use constants_module, only: n, g, l, m
    implicit none
    private
    public :: compute_energy
    
contains
    
    ! 计算系统能量
    subroutine compute_energy(y, kinetic, potential, total)
        real(8), intent(in) :: y(n)
        real(8), intent(out) :: kinetic, potential, total
        
        real(8) :: theta, phi, theta_dot, phi_dot
        real(8) :: diff, cos_diff
        
        ! 提取变量
        theta = y(1)
        phi = y(2)
        theta_dot = y(3)
        phi_dot = y(4)
        
        diff = theta - phi
        cos_diff = cos(diff)
        
        ! 动能
        kinetic = 0.5d0 * m * l**2 * &
                  (2.0d0 * theta_dot**2 + phi_dot**2 + &
                   2.0d0 * theta_dot * phi_dot * cos_diff)
        
        ! 势能
        potential = -m * g * l * (2.0d0 * cos(theta) + cos(phi))
        
        ! 总能量
        total = kinetic + potential
        
    end subroutine compute_energy
    
end module energy_module