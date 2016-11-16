function drawReducedGraph(dataPath,index)
    load(dataPath);
    %Collapse A graph
    A = data.A{index};
    A = cellfun(@full,A,'UniformOutput',false);
    A = cat(3,A{:});
    A = sum(A,3);
    V = reshape(data.V{index},[size(data.V{index},2) 2]);
    [source,dest] = ind2sub(size(A),find(A > 0));
    hold off;
    hold on;
    figure(1);
    for i=1:length(source)
        plot([V(source(i),1) V(dest(i),1)],[V(source(i),2) V(dest(i),2)],'b');
    end
end