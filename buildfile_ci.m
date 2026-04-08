function plan = buildfile_ci
import matlab.buildtool.*;

plan = buildplan();

plan("ci:madv") = src.ModelAdvisorTask.forEachModel();

plan("ci:ded") = src.SimulinkDesignVerifierTask.forEachModel();

plan("ci:codegen") = src.SimulinkCoderTask.forEachModel();

plan("ci:slci") = src.SimulinkCodeInspectorTask.forEachModel();
plan("ci:slci").Dependencies = "ci:codegen";

plan("ci:mil") = src.SimulinkTestTask.forEachTestCase();

plan("ci:mergeTest") = src.MergeSimulinkTestResultsTask.forEachModel();
plan("ci:mergeTest").Dependencies = "ci:mil";

plan("ci:mtMetrics") = src.SimulinkDashboardTask.forEachModel();
plan("ci:mtMetrics").Dependencies = "ci:mil";
end