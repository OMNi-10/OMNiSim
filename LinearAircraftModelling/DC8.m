
function plane = DC8()
    % Reference Flight Condition
    xR = [
        468.2, 0, 0, 0, ... % Longitudinal
        0, 0, 0, 0, ...         % Lateral
        0, 0, 0, ...               % x-y-z
        0, 0, 0, ...               % u-v-w
        0, 0, 0, ...               % phi-theta-psi
        0, 0, 0                    % p-q-r
        ]';
    X0_long = [468.2, 0, 0, 0]';
    X0_ltrl = [0, 0, 0, 0]';
    
    % Longitudinal Matrices
    A_long = [
        -7.14e-3    0.0321     0     -32.2
        -0.13290   -0.7560   468.2     0
         3.2688e-5 -0.01016 -1.3281    0
         0          0        1         0
    ];
    
    B_long = [
        0
        -23.7
        3.22294
        0
    ];
    
    G_long = [
        7.07e-3   -0.0321
        0.1329     0.756
        -3.2688e-5 0.01016
        0          0
    ];
    
    
    % Lateral Matrices
    
    IxzOverIxx = 0.0119;
    IxzOverIzz = 0.0063;
    
    y_v = -0.0868;
    y_p = 0;  % Should this actually be 0?
    y_r = 0;  % Should this actually be 0?
    U_e = 251.21616;
    l_v = -0.017634;
    l_p = -1.18;
    l_r = 0.336;
    y_xi = 0.0;
    y_zeta = 5.58698;
    n_v = 0.0086379;
    n_r = -0.23;
    n_p = -0.01294;
    l_xi = -2.11;
    l_zeta = 0.559;
    n_xi = -0.0519;
    n_zeta = -1.168;
    g = -32.2;
    
    
    A_lat = [
        y_v,     y_p/U_e, y_r/U_e - 1, g/U_e;
        U_e*l_v, l_p,     l_r,         0;
        U_e*n_v, n_p,     n_r,         0;
        0,       1,       0,           0;
    ];
    
    B_lat = [
        y_xi/U_e, y_zeta;
        l_xi, l_zeta;
        n_xi, n_zeta;
        0, 0;
    ];
    
    G_lat = [
        y_v
        U_e*l_v
        U_e*n_v
        0
    ];

    plane = Aircraft("DC8", 4, 4, [1, 2], [2, 1]);
    
    plane = plane.set_X0_long(X0_long);
    plane = plane.set_X0_ltrl(X0_ltrl);

    plane = plane.set_A_long(A_long);
    plane = plane.set_A_ltrl(A_lat);
    
    plane = plane.set_B_long(B_long);
    plane = plane.set_B_ltrl(B_lat);

    plane = plane.set_G_long(G_long);
    plane = plane.set_G_ltrl(G_lat);

    plane = plane.set_long_lbls(["u", "w", "q", "theta"]');
    plane = plane.set_ltrl_lbls(["v", "p", "r", "phi"]');
end