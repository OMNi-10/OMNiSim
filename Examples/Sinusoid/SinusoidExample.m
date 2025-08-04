clc;

sys = Sinusoid("sin(x)", 1, 0);

sim = OMNiSim(sys);
sim = sim.Simulate([0, 1], 0, 4);
sim.plotVars(sys, ["x", "v"], 1);