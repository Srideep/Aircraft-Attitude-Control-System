function update_body_rates(omega, moments, inertia, dt)
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