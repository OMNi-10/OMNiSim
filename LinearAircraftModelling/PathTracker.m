

classdef PathTracker < System
    properties
        target LinDynSystem = LinDynSystem.empty()
        var_idxs (1, 9) uint16 = zeros(1, 9)

        uvw_ref  (3, 1) = zeros(3, 1)
        pqr_ref  (3, 1) = zeros(3, 1)
    end

    methods
        function obj = PathTracker(target)
            arguments
                target (1, 1) LinDynSystem
            end
            obj.target = target;
            obj.S_dims = 9;
            obj.S_name = target.S_name + "_path";
            obj.S_lbls = ["x", "y", "z", "vx", "vy", "vz", "phi", "theta", "psi"];
        end

        function obj = setup(obj)
            % Find required variable indexes in X from the target aircraft.
            tar_indx = obj.target.S_indx;
            vars = ["u", "v", "w", "p", "q", "r"];
            for n = 1:length(vars)
                var = vars(n);
                i = find(obj.target.S_lbls == var);
                if isempty(i)
                    warning("PathTracker: unable to find '" + var + "' in target.")
                end
                obj.var_idxs(n) = tar_indx + i - 1;
                
                if (n <= 3)
                    obj.uvw_ref(n) = obj.target.aircraft.X0(i);
                elseif (n <= 6)
                    obj.pqr_ref(n-3) = obj.target.aircraft.X0(i);
                end
            end
        end

        function u = eval_ctrl(obj, ~, ~)
            u = zeros([3, 1]);
        end

        function dxdt = eval_dxdt(obj, ~, X, ~)
            dxdt = zeros(size(X));
            
            % Extract variables from the plane simulation
            uvw = X(obj.var_idxs(1:3)) + obj.uvw_ref;
            pqr = X(obj.var_idxs(4:6)) + obj.pqr_ref;
            
            % Extract previous values from the tracker.
            vel = X(3 + obj.S_indx: 5 + obj.S_indx);
            rot = X(6 + obj.S_indx: 8 + obj.S_indx);

            A_pos = [
                1  0  0
                0  1  0
                0  0  1
            ];

            dxdt = [
                zeros(obj.num_before, 1)
                A_pos * vel;
                PathTracker.FPE(rot) * uvw;
                PathTracker.KE(rot) * pqr;
                zeros(obj.num_after, 1)
            ];
        end
    end

    methods (Static)
        function A = FPE(rot)
            phi = rot(1);
            theta = rot(2);
            psi = rot(3);
            A = [
                cos(psi)*cos(theta), -sin(psi)*cos(phi)+cos(psi)*sin(theta)*sin(phi), sin(psi)*sin(phi)+cos(psi)*sin(theta)*cos(phi)
                sin(psi)*cos(theta),  cos(psi)*cos(phi)+sin(psi)*sin(theta)*sin(phi),-sin(phi)*cos(psi)+sin(psi)*sin(theta)*sin(phi)
                -sin(theta), cos(theta)*sin(phi), cos(theta)*cos(phi)
            ];
        end

        function A = KE(rot)
            phi = rot(1);
            theta = rot(2);
            psi = rot(3);
            A = [
                1, sin(phi)*tan(theta), cos(phi)*tan(theta)
                0, cos(phi), -sin(phi)
                0, sin(phi)*sec(theta), cos(phi)*sec(theta)
            ];
        end
    end
end