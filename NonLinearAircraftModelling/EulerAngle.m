
function rot = EulerAngle(axes, angles)
    arguments
        axes (1, :)
        angles (1, :)
    end
    assert(length(axes) == length(angles))
    rot = eye(3);

    for i = 1:length(axes)
        axis = axes(i);
        angle = angles(i);

        m = [
             cos(angle) sin(angle)
            -sin(angle) cos(angle)
        ];

        m = [m(1:axis-1, :); 0, 0; m(axis:end, :)];
        m = [m(:, 1:axis-1), [0; 0; 0], m(:, axis:end)];
        m(axis, axis) = 1;
        rot = m*rot;
    end
end