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

            obj.S_dims = 12;
            obj.S_lbls = [
                "x", "y", "z", ...
                "u", "v", "w", ...
                "phi", "theta", "psi", ...
                "p", "q", "r"
                ];
        end

        function u = eval_ctrl(obj, t, X)
            u = zeros([3, 1]);
        end

        function dXdt = eval_dxdt(obj, t, X, U)
            warning('off', 'backtrace')
            % Gathering Variables
            x = X(obj.S_indx: obj.S_indx + obj.S_dims - 1);
            
            % Unpack variables
            xyz = x(1:3);
            uvw = x(4:6);
            ptp = x(7:9);
            pqr = x(10:12);

            if norm(pqr) > 1
                warning("High angular rates, expect innacurate results.")
            end

            u = uvw(1);
            v = uvw(2);
            w = uvw(3);

            p = pqr(1);
            q = pqr(2);
            r = pqr(3);

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
            XYZLMN = obj.eval_XYZLMN(t, X, U);
            X = XYZLMN(1);
            Y = XYZLMN(2);
            Z = XYZLMN(3);
            L = XYZLMN(4);
            M = XYZLMN(5);
            N = XYZLMN(6);

            % Calculating gravity.
            g = 32.2;
            if obj.warn
                warning("Assuming g =32.2")
            end
            R = EulerAngle([3 2 1], [phi theta psi]);
            G = R * [0; 0; -m*g];

            % FINDING DERIVATIVES
            % Position
            R = EulerAngle([3, 2, 1, 1], [phi, theta, psi, pi]);
            dxyzdt = inv(R) * uvw;

            % Velocity
            dudt = r*v - q*w + (G(1) + X)/m;
            dvdt = p*w - r*u + (G(2) + Y)/m;
            dwdt = q*u - p*v + (G(3) + Z)/m;
            duvwdt = [dudt; dvdt; dwdt];
            
            % Angular velocity
            dpqrdt = inv(obj.object.I)*([L M N]'- cross(pqr, obj.object.I*pqr));

            if obj.warn
                warning("Assuming Ixy, Iyz = 0");
            end

            % Angular position
            drotdt = Dynamics.KE(phi, theta, psi)*pqr;

            % Repacking
            dxdt = [dxyzdt; duvwdt; drotdt; dpqrdt];
            dXdt = [zeros([obj.num_before, 1]); dxdt; zeros([obj.num_after, 1])];

            warning('on', 'backtrace')
        end
    end

    methods(Static)
        function R = R_F_to_B(phi, theta, psi)
            R = [
                cos(psi)*cos(theta), -sin(psi)*cos(phi)+cos(psi)*sin(theta)*sin(phi), sin(psi)*sin(phi)+cos(psi)*sin(theta)*cos(phi)
                sin(psi)*cos(theta),  cos(psi)*cos(phi)+sin(psi)*sin(theta)*sin(phi),-sin(phi)*cos(psi)+sin(psi)*sin(theta)*sin(phi)
                -sin(theta), cos(theta)*sin(phi), cos(theta)*cos(phi)
            ];
            R = R';
        end

        function A = KE(phi, theta, psi)
            A = [
                1, sin(phi)*tan(theta), cos(phi)*tan(theta)
                0, cos(phi), -sin(phi)
                0, sin(phi)*sec(theta), cos(phi)*sec(theta)
            ];
        end
    end
end