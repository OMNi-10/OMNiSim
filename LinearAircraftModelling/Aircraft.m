
classdef Aircraft
    properties
        % SYSTEM DIMENSIONS
        % ignored if 0.
        long_dims (1, 1) uint8 = 0       % number of longintudinal state variables
        ltrl_dims (1, 1) uint8 = 0       % number of lateral state variables
        ctrl_dims (1, 2) uint8 = [0, 0]  % number of control variables [long, ltrl]
        gust_dims (1, 2) uint8 = [0, 0]  % number of gust input variables [long, ltrl]

        % SYSTEM VARIABLES
        % dx/dt = Ax + Bu + Gd

        % Reference Flight Condition
        X0      (:, :) double
        X0_long (:, :) double
        X0_ltrl (:, :) double

        % State Matrices
        A      (:, :) double
        A_long (:, :) double
        A_ltrl (:, :) double
        
        % Control Matrices
        B      (:, :) double
        B_long (:, :) double
        B_ltrl (:, :) double
        
        % Gust Matrices
        G      (:, :) double
        G_long (:, :) double
        G_ltrl (:, :) double

        % SYSTEM LABELS
        plane_name (1, 1) string
        long_lbls (:, 1) string
        ltrl_lbls (:, 1) string
        ctrl_lbls (:, 1) string
    end

    methods (Access = public)
        % INSTANTIATOR
        function obj = Aircraft(name, long_dims, ltrl_dims, ctrl_dims, gust_dims)
            arguments
                name (1, 1) string = "un-named"
                long_dims (1, 1) uint8 {mustBePositive} = 1
                ltrl_dims (1, 1) uint8 {mustBePositive} = 1
                ctrl_dims (1, 2) uint8 {mustBePositive} = 1
                gust_dims (1, 2) uint8 {mustBePositive} = 1
            end
            obj.plane_name = name;
            obj.long_dims = long_dims;
            obj.ltrl_dims = ltrl_dims;
            obj.ctrl_dims = ctrl_dims;
            obj.gust_dims = gust_dims;
        end
        
        % SETTERS
        function obj = set_X0_long(obj, X0_long)
            obj.CheckDims(X0_long, obj.long_dims, 1);
            obj.X0_long = X0_long;
            obj.X0 = vertcat(X0_long, obj.X0_ltrl);
        end

        function obj = set_X0_ltrl(obj, X0_ltrl)
            obj.CheckDims(X0_ltrl, obj.ltrl_dims, 1);
            obj.X0_ltrl = X0_ltrl;
            obj.X0 = vertcat(obj.X0_long, X0_ltrl);
        end

        function obj = set_long_lbls(obj, lbls)
            obj.CheckDims(lbls, obj.long_dims, 1)
            obj.long_lbls = lbls;
        end

        function obj = set_ltrl_lbls(obj, lbls)
            obj.CheckDims(lbls, obj.ltrl_dims, 1)
            obj.ltrl_lbls = lbls;
        end

        function obj = set_A_long(obj, A_long)
            obj.CheckDims(A_long, obj.long_dims, obj.long_dims);
            obj.A_long = A_long;
            obj.A = blkdiag(A_long, obj.A_ltrl);
        end

        function obj = set_A_ltrl(obj, A_ltrl)
            obj.CheckDims(A_ltrl, obj.ltrl_dims, obj.ltrl_dims)
            obj.A_ltrl = A_ltrl;
            obj.A = blkdiag(obj.A_long, A_ltrl);
        end

        function obj = set_B_long(obj, B_long)
            obj.CheckDims(B_long, obj.long_dims, obj.ctrl_dims(1))
            obj.B_long = B_long;
            obj.B = blkdiag(B_long, obj.B_ltrl);
        end

        function obj = set_B_ltrl(obj, B_ltrl)
            obj.CheckDims(B_ltrl, obj.ltrl_dims, obj.ctrl_dims(2))
            obj.B_ltrl = B_ltrl;
            obj.B = blkdiag(obj.B_long, B_ltrl);
        end

        function obj = set_G_long(obj, G_long)
            obj.CheckDims(G_long, obj.long_dims, obj.gust_dims(1))
            obj.G_long = G_long;
            obj.G = blkdiag(G_long, obj.G_ltrl);
        end

        function obj = set_G_ltrl(obj, G_ltrl)
            obj.CheckDims(G_ltrl, obj.ltrl_dims, obj.gust_dims(2))
            obj.G_ltrl = G_ltrl;
            obj.G = blkdiag(obj.G_long, G_ltrl);
        end
    end

    methods (Access = protected)
    end

    methods (Static)
        function CheckDims(A, row, col)
            sz = size(A);
            assert (row == sz(1), "Row count not consistent")
            assert (col == sz(2), "Col count not consistent")
        end
    end
end