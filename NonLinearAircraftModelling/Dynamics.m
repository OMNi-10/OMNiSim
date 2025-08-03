classdef Dynamics < System
    properties
        object (1, 1) PhysObject
        warn
    end

    methods (Abstract)
        eval_XYZLMN(t, X, U);
    end

    methods (Access=public)
        function obj = setup(obj)
            global warn;
            if exist('warn', 'var')
                obj.warn = warn;
            else
                obj.warn = true;
            end
        end

        function u = eval_ctrl(obj, t, X)
            u = zeros([3, 1]);
        end

        function dXdt = eval_dxdt(obj, t, X, U)
            warning('off', 'backtrace')
            % Gathering Variables
            x = X(obj.S_indx: obj.S_indx + obj.S_dims - 1);
            
            % Unpack variables
            uvw = x(1:3);
            u = uvw(1);
            v = uvw(2);
            w = uvw(3);

            pqr = x(4:6);
            p = pqr(1);
            q = pqr(2);
            r = pqr(3);

            ptp = x(7:9);
            phi = ptp(1);
            theta = ptp(2);
            psi = ptp(3);

            d_e = U(1);
            d_a = U(2);
            d_r = U(3);

            m = obj.object.m;
            Ixx = obj.object.I(1, 1);
            Iyy = obj.object.I(2, 2);
            Izz = obj.object.I(3, 3);
            Ixz = obj.object.I(1, 3);
            
            % Get external forces/moments
            [X, Y, Z, L, M, N] = obj.eval_XYZLMN(t, X, U);

            % Calculating gravity.
            g = 32.2;
            if obj.warn
                warning("Assuming g =32.2")
            end
            G = NonLinSim.R_F_to_B(phi, theta, psi) * [0; 0; m*g];

            % FINDING DERIVATIVES
            % Velocity
            dudt = r*v - q*w + (G(1) + X)/m;
            dvdt = p*w - r*u + (G(2) + Y)/m;
            dwdt = q*u - p*v + (G(3) + Z)/m;
            duvwdt = [dudt; dvdt; dwdt];
            
            % Angular velocity
            A = 1/(Ixx * Izz - Ixz^2);
            B = (Ixx - Iyy + Izz);
            C = Izz - Iyy;
            D = Izz - Ixx;
            E = Ixx - Iyy;
            
            dpdt = A*(Ixx*B*p*q - (Izz*C + Ixz^2)*q*r + Izz*L + Ixz*N);
            dqdt = (1/Iyy)*(D*p*r - Ixz*(p^2 - r^2) + M);
            drdt = A*((Ixx*E + Ixz^2)*p*q - Ixz*B*q*r + Ixz*L + Ixx*N);
            dpqrdt = [dpdt; dqdt; drdt];
            if obj.warn
                warning("Assuming Ixy, Iyz = 0");
            end

            % Angular position
            drotdt = NonLinSim.KE(phi, theta, psi)*pqr;

            % Repacking
            dxdt = [duvwdt; dpqrdt; drotdt];
            dXdt = [zeros([obj.num_before, 1]); dxdt; zeros([obj.num_after, 1])];

            warning('on', 'backtrace')
        end
    end
end