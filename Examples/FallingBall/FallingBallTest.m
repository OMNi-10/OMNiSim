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

sim = sim.Simulate([0, 0, 0, 0, 0, -16.1, 0, 0, 0, 0, 0, 0], 0, 1);
axes = sim.plotVars(sys, "z", 1);

for r = linspace(-1, 1, 7)
    r = 10^r;
    sim = sim.Simulate([0, 0, 0, 0, 0, -16.1, 0, 0, 0, 0, 0, r], 0, 1);
    axes = sim.plotVars(sys, "z", axes);
end
sim.dispLbls
