clc;

plane = B747NL();
sys = NonLinDynSys(plane);
sim = OMNiSim(sys);

for t = 18:0.1:19
    tic;
    X0 = [
        0, 0, 0, ...
        1000, 0, 0, ...
        0, 0, 0, ...
        0, 0, 0
    ];
    sim = sim.Simulate(X0, 0, t);
    sim.plotVars(sys, ["u", "w", "q", "theta"], 1);
    sim.plotVars(sys, ["v", "p", "r", "psi"], 2);
    sim.plotVars(sys, ["x", "y", "z"], 3);


    figure(4)
    X = sim.get_var("x");
    Y = sim.get_var("y");
    Z = sim.get_var("z");
    % plot(X, Z)
    plot3(X, Y, Z)
    % axis equal;

    figure(5)
    u = sim.get_var("u");
    v = sim.get_var("v");
    w = sim.get_var("w");
    V = u.^2 + v.^2 + w.^2;
    KE = 0.5 * plane.m * V;

    Z = sim.get_var("z");
    PE = plane.m * 32.2 * Z;

    plot(sim.T, KE+PE, DisplayName="KE + PE");
    hold on;
    plot(sim.T, PE, DisplayName="Potential Energy")
    plot(sim.T, KE, DisplayName="Kinetic Energy")
    xlabel("time, t [s]")
    ylabel("Estimated Energy, E [ft lb]")
    legend()
    hold off

    elapsed_time = toc;
    fprintf('Simulation Duration: %.1f      Elapsed time: %.4f seconds\n', t, elapsed_time)
end