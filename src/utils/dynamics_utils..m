% dynamics_utils.m
% Helper functions for custom 6-DOF aircraft dynamics in ACS project.
% Implements quaternion updates, Euler conversions, and basic rotational dynamics.
% Based on rigid-body equations (e.g., from Stevens & Lewis) for attitude control per SADD/SRS.
% Use in MATLAB Function blocks within Simulink models (e.g., custom_dynamics.slx).
% Assumes single-precision (floating-point per SADD) and fixed time step (e.g., dt=0.01s for 100 Hz).

function q_next = quaternion_update(q, omega, dt)
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

function euler = quaternion_to_euler(q)
    % Converts quaternion to Euler angles (roll, pitch, yaw) in radians.
    % Inputs: q (4x1 quaternion [w x y z])
    % Output: euler (3x1 [roll pitch yaw] rad)
    
    w = q(1); x = q(2); y = q(3); z = q(4);
    
    % Roll (phi)
    roll = atan2(2*(w*x + y*z), 1 - 2*(x^2 + y^2));
    
    % Pitch (theta) - with asin clamping to avoid NaN
    sin_theta = 2*(w*y - z*x);
    sin_theta = max(min(sin_theta, 1), -1);  % Clamp to [-1,1]
    pitch = asin(sin_theta);
    
    % Yaw (psi)
    yaw = atan2(2*(w*z + x*y), 1 - 2*(y^2 + z^2));
    
    euler = [roll; pitch; yaw];
end

function omega_next = update_body_rates(omega, moments, inertia, dt)
    % Updates body rates using Euler's rotational equations (simplified, no cross terms for basic impl).
    % Inputs: omega (3x1 [p q r] rad/s), moments (3x1 [L M N] Nm), inertia (3x3 matrix kg*m²), dt (s)
    % Output: omega_next (updated rates)
    % Note: For full fidelity, add omega cross I*omega term (extend as needed per SRS dynamics).
    
    % Simplified: omega_dot = I_inv * moments (assuming small rates or linear approx)
    I_inv = inv(inertia);
    omega_dot = I_inv * moments;
    
    % Full nonlinear: Uncomment for more accuracy
    % omega_dot = I_inv * (moments - cross(omega, inertia * omega));
    
    omega_next = omega + omega_dot * dt;  % Euler integration
end

% Example usage (for standalone testing - comment out for Simulink use)
if ~isdeployed  % Only run if not in a deployed app
    disp('dynamics_utils.m loaded. Example: q_next = quaternion_update([1;0;0;0], [0.1;0.2;0.3], 0.01)');
end