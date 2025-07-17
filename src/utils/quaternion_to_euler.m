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