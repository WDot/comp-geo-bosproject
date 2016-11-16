function [labels,files] = getbosphoruslabels(bosDir)
    subdirs = dir(bosDir);
    %Remove . and .. as subdirs
    subdirs = subdirs(3:end);
    labels = cell(4666,1);
    files = cell(4666,1);
    %subDirIndices = subdirs(:).isdir;
    %subdirs = subdirs(subDirIndices).name;
    count = 1;
    for subdirIndex=1:length(subdirs)
        if subdirs(subdirIndex).isdir == 1
            currentSubdir = [bosDir '/' subdirs(subdirIndex).name];
            fileListing3d = dir([currentSubdir '/*.bnt']);
            fileListing = dir([currentSubdir '/*.txt']);
            text = fileread([currentSubdir '/' fileListing(1).name]);
            for fileIndex=1:length(fileListing3d)
                files{count} = fileListing3d(fileIndex).name;
                if isempty(regexp(text,':[\s]+Female'))
                    labels{count} = 'M';
                else
                    labels{count}='F';
                end
                count = count + 1;
            end
        end
    end
end