
clc;
clear all;
%% Splitting the data
dataDirectory = fullfile("C:\","Users\","ido57\","OneDrive\","Desktop\","פרויקט גמר\","Matlab Codes\","ModClassDataFileslowestsnr");
framedDS = signalDatastore(dataDirectory,'SignalVariableNames',["frame","label"]);
framedDS = shuffle(framedDS);
% frameDSTrans = transform(framdDS,@helperModClassIQAsPages);
percentTrainingSamples = 70;
percentValidationSamples = 20;
percentTestSamples = 10;
splitPercentages = [percentTrainingSamples,percentValidationSamples,percentTestSamples];
[trainDSTrans,validDSTrans,testDSTrans] = helperModClassSplitData(framedDS,splitPercentages);
% Gather the training and validation frames into the memory
trainFramesTall = tall(transform(trainDSTrans, @helperModClassReadFrame));
rxTrainFrames = gather(trainFramesTall);
rxTrainFrames = cat(4, rxTrainFrames{:});
validFramesTall = tall(transform(validDSTrans, @helperModClassReadFrame));
rxValidFrames = gather(validFramesTall);
rxValidFrames = cat(4, rxValidFrames{:});

% Gather the training and validation labels into the memory
trainLabelsTall = tall(transform(trainDSTrans, @helperModClassReadLabel));
rxTrainLabels = gather(trainLabelsTall);
validLabelsTall = tall(transform(validDSTrans, @helperModClassReadLabel));
rxValidLabels = gather(validLabelsTall);

%% Building the net
% layers = [
%     imageInputLayer([2 128 1],"Name","imageinput")
%     convolution2dLayer([1 32],128,"Name","conv_1","Padding","same")
%     reluLayer("Name","relu_1")
%     batchNormalizationLayer("Name","batchnorm_1")
%     maxPooling2dLayer([2 2],"Name","maxpool","Padding","same");
%     convolution2dLayer([2 24],64,"Name","conv_2","Padding","same")
%     reluLayer("Name","relu_2")
%     batchNormalizationLayer("Name","batchnorm_2")
%     maxPooling2dLayer([2 2],"Name","maxpool","Padding","same");
%     fullyConnectedLayer(256,"Name","fc_1")
%     reluLayer("Name","relu_3")
%     batchNormalizationLayer("Name","batchnorm_3")
%     dropoutLayer(0.5,"Name","dropout_3")
%     fullyConnectedLayer(128,"Name","fc_2")
%     reluLayer("Name","relu_4")
%     batchNormalizationLayer("Name","batchnorm_4")
%     dropoutLayer(0.5,"Name","dropout_4")
%     fullyConnectedLayer(8,"Name","fc_3")
%     softmaxLayer("Name","softmax")
%     classificationLayer("Name","classoutput")];

% layers = [
%     imageInputLayer([2 128 1],"Name","imageinput")
%     convolution2dLayer([1 16],128,"Name","conv_1","Padding","same")
%     reluLayer("Name","relu_1")
%     batchNormalizationLayer("Name","batchnorm_1")
%     dropoutLayer(0.5,"Name","dropout_1")
%     convolution2dLayer([1 16],128,"Name","conv_1","Padding","same")
%     reluLayer("Name","relu_1")
%     convolution2dLayer([2 8],64,"Name","conv_2","Padding","same")
%     reluLayer("Name","relu_2")
%     batchNormalizationLayer("Name","batchnorm_2")
%     dropoutLayer(0.5,"Name","dropout_2")
%     convolution2dLayer([2 8],64,"Name","conv_2","Padding","same")
%     reluLayer("Name","relu_2")
%     fullyConnectedLayer(256,"Name","fc_1")
%     reluLayer("Name","relu_3")
%     batchNormalizationLayer("Name","batchnorm_3")
%     dropoutLayer(0.5,"Name","dropout_3")
%     fullyConnectedLayer(128,"Name","fc_2")
%     reluLayer("Name","relu_4")
%     batchNormalizationLayer("Name","batchnorm_4")
%     dropoutLayer(0.5,"Name","dropout_4")
%     fullyConnectedLayer(8,"Name","fc_3")
%     softmaxLayer("Name","softmax")
%     classificationLayer("Name","classoutput")];

 layers = [
    imageInputLayer([2 128 1],"Name","imageinput")
    convolution2dLayer([1 8],256,"Name","conv_1","Padding","same")
    reluLayer("Name","relu_1")
    convolution2dLayer([2 4],128,"Name","conv","Padding","same")
    batchNormalizationLayer("Name","batchnorm_2")
    reluLayer("Name","relu_2")
    fullyConnectedLayer(8,"Name","fc_3")
    softmaxLayer("Name","softmax")
    classificationLayer("Name","classoutput")];


% Wavelet denoising the Train and Validation Frames
sz = size(rxTrainFrames);
for i = 1:sz(4)
  rxTrainFrames(:,:,1,i) = func_denoise_dw2d(rxTrainFrames(:,:,1,i));
end

sz = size(rxValidFrames);
for i = 1:sz(4)
  rxValidFrames(:,:,1,i) = func_denoise_dw2d(rxValidFrames(:,:,1,i));
end

%% Training the net
maxEpochs = 40;
miniBatchSize = 64;
options = helperModClassTrainingOptions(maxEpochs,miniBatchSize,...
  numel(rxTrainLabels),rxValidFrames,rxValidLabels);


trainedNet = trainNetwork(rxTrainFrames,rxTrainLabels,layers,options);

%% Gather the test frames into the memory
testFramesTall = tall(transform(testDSTrans, @helperModClassReadFrame));
rxTestFrames = gather(testFramesTall);
rxTestFrames = cat(4, rxTestFrames{:});

% Gather the test labels into the memory
testLabelsTall = tall(transform(testDSTrans, @helperModClassReadLabel));
rxTestLabels = gather(testLabelsTall);

% Wavelet denoising the Test Frames
sz = size(rxTestFrames);
for i = 1:sz(4)
  rxTestFrames(:,:,1,i) = func_denoise_dw2d(rxTestFrames(:,:,1,i));
end

% Classifying the Test frames
rxTestPred = classify(trainedNet,rxTestFrames);
testAccuracy = mean(rxTestPred == rxTestLabels);
disp("Test accuracy: " + testAccuracy*100 + "%")
figure
cm = confusionchart(rxTestLabels, rxTestPred);
cm.Title = 'Confusion Matrix for Test Data';
cm.RowSummary = 'row-normalized';
cm.Parent.Position = [cm.Parent.Position(1:2) 740 424];

