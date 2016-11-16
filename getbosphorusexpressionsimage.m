function data = getbosphorusexpressionsimage(bosDir)
    subdirs = dir(bosDir);
    %Remove . and .. as subdirs
    subdirs = subdirs(3:end);
    labels = cell(4666,1);
    files = cell(4666,1);
    Xs = cell(4666,1);
    subjects = ones(4666,1)* -1;
    %subDirIndices = subdirs(:).isdir;
    %subdirs = subdirs(subDirIndices).name;
    count = 1;
    labelNames = {'ANGER','DISGUST','FEAR','HAPPY','SADNESS','SURPRISE'};
    for subdirIndex=1:length(subdirs)
        if subdirs(subdirIndex).isdir == 1
            currentSubdir = [bosDir '/' subdirs(subdirIndex).name];
            fileListing3d = dir([currentSubdir '/*.png']);
            for fileIndex=1:length(fileListing3d)
                for i=1:length(labelNames)
                    if ~isempty(strfind(fileListing3d(fileIndex).name,labelNames{i}))
                        labels{count} = i;
                        files{count} = fileListing3d(fileIndex).name;
                        Xs{count} = imread([currentSubdir '/' fileListing3d(fileIndex).name]);
                        Xs{count} = imresize(Xs{count},[160 160]);
                        if ~isempty(regexp(fileListing3d(fileIndex).name,'[\d]{3}','once'))
                            token=regexp(fileListing3d(fileIndex).name,'[\d]{3}','match');
                            subjects(count) = str2double(token);
                        end
                        break;
                    end
                end
                count = count + 1;
            end
        end
    end
    data.X = Xs(~cellfun('isempty',Xs));
    data.X = cat(4,data.X{:});
    data.labels = cell2mat(labels(~cellfun('isempty',labels)));
    data.files = files(~cellfun('isempty',files));
    data.no_classes = length(labelNames);
    data.no_samples = length(data.X);
    data.subjects = subjects(subjects > -1);
    data.no_subjects = numel(unique(data.subjects));
end