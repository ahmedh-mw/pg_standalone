function plan = buildfile
% Create a plan from task functions
plan = buildplan(localfunctions);

% Make the "test" task the default task in the plan
plan.DefaultTasks = "test";
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
results = runtests(IncludeSubfolders=true,OutputDetail="terse");
disp(results.table);
assertSuccess(results);
end