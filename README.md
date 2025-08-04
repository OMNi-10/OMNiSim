# OMNiSim
---
OMNiSim is a MATLAB program designed to design and test control systems with a variety of applications and was originally developed as part of Dr. Lagor's lab within the University of Virginia's dept. of Mechanical and Aerospace Engineering. Currently, OMNiSim is being used to design an autopilot for ground effect vehicles as well as an augmented control scheme for an RC underwater vehicle.

**Link to Project:** https://github.com/OMNi-10/OMNiSim

## Usage
---
OMNiSim centers around the class `System` and it's children. In principal, a *System* is anything that can be represented by $\frac{dx}{dt}=f(t, x)$. Though, OMNiSim also adds an additional method of influencing a system with a *control* variable, $u=g(t,x)$. In addition, OMNiSim supports having multiple systems act simultaneously or interact with each other; each subsystem's state vector $x_i$ is joined into an overarching system ($x = [x_1^T x_2^T ... x_i^T]^T$).
$$\begin{aligned}
\dot{x_i}&=f_i(t,x,u)\\
u&=\sum{g_i(t,x)}\\
x&=[x_1^T~x_2^T ~... ~x_i^T]^T
\end{aligned}$$
Each instance of a `System` must define the functions $f_i(t, x, u)$ and $g_i(t,x)$ as the methods `eval_dxdt(t, X, u)` and `eval_ctrl(t, X)`. These methods can be constructed to produce any desired system.

**In short**,
1. Create a `System` child.
2. Define `setup()`.
3. Define `eval_dxdt(t, X, u)`.
4. Define `eval_ctrl(t, X)`.
5. Pass the system to an `OMNiSim` instance.