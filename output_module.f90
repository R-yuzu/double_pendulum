module output_module
    use constants_module, only: n, dt, t_end, n_steps
    use energy_module, only: compute_energy
    implicit none
    private
    public :: write_results
    
contains
    
    ! 写入结果文件
    subroutine write_results(time_array, state_array, filename)
        real(8), intent(in) :: time_array(n_steps)
        real(8), intent(in) :: state_array(n_steps, n)
        character(len=*), intent(in) :: filename
        
        integer :: i, unit
        real(8) :: kinetic, potential, total
        
        open(newunit=unit, file=filename, status='replace')
        
        ! 写入表头
        write(unit, '(A)') 'Time(s)    Theta(rad)    Phi(rad)    '// &
                           'Theta_dot(rad/s)    Phi_dot(rad/s)    '// &
                           'Kinetic(J)    Potential(J)    Total(J)'
        
        ! 写入数据
        do i = 1, n_steps
            ! 计算能量
            call compute_energy(state_array(i,:), kinetic, potential, total)
            
            ! 写入一行数据
            write(unit, '(8ES16.8)') &
                time_array(i), &
                state_array(i,1), &   ! theta
                state_array(i,2), &   ! phi
                state_array(i,3), &   ! theta_dot
                state_array(i,4), &   ! phi_dot
                kinetic, &
                potential, &
                total
        end do
        
        close(unit)
        
        print *, '结果已保存到文件: ', trim(filename)
        
    end subroutine write_results
    
end module output_module