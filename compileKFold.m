function model = compileKFold(k)
BASENAMESTART = 'C:\\Users\\Miguel Dominguez\\Dropbox\\RIT\\PHD\\expression\\6\\INPUT-GConv16-BatchNorm-ReLU-GConv16-BatchNorm-ReLU-GConv16-BatchNorm-ReLU-GraphEmbed(GConv32)-FC6-SoftmaxWithLossLayer';
BASENAMEEND = '_iter_250.mat';
BASENAMEK = '_KFold';
models = cell(1,k);
for i=1:k
    if i == 1
        PATHNAME = [BASENAMESTART BASENAMEEND];
    else
        PATHNAME = [BASENAMESTART BASENAMEK num2str(i) BASENAMEEND];
    end
    models{i} = load(PATHNAME);
    fprintf('%s\n',PATHNAME)
end
loss_history = mean(vertcat(cell2mat(cellfun(@(x)x.loss_history,models,'UniformOutput',false))),2);
train_acc_history = mean(vertcat(cell2mat(cellfun(@(x)x.train_acc_history,models,'UniformOutput',false))),2);
val_acc_history = mean(vertcat(cell2mat(cellfun(@(x)x.val_acc_history,models,'UniformOutput',false))),2);
meanFinalAcc = val_acc_history(end);
model.loss_history = loss_history;
model.train_acc_history = train_acc_history;
model.val_acc_history = val_acc_history;
model.mean_FinalAcc = meanFinalAcc;

