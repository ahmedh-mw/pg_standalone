%% TaskGraph Example
% This script demonstrates how to use matlab.buildtool.TaskGraph to
% inspect task dependencies, topologically sort tasks, extract subgraphs,
% and plot task graphs.

%% Load a plan
plan = matlab.buildtool.Plan.load("buildfile.m");

%% Create a task graph from all tasks in the plan
graphAll = matlab.buildtool.TaskGraph.fromPlan(plan);

%% Create a task graph rooted at a specific task
% fromPlan accepts a task name (string or string vector). It includes the
% named task and all tasks it depends on.
processName = "ci";
graph = matlab.buildtool.TaskGraph.fromPlan(plan, processName);

%% List task names
disp("Tasks in graph:")
disp([graph.Tasks.Name])

%% Topological sort
% Returns a new graph with tasks ordered so every task appears after its
% dependencies. The original graph is unchanged.
sorted = graph.topologicalSort();

disp("Tasks in topological (execution) order:")
disp([sorted.Tasks.Name])

%% Query dependencies and dependents
% dependencies returns the direct upstream tasks of a given task.
% dependents returns the direct downstream tasks.
targetTask = "ci:slci:InnerLoop_Control";
deps = graph.dependencies(targetTask);
disp("Direct dependencies of """ + targetTask + """:")
disp(deps)

dpts = graph.dependents(targetTask);
disp("Direct dependents of """ + targetTask + """:")
disp(dpts)

%% Transitive dependencies
% Use IncludeTransitive to walk the full dependency chain.
allDeps = graph.dependencies(targetTask, IncludeTransitive=true);
disp("All transitive dependencies of """ + targetTask + """:")
disp(allDeps)

%% Extract a subgraph
% subgraph keeps only the listed tasks (and their mutual relationships).
sub = graph.subgraph("ci:slci");

% Use IncludeDependencies to also pull in everything those tasks depend on.
subWithDeps = graph.subgraph("ci:mergeTest", IncludeDependencies=true);

%% Plot the task graph
% plot(graph) shows top-level tasks only by default.
figure
plot(graph)
title("Task Graph (top-level tasks)")

% ShowAllTasks=true expands groups to show every subtask.
figure
plot(graph, ShowAllTasks=true)
title("Task Graph (all tasks)")