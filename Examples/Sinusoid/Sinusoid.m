
classdef Sinusoid < System
    properties
        A (2, 2)

        frequency (1, 1)
        damping (1, 1)
    end

    methods
        function obj = Sinusoid(name, frequency, damping)
            obj.S_name = name;
            obj.frequency = frequency;
            obj.damping = damping;
        end

        function obj = setup(obj)
            obj.S_dims = 2;
            obj.S_lbls = ["x", "v"];
            
            obj.A = [
                0  obj.frequency*2*pi
                -obj.frequency*2*pi 0
            ];
        end

        function u = eval_ctrl(obj, t, X)
            u = [];
        end

        function dxdt = eval_dxdt(obj, t, X, u)
            dxdt = obj.A * X;
        end
    end
end