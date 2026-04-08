function doFakeWork(task)

for i=1:numel(task.Outputs)
    filePath = task.Outputs(i).Path;
    folderPath = fileparts(filePath);
    if ~isfolder(folderPath)
        mkdir(folderPath);
    end
    writelines("dummy content", filePath);
end
pause(0.5);
end