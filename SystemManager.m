

classdef SystemManager < System
    properties
        subSystems (1, :) System = System.empty()
        subSysIdxs (1, :) uint16

        ctrl_dims  (1, 1) uint16 = 0
    end

    methods
        function obj = SystemManager(name, subSystems, ctrl_dims)
            arguments
                name (1, 1) string
                subSystems (1, :) System
                ctrl_dims (1, 1) uint16
            end
            obj.S_name = name;
            obj.subSystems = subSystems;
            obj.ctrl_dims = ctrl_dims;
        end

        function obj = setup(obj)
            obj.subSysIdxs = zeros([1, length(obj.subSystems)]);

            idx = 1;
            for i = 1:length(obj.subSystems)
                % Setup each subsystem
                sub_sys = obj.subSystems(i);
                obj.subSystems(i) = sub_sys.setup();
                
                % Record each subsystem index
                obj.subSysIdxs(i) = idx;
                idx = idx + obj.subSystems(i).S_dims;
            end

            obj.S_dims = idx - 1;
            obj.X_dims = max(obj.X_dims, obj.S_dims);
            obj.S_lbls = zeros(obj.S_dims, 1);

            for i = 1:length(obj.subSystems)
                % Set each subsystem index and X_dims
                obj.subSystems(i).X_dims = obj.S_dims;
                obj.subSystems(i).S_indx = obj.subSysIdxs(i);

                for j = 1:obj.subSystems(i).S_dims
                    sub_sys = obj.subSystems(i);
                    obj.S_lbls(sub_sys.S_indx-1 + j) = ...
                        sub_sys.S_name + sub_sys.delimiter + sub_sys.S_lbls(j);
                end
            end
        end

        function u = eval_ctrl(obj, t, X)
            % Gather controls from all subsystems.
            u = zeros(obj.ctrl_dims, 1);
            for sub_sys = obj.subSystems
                u = u + sub_sys.eval_ctrl(t, X);
            end
        end

        function dxdt = eval_dxdt(obj, t, X, u)
            % Gather state changes from all subsystems.
            dxdt = zeros(obj.X_dims, 1); 
            for sub_sys = obj.subSystems
                dxdt = dxdt + sub_sys.eval_dxdt(t, X, u);
            end
        end
        
        function str = find_system_path(obj, target)

        end
    end
end

