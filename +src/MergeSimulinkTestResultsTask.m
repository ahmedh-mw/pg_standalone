classdef MergeSimulinkTestResultsTask < src.ModelBasedDesignTask
    properties
        Model
    end

    methods (Static)
        function group = forEachModel(models, options)
            arguments
                models = src.findModelsWithTests()
                options.SchedulingMode (1,1) string {mustBeMember(options.SchedulingMode,["WithMatchingTasks","WithMatchingVerificationTasks","WithGroup"])}
                options.Dependencies (1,:) string {mustBeNonmissing}
            end

            if isfield(options, "Dependencies")
                deps = options.Dependencies;
                options = rmfield(options, "Dependencies");
            else
                deps = string.empty();
            end

            args = namedargs2cell(options);

            tasks = src.MergeSimulinkTestResultsTask.empty();
            for i = 1:numel(models)
                m = models(i);
                tasks(end+1) = src.MergeSimulinkTestResultsTask(m, args{:}, Title=m); %#ok<AGROW>
            end

            group = matlab.buildtool.TaskGroup(tasks, ...
                TaskNames=models, ...
                Title="Merge Simulink Test Result Tasks", ...
                Dependencies=deps);
        end
    end

    methods
        function task = MergeSimulinkTestResultsTask(model, options)
            arguments
                model 
                options.Title (1,1) string 
                options.SchedulingMode (1,1) string {mustBeMember(options.SchedulingMode,["WithMatchingTasks","WithMatchingVerificationTasks","WithGroup"])}
            end

            task.Model = model;
            task.AssociatedModel = model;
            task.Outputs = fullfile("results", "MergeSimulinkTestResultsTask", strcat(model,".txt"));
            for prop = string(fieldnames(options))'
                task.(prop) = options.(prop);
            end
        end
    end

    methods (TaskAction)
        function run(task, context) %#ok<INUSD>
            src.doFakeWork(task);
        end
    end
end