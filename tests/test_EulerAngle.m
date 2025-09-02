

paths_to_include = [
    "NonLinearAircraftModelling\"
];

functions_to_call = {
    @test_empty
    @test_non_rotation
    @test_simple_rotation
};

tester(paths_to_include, functions_to_call)

function test_empty()
    assert(all(all(EulerAngle([], []) == eye(3))), "Empty call does not return identity.")
end

function test_non_rotation()
    assert(all(all(EulerAngle([1], [0]) == eye(3))), "Rotation of 0 radians about the x axis does not return identity")
    assert(all(all(EulerAngle([2], [0]) == eye(3))), "Rotation of 0 radians about the y axis does not return identity")
    assert(all(all(EulerAngle([3], [0]) == eye(3))), "Rotation of 0 radians about the z axis does not return identity")
    assert(all(all(EulerAngle([1, 2], [0, 0]) == eye(3))), "Rotation of 0 radians about the x and y axes does not return identity")
    assert(all(all(EulerAngle([3, 2], [0, 0]) == eye(3))), "Rotation of 0 radians about the z and y axes does not return identity")
    assert(all(all(EulerAngle([3, 1], [0, 0]) == eye(3))), "Rotation of 0 radians about the z and x axes does not return identity")
    assert(all(all(EulerAngle([1, 2, 3], [0, 0, 0]) == eye(3))), "Rotation of 0 radians about the x, y, and z axes does not return identity")
    assert(all(all(EulerAngle([3, 2, 1], [0, 0, 0]) == eye(3))), "Rotation of 0 radians about the z, y, and x axes does not return identity")
end

function test_simple_rotation()
    expected = [
      1.0  0.0  0.0
      0.0  0.0  1.0
      0.0 -1.0  0.0
    ];
    actual = EulerAngle([1], [pi/2]);
    assert(matrix_equal(actual, expected))


    expected = [
        0  0  1
        0  1  0
       -1  0  0
    ];
    actual = EulerAngle([2], [pi/2]);
    assert(matrix_equal(actual, expected))


    expected = [
        0  1  0
       -1  0  0
        0  0  1
    ];
    actual = EulerAngle([3], [pi/2]);
    assert(matrix_equal(actual, expected))

    expected = [
        1     0        0
        0  cosd(30) sind(30)
        0 -sind(30) cosd(30)
    ];
    actual = EulerAngle([1], [pi/6]);
    assert(matrix_equal(actual, expected))
end



function equal = matrix_equal(A, B)
    TOL = 1e-5;

    equal = true;
    assert(all(size(A) == size(B)), "Matrices do not have matching dimensions")

    [n_rows, n_cols] = size(A);
    for i = 1:n_rows
        for j = 1:n_cols
            if abs(A(i, j) - B(i, j)) > TOL
                equal = false;
            end
        end
    end
end