classdef SimulinkCoderTask < src.ModelBasedDesignTask
    properties
        Model
    end

    methods (Static)
        function group = forEachModel(models, options)
            arguments
                models = src.findModels()
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

            tasks = src.SimulinkCoderTask.empty();
            for i = 1:numel(models)
                m = models(i);
                tasks(end+1) = src.SimulinkCoderTask(m, args{:}, Title=m); %#ok<AGROW>
            end

            group = matlab.buildtool.TaskGroup(tasks, ...
                TaskNames=models, ...
                Title="Simulink Coder Tasks", ...
                Dependencies=deps);
        end
    end

    methods
        function task = SimulinkCoderTask(model, options)
            arguments
                model 
                options.Title (1,1) string 
                options.SchedulingMode (1,1) string {mustBeMember(options.SchedulingMode,["WithMatchingTasks","WithMatchingVerificationTasks","WithGroup"])}
                options.Dependencies (1,:) string {mustBeNonmissing}
            end

            task.Model = model;
            task.AssociatedModel = model;
            task.Outputs = fullfile("results", "SimulinkCoderTask", strcat(model,".txt"));
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