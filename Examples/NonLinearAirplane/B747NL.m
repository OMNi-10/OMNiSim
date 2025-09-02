
function aircraft = B747NL()
    aircraft = AircraftNL("Boeing 747 @ MSL, M=0.5");

    aircraft.m = 636600 / 32.2;
    aircraft.I = [
        18.2e6   0      0.97e6
         0      33.1e6  0
         0.97e6  0     49.7e6
    ];

    aircraft.planform_area = 5500;
    aircraft.wing_span = 195.68;
    aircraft.chord_length = 27.31;

    aircraft.A_long = [
        0.680  4.670  6.530  5.130 -.0875  0.356
        .0393  0.366  0.000  0.000  0.000  0.000
        0.000 -1.146 -3.350 -20.70  0.121 -1.430
    ];

    aircraft.A_ltrl = [
        -0.960  0.000  0.000  0.000  0.175
        -0.221 -0.450  0.101  0.046  0.007
         0.150 -0.121 -0.300  0.006 -0.109
    ];

    aircraft.ctrl_dims = 3;
end