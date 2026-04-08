classdef SimulinkDashboardTask < src.ModelBasedDesignTask
    properties
        Model
    end

    methods (Static)
        function group = forEachModel(models, options)
            arguments
                models = src.findUnits()
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

            tasks = src.SimulinkDashboardTask.empty();
            for i = 1:numel(models)
                m = models(i);
                tasks(end+1) = src.SimulinkDashboardTask(m, args{:}, Title=m); %#ok<AGROW>
            end

            group = matlab.buildtool.TaskGroup(tasks, ...
                TaskNames=models, ...
                Title="Simulink Dashboard Tasks", ...
                Dependencies=deps);
        end
    end

    methods
        function task = SimulinkDashboardTask(model, options)
            arguments
                model 
                options.Title (1,1) string
                options.SchedulingMode (1,1) string {mustBeMember(options.SchedulingMode,["WithMatchingTasks","WithMatchingVerificationTasks","WithGroup"])}
                options.Dependencies (1,:) string {mustBeNonmissing}
            end

            task.Model = model;
            task.AssociatedModel = model;
            task.Outputs = fullfile("results", "SimulinkDashboardTask", strcat(model,".txt"));
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