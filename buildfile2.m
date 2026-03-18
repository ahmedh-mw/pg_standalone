function plan = buildfile2
    import matlab.buildtool.*;

    plan = buildplan;
    plan("anotherProcess") = matlab.buildtool.TaskGroup();
    plan("qualProcess") = matlab.buildtool.TaskGroup();
    plan("qualProcess:start") = Task(Actions=@checkTask);
    plan("qualProcess:start").Inputs = "buildfile2.m";

    plan("qualProcess:check2a") = Task(Actions=@checkTask, Dependencies="qualProcess:start");
    plan("qualProcess:check2a").Inputs = "buildfile2.m";
    plan("qualProcess:check2b") = Task(Actions=@checkTask, Dependencies="qualProcess:start");
    plan("qualProcess:check2b").Inputs = "buildfile2.m";
    plan("qualProcess:check2c") = Task(Actions=@checkTask, Dependencies="qualProcess:start");
    plan("qualProcess:check2c").Inputs = "buildfile2.m";

    plan("qualProcess:test3a") = Task(Actions=@testTask, Dependencies="qualProcess:check2a");
    plan("qualProcess:test3a").Inputs = "buildfile2.m";
    plan("qualProcess:test3b") = Task(Actions=@testTask, Dependencies="qualProcess:check2a");
    plan("qualProcess:test3b").Inputs = "buildfile2.m";

    plan("qualProcess:test4a") = Task(Actions=@testTask, Dependencies=["qualProcess:check2a", "qualProcess:test3b"]);
    plan("qualProcess:test4a").Inputs = "buildfile2.m";

    plan("qualProcess:end") = Task(Actions=@testTask, ...
        Dependencies=["qualProcess:check2b", "qualProcess:check2c", ...
        "qualProcess:test4a", "qualProcess:test3a"]);
    plan("qualProcess:end").Inputs = "buildfile2.m";

    plan.DefaultTasks = "qualProcess:check1";
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