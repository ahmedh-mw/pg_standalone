function plan = buildfile
import matlab.buildtool.*;

plan = buildplan;
plan("qualProcess") = matlab.buildtool.TaskGroup();
plan("qualProcess:check") = Task(Actions=@checkTask);
plan("qualProcess:test") = Task(Actions=@testTask, Dependencies="qualProcess:check");
plan.DefaultTasks = "qualProcess:test";
end

function checkTask(~)
% Identify code issues
issues = codeIssues;
disp(strjoin(["Files list:"; issues.Files],newline));
assert(isempty(issues.Issues),formattedDisplayText( ...
    issues.Issues(:,["Location" "Severity" "Description"])))
end

function testTask(~)
% Run unit tests
results = runtests(IncludeSubfolders=true,OutputDetail="Terse", ...
    BaseFolder=fullfile(fileparts(pwd), "src"));
disp(results.table);
assertSuccess(results);
end