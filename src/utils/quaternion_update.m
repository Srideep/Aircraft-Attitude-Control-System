function quaternion_update(q, omega, dt)
    % Updates quaternion using body rates (simple Euler integration).
    % Inputs: q (4x1 quaternion [w x y z]), omega (3x1 body rates [p q r] rad/s), dt (time step s)
    % Output: q_next (updated quaternion, normalized)
    
    % Skew-symmetric matrix for quaternion derivative
    Omega = [0,         -omega(1), -omega(2), -omega(3);
             omega(1),  0,         -omega(3),  omega(2);
             omega(2),  omega(3),  0,          -omega(1);
             omega(3), -omega(2),   omega(1),  0];
    
    q_dot = 0.5 * Omega * q;  % Quaternion kinematics
    q_next = q + q_dot * dt;  % Euler integration (basic; use ode4 in Simulink for accuracy)
    q_next = q_next / norm(q_next);  % Normalize to unit quaternion
end