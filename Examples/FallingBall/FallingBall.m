

classdef FallingBall < Dynamics
    methods
        function obj = FallingBall(ball)
            obj.object = ball;
        end

        function XYZLMN = eval_XYZLMN(obj, t, X, u)
            XYZLMN = zeros([6, 1]);
        end
    end
end