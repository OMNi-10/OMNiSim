clc;

addpath("tests\")
testFolderPath = "tests\";
filePattern = fullfile(testFolderPath, '*.m');
files = dir(filePattern);

for i = 1:length(files)
    test_file = files(i);

    if test_file.name == "tester.m"
        continue
    end

    disp("running: " + test_file.name + "...")
    run(test_file.name)
    disp("completed: " + test_file.name + ".")
end

rmpath("tests\")