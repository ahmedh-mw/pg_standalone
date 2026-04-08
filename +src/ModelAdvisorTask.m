classdef ModelAdvisorTask < src.ModelBasedDesignTask
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

            tasks = src.ModelAdvisorTask.empty();
            for i = 1:numel(models)
                m = models(i);
                tasks(end+1) = src.ModelAdvisorTask(m, args{:}, Title=m); %#ok<AGROW>
            end

            group = matlab.buildtool.TaskGroup(tasks, ...
                TaskNames=models, ...
                Title="Model Advisor Tasks", ...
                Dependencies=deps);
        end
    end

    methods
        function task = ModelAdvisorTask(model, options)
            arguments
                model 
                options.Title (1,1) string
                options.SchedulingMode (1,1) string {mustBeMember(options.SchedulingMode,["WithMatchingTasks","WithMatchingVerificationTasks","WithGroup"])}
                options.Dependencies (1,:) string {mustBeNonmissing}
            end

            task.Model = model;
            task.AssociatedModel = model;
            task.Outputs = [fullfile("results", "ModelAdvisorTask", strcat(model,"_a.txt")), ...
                fullfile("results", "ModelAdvisorTask", strcat(model,"_b.txt"))];
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