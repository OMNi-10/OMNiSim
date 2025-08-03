
classdef System < handle & matlab.mixin.Heterogeneous
    properties
        % SYSTEM INFORMATION
        X_dims (1, 1) uint16 = 0 % number of entries in the super-system vector.
        S_dims (1, 1) uint16 = 0 % number of entires in the system vector.
        S_indx (1, 1) uint16 = 1  % index of the first entry of the system in the super-system matrix.
        
        % EXAMPLE:
        % Super System Vector: [1, 2, 3, 4, 5, 6]
        % System Vector:             [3, 4]
        % X_dims = 6  | 6 total entries
        % S_dims = 2  | 2 system entries
        % S_indx = 3  | first entry at index 3

        S_name (1, 1) string  % system name, used in labeling.
        S_lbls (1, :) string  % labels of system state variables.
        delimiter (1, 1) string = "."
    end

    methods (Abstract)
        setup();  % Must initialize S_dims, S_indx, and S_lbls.
        eval_ctrl(t, X);  % Returns a control vector, u.
        eval_dxdt(t, X, u);
    end

    methods (Access = public)
        function i = searchSystem(obj, var)
            i = find(obj.S_lbls==var);
            if (isempty(i))
                warning("Label '" + var + "' not found.")
            elseif (length(i) > 1)
                warning("Label '" + var + "' found multiple times.")
            end
        end
    end

    methods (Access = protected)
        function i = idx_start(obj)
            i = obj.S_indx;
        end

        function i = idx_end(obj)
            i = obj.S_indx + obj.S_dims - 1;
        end

        function n = num_before(obj)
            n = obj.S_indx - 1;
        end

        function n = num_after(obj)
            n = obj.X_dims - (obj.num_before() + obj.S_dims);
        end
    end
end