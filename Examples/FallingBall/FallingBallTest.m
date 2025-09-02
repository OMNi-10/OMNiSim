clc;

ball = Ball(1, 1);
sys = FallingBall(ball);
sim = OMNiSim(sys);
% X0 = [
%     0, 0, 0, ...
%     0, 0, -16.1, ...
%     0, 0, 0, ...
%     0, 0, 0
% ];

X0 = [
    0, 0, 0, ...
    0, 0, 16.1, ...
    0, 0, 0, ...
    0, 0, 0
    ];

vars = ["x", "y", "z"];
sim = sim.Simulate(X0, 0, 1);
axes = sim.plotVars(sys, vars, 1);

for r = linspace(-1, 5, 7)
    r = 10^r;
    sim = sim.Simulate([0, 0, 0, 0, 0, 16.1, 0, 0, 0, 0, 0, r], 0, 1);
    axes = sim.plotVars(sys, vars, axes);
end
sim.dispLbls

% figure(2)
% u = sim.get_var("u");
% v = sim.get_var("v");
% w = sim.get_var("w");
% V = u.^2 + v.^2 + w.^2;
% KE = 0.5 * plane.m * V;
% 
% Z = sim.get_var("z");
% PE = plane.m * 32.2 * Z;
% 
% plot(sim.T, KE+PE, DisplayName="KE + PE");
% hold on;
% plot(sim.T, PE, DisplayName="Potential Energy")
% plot(sim.T, KE, DisplayName="Kinetic Energy")
% xlabel("time, t [s]")
% ylabel("Estimated Energy, E [ft lb]")
% legend()
% hold off