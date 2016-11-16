function data = matDir2SparseMatCellArray(matDir)
    fileListing = dir([matDir '/*.mat']);
    As = cell(size(fileListing));
    Vs = cell(size(fileListing));
    labels = zeros(size(fileListing));
    labelNames = {'ANGER','DISGUST','FEAR','HAPPY','SADNESS','SURPRISE'};
    subjects = zeros(size(fileListing));
    for fileIndex=1:length(fileListing)
        load([matDir '/' fileListing(fileIndex).name])
        %A = sparse(A);
        As{fileIndex} = A;
        Vs{fileIndex} = reshape(zscore(V),[1 size(V)]);
        keepIndices = find(Vs{fileIndex}(:,:,3) > 0);
        Vs{fileIndex} = Vs{fileIndex}(:,keepIndices,1:2);
        for i=1:8
            As{fileIndex}{i} = As{fileIndex}{i}(keepIndices,keepIndices);
        end
        for i=1:length(labelNames)
            if ~isempty(strfind(fileListing(fileIndex).name,labelNames{i}))
                labels(fileIndex) = i;
                break;
            end
        end
        if ~isempty(regexp(fileListing(fileIndex).name,'[\d]{3}','once'))
            token=regexp(fileListing(fileIndex).name,'[\d]{3}','match');
            subjects(fileIndex) = str2double(token);
        end
        %save([matDir '/' fileListing(fileIndex).name],'V','A','vCount');
    end
    data.A = As;
    data.V = Vs;
    data.labels = labels;
    data.no_classes = length(labelNames);
    data.no_samples = length(fileListing);
    data.subjects = subjects;
    data.no_subjects = numel(unique(subjects));
end