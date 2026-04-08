classdef (Abstract) ModelBasedDesignTask < ...
        matlab.buildtool.Task & ...
        matlab.buildtool.internal.tasks.mixin.DependencyMatching & ...
        matlab.buildtool.internal.tasks.mixin.AffinityScheduling

    properties (Access = protected)
        AssociatedModel (1,1) string
    end

    methods (Hidden)
        function k = dependencyMatchingKey(task)
            k = task.AssociatedModel;
        end

        function k = affinitySchedulingKey(task)
            k = task.AssociatedModel;
        end
    end
end