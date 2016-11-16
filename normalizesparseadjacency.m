for i=1:length(data.train_data.A)
    temp = data.train_data.A{i};
    nonzeros = temp(temp > 0);
    meanNonzero = mean(nonzeros(:));
    stdNonzero = std(nonzeros(:));
    temp(temp > 0) = (temp(temp > 0) - meanNonzero) / stdNonzero;
    data.train_data.A{i} = temp;
end