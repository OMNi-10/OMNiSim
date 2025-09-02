
function rot = EulerAngle(axes, angles)
    arguments
        axes (1, :)
        angles (1, :)
    end
    % Make sure there are the same amount of angles and axis to rotate
    % about.
    assert(length(axes) == length(angles))

    % Initialize the transformation matrix as the identity.
    rot = eye(3);
    
    % Iterate over each axis/angle pair.
    for i = 1:length(axes)
        axis = axes(i);
        angle = angles(i);
        
        % Create 2D rotation matrix.
        m = [
             cos(angle)  sin(angle)
            -sin(angle)  cos(angle)
        ];
        
        % Add in columns to make 3D rotation.
        m = [m(1:axis-1, :); 0, 0; m(axis:end, :)];
        m = [m(:, 1:axis-1), [0; 0; 0], m(:, axis:end)];
        m(axis, axis) = 1;

        % Apply rotation to output transformation matrix.
        rot = m*rot;
    end

    % Return transformation matrix.
end