function f = getCacheZip(task)
    import matlab.buildtool.internal.fingerprints.computeTaskTrace;
    import matlab.buildtool.cache.internal.computeOutputCacheKey;

    % Compute cache key
    trace = computeTaskTrace(task, {});
    outputFiles = [matlab.buildtool.io.FileCollection.empty(1,0), task.outputList().Value];
    key = computeOutputCacheKey(trace, outputFiles);

    % Use key to find expected zip location
    planRootFolder = pwd();
    cacheRootFolder = matlab.buildtool.internal.cacheRoot(planRootFolder);
    f = fullfile(cacheRootFolder, "outputCache", key + ".zip");
end
% Nice to have a silent logging to previous job's tasks
% ir_dag.json    tracdkey_*.zip

%  A : x  <======  x  :   B  :  x,y  <=========  x,y :  C  : x,y,z


%%%%% 
 % x:  taskA1 :  w
 % x:  taskA2 :  g