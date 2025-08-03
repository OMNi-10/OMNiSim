
function aircraft = B747NL()
    aircraft = AircraftNL("Boeing 747 @ MSL, M=0.25");

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
        1.110  5.700  6.700  5.400 -0.810  0.338
        0.102  0.660  0.000  0.000  0.250  0.000
        0.000 -1.260 -3.200 -20.80  0.270 -1.340
    ];

    aircraft.A_ltrl = [
        -0.960  0.000  0.000  0.000  0.175
        -0.221 -0.450  0.101  0.046  0.007
         0.150 -0.121 -0.300  0.006 -0.109
    ];

    aircraft.ctrl_dims = 3;
end