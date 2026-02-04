program double_pendulum_main
    use constants_module, only: n, dt, t_end, n_steps, y0
    use rk4_solver_module, only: rk4_step
    use output_module, only: write_results
    implicit none
    
    real(8) :: time_array(n_steps), state_array(n_steps, n)
    real(8) :: current_time, current_state(n)
    integer :: i
    
    ! 初始化
    current_time = 0.0d0
    current_state = y0
    time_array(1) = current_time
    state_array(1,:) = current_state
    
    ! 时间推进
    do i = 1, n_steps-1
        ! 单步龙格库塔
        call rk4_step(current_time, current_state, current_state)
        
        ! 更新时间
        current_time = current_time + dt
        
        ! 存储结果
        time_array(i+1) = current_time
        state_array(i+1,:) = current_state
        
        ! 进度显示
        if (mod(i, 1000) == 0) then
            print '(A,F6.1,A,F6.1)', '进度: ', current_time, ' / ', t_end
        end if
    end do
    
    print *, '模拟完成，总步数: ', n_steps
    
    ! 写入结果
    call write_results(time_array, state_array, 'double_pendulum_results.txt')
    
end program double_pendulum_main