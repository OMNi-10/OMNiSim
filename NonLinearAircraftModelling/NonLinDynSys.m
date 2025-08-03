
classdef NonLinDynSys < Dynamics
    properties
        % object AircraftNL
    end
    methods
        function obj = NonLinDynSys(plane)
            obj.object = plane;
            obj.S_dims = 9;
            obj.S_lbls = ["u", "v", "w", "p", "q", "r", "phi", "theta", "psi"];
        end

        function [X, Y, Z, L, M, N] = eval_XYZLMN(obj, t, X, U)
    
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
    
            % CALCULATING FORCES
            %  -> HOW TO FIND ACCELERATIONS <-
            if obj.warn
                warning("Unable to find accelerations.")
            end
            u_dot = 0;
            v_dot = 0;
            w_dot = 0;
    
            V = norm(uvw);
            V_dot = (u*u_dot + v*v_dot + w*w_dot) / V;
            
            rho = 2.377e-3;
            if obj.warn
                warning("Assuming air density.")
            end
            Q = 0.5 * rho * V^2;
    
            % finding angle of attack and sideslip angle.
            alpha = atan(w/u);
            beta = asin(v/V);
            alpha_dot = (u*w_dot - u_dot*w) / (w^2 - u^2);
            beta_dot = (v_dot/V - (v*V_dot)/(V^2)) / (1 - (v^2)/(V^2));
            
            % constructing coefficient vectors.
            M = 0;
            if obj.warn
                warning("Assuming M=0 (innaccurate)")
            end
            x_long = [1, alpha, alpha_dot, q, M, d_e]';
            x_ltrl = [beta, p, r, d_a, d_r]';
            
            % calculating total coefficients.
            C_long = obj.object.A_long * x_long;
            C_ltrl = obj.object.A_ltrl * x_ltrl;
    
            % calculating forces.
            S = obj.object.planform_area;
            b = obj.object.wing_span;
            c = obj.object.chord_length;
    
            X = -C_long(2) * Q*S;
            Y = C_ltrl(1) * Q*S;
            Z = C_long(1) * Q*S;
    
            L = C_ltrl(2) * Q*S*c;
            M = C_long(3) * Q*S*b;
            N = C_ltrl(3) * Q*S*b;
        end
    end
end