

classdef AircraftNL < PhysObject
    properties
        wing_span
        chord_length
        planform_area

        A_long (3, 6)
        A_ltrl (3, 5)

        ctrl_dims
    end

    methods
        function obj = AircraftNL(name)
            obj.name = name;
        end
    end
end