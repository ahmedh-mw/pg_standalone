classdef SimulinkTestTask < src.ModelBasedDesignTask
    properties
        Model
        TestCase
    end

    methods (Static)
        function group = forEachTestCase(models, options)
            arguments
                models = src.findModelsWithTests()
                options.SchedulingMode (1,1) string {mustBeMember(options.SchedulingMode,["WithMatchingTasks","WithMatchingVerificationTasks","WithGroup"])}
                options.Dependencies (1,:) string {mustBeNonmissing}
            end

            import matlab.buildtool.TaskGroup;

            if isfield(options, "Dependencies")
                deps = options.Dependencies;
                options = rmfield(options, "Dependencies");
            else
                deps = string.empty();
            end

            args = namedargs2cell(options);
            
            subgroups = TaskGroup.empty();
            for i = 1:numel(models)
                m = models(i);
                tc = "HLR_"+((i-1)*3+(1:3));

                tasks = arrayfun(@(c)src.SimulinkTestTask(m,c,args{:},Title=c), tc);

                subgroups(end+1) = TaskGroup(tasks, ...
                    TaskNames=tc, ...
                    Title=m); %#ok<AGROW>
            end

            group = TaskGroup(subgroups, ...
                TaskNames=models, ...
                Title="Simulink Test Tasks", ...
                Dependencies=deps);
        end
    end

    methods
        function task = SimulinkTestTask(model, testCase, options)
            arguments
                model
                testCase
                options.Title (1,1) string
                options.SchedulingMode (1,1) string {mustBeMember(options.SchedulingMode,["WithMatchingTasks","WithMatchingVerificationTasks","WithGroup"])}
                options.Dependencies (1,:) string {mustBeNonmissing}
            end

            task.Model = model;
            task.AssociatedModel = model;
            task.TestCase = testCase;
            task.Outputs = fullfile("results", "SimulinkTestTask", ...
                model, strcat(testCase,".txt"));
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