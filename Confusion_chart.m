%% Confusion Chart

test = testData;
label_predict = classify(net, test);
label_actual = testData.Labels;

plotconfusion(label_actual, label_predict)