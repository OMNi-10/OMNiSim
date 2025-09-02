

function tester(paths_to_include, functions_to_call)
    addpath(paths_to_include)
    for i = 1:numel(functions_to_call)
        test_function = functions_to_call{i};
        try
            fprintf("    %s() ... ", getFunctionName(test_function))
            test_function();
            fprintf("success\n")
        catch ME
            fprintf("failure\n")
            disp(ME.message)
            disp("")
        end
    end
    rmpath(paths_to_include)

    function name = getFunctionName(func)
        funcInfo = functions(func);
        name = funcInfo.function;
    end
end