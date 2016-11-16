function [labels,files] = getbosphorusexpressions(bosDir)
    subdirs = dir(bosDir);
    %Remove . and .. as subdirs
    subdirs = subdirs(3:end);
    labels = cell(4666,1);
    files = cell(4666,1);
    %subDirIndices = subdirs(:).isdir;
    %subdirs = subdirs(subDirIndices).name;
    count = 1;
    labelNames = {'ANGER','DISGUST','FEAR','HAPPY','SADNESS','SURPRISE'};
    for subdirIndex=1:length(subdirs)
        if subdirs(subdirIndex).isdir == 1
            currentSubdir = [bosDir '/' subdirs(subdirIndex).name];
            fileListing3d = dir([currentSubdir '/*.bnt']);
            for fileIndex=1:length(fileListing3d)
                files{count} = fileListing3d(fileIndex).name;
                for i=1:length(labelNames)
                    if ~isempty(strfind(fileListing3d(fileIndex).name,labelNames{i}))
                        labels{count} = i;
                        break;
                    end
                end
                count = count + 1;
            end
        end
    end
end