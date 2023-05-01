%% Setup of CNN based classifier 
% Fist option direct input to 2D CNN
close all

rootFolder = fullfile('C:\Users\tripats\Documents\Biomedical Signal Analysis\Grad Single Project\ECG');

categories = {'SinusTachycardia',...
    'SinusRhythm','SinusBradycardia',...
     'AtrialFibrilation',};
% categories = {'SupraventricularTachycardia','SinusTachycardia',...
%     'SinusRhythm','SinusIrregularity','SinusBradycardia',...
%     'SinusAtriumtoAtrialWanderingRhythm', 'AtrioventricularReentrantTachycardia',...
%     'AtrioventricularNodeReentrantTachycardia','AtrialTachycardia',...
%      'AtrialFlutter','AtrialFibrilation',};


imds = imageDatastore(fullfile(rootFolder,categories),'LabelSource','foldernames');
imds.ReadFcn = @dsresize;

label_count = countEachLabel(imds)
minCount = min(label_count{:,2})

imds = splitEachLabel(imds, minCount, "randomized")

net = alexnet();

[trainingData,testData] = splitEachLabel(imds, 0.2, 'randomized');

layersTransfer = net.Layers(2:end-3);
layers = [
    imageInputLayer([256 256 3]);
    layersTransfer
    fullyConnectedLayer(numel(categories))
    softmaxLayer
    classificationLayer];

plot(layerGraph(layers));

options = trainingOptions("sgdm",...
    "ExecutionEnvironment","parallel",...
    "InitialLearnRate",1e-3,...
    "MaxEpochs", 40,...
    "Shuffle","every-epoch",...
    "Plots","training-progress",...
    "ValidationData",testData,...
    "ValidationFrequency",5);

[net, traininfo] = trainNetwork(trainingData, layers, options);

function data = dsresize(filename)
    data = imread(filename);
    data = data(:,:,min(1:3, end));
    data = imresize(data, [256 256]);
end