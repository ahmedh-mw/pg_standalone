% Copyright 2025 The MathWorks, Inc.

function generate_jenkins_pipeline()
    % workspace = string(getenv('WORKSPACE'));      % Reading Jenkins workspace environment variable
    pipelineGenerationPackageRoot = string(getenv('MW_PIPELINE_GENERATION_PACKAGE_ROOT'));
    relativeProjectPath = string(getenv('MW_RELATIVE_PROJECT_PATH'));
    remoteBuildCacheName = string(getenv('MW_REMOTE_BUILD_CACHE_NAME'));
    pipelineGenDirectory = string(getenv('MW_PIPELINE_GEN_DIRECTORY'));

    op = pg.pipeline.Options();
    op.PipelineGenerationPackageRoot = pipelineGenerationPackageRoot;
    op.RelativeProjectPath = relativeProjectPath;
    op.RemoteBuildCacheName = remoteBuildCacheName;
    op.GeneratedPipelineFileName = fullfile(pipelineGenDirectory, "build_pipeline.groovy");
    
    op.ProcessName = "qualProcess";
    op.Architecture = pg.pipeline.Architecture.SerialJobes;
    op.Platform = pg.pipeline.Platform.Jenkins;
    % op.TemplatePath = ".build/generic-job.yml";
    op.RunnerTags = "selfhosted_win_agents";
    op.StopOnStageFailure = true;
    op.ReportPath = "build_results/reports/finalReport";
    op.GenerateJUnitForProcess = false;
    
    op.ArtifactServiceMode = 'azure_blob';         % network/jfrog/s3/azure_blob
    % op.NetworkStoragePath = '<Network storage path>';
    % op.ArtifactoryUrl = '<JFrog Artifactory url>';
    % op.ArtifactoryRepoName = '<JFrog Artifactory repo name>';
    % op.S3BucketName = '<AWS S3 bucket name>';
    % op.S3AwsAccessKeyID = '<AWS S3 access key id>';
    op.AzContainerName = 'padvblobcontainer';
    % op.RunnerType = "container";          % default/container
    % op.ImageTag = '<Docker Image full name>';
    % op.ImageArgs = "<Docker container arguments>";
    
    % Docker image settings
    op.UseMatlabPlugin = false;
    % op.MatlabLaunchCmd = "xvfb-run -a matlab -batch"; 
    % op.MatlabStartupOptions = "";
    % op.AddBatchStartupOption = false;
    pg.pipeline.generatePipeline(op);
end