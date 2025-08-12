

classdef Ball < PhysObject
    properties
        r
    end

    methods
        function obj = Ball(m, r)
            obj.m = m;
            obj.r = r;
    
            I = (2/5)*m*r^2;
            obj.I = I*eye(3);
        end
    end
end