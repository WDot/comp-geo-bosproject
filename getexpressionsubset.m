expressionIndices = find(cellfun(@(x) ~isempty(x),labels));
Aout = cell(size(expressionIndices));
Vout = cell(size(expressionIndices));
labelsOut = cell(size(expressionIndices));
for i=1:length(expressionIndices)
    %Aout{i} = data.A{expressionIndices(i)};
    %VSize = size(data.V{expressionIndices(i)});
    %Vout{i} = data.V{expressionIndices(i)};
    labelsOut{i} = labels{expressionIndices(i)};
end