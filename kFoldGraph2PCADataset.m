function newData = kFoldGraph2PCADataset(dataPath,k)
    load(dataPath);
    maxVSize = max(cell2mat(cellfun(@(x) size(x,2),data.V,'UniformOutput',false)));
    newData.V = data.V;
    %newData.A = data.A;
    for i=1:length(newData.V)
        %newData.A{i} = cellfun(@full,newData.A{i},'UniformOutput',false);
        %newData.A{i} = cat(3,newData.A{i}{:});
        %newData.A{i} = sum(newData.A{i},3);
        if size(newData.V{i},2) < maxVSize
            newData.V{i}(:,maxVSize,:) = 0;
            %newData.A{i}(maxVSize,maxVSize) = 0;
        end
        newData.V{i} = reshape(newData.V{i},[1 numel(newData.V{i})]);
        %newData.A{i} = reshape(newData.A{i},[1 numel(newData.A{i})]);        
    end
    newData.V = cat(1, newData.V{:});
    %newData.A = cat(1, newData.A{:});
    newData.X = newData.V;
    %newData.X = cat(2,newData.V,newData.A);
    %newData = rmfield(newData,'A');
    newData = rmfield(newData,'V');
    newData.labels = data.labels;
    seed = rng();
    rng(100);
    c = cvpartition(data.no_subjects, 'KFold', k); % 5 fold cross validation
    newData.train_indices = cell(k,1);
    newData.val_indices = cell(k,1);
    for kPart=1:k
        all_subjects = 1:data.no_subjects;
        train_subjects=all_subjects(training(c, kPart));
        val_subjects=all_subjects(test(c, kPart));
        for i=1:data.no_samples
            if ismember(data.subjects(i),train_subjects)
                newData.train_indices{kPart} = [newData.train_indices{kPart} i];
            elseif ismember(data.subjects(i),val_subjects)
                newData.val_indices{kPart} = [newData.val_indices{kPart} i];
            end
        end
    end
end