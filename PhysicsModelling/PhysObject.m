
classdef PhysObject < handle & matlab.mixin.Heterogeneous
    properties
        name (1, 1) string
        m    (1, 1)
        I    (3, 3)
    end
end