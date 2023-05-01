function preprocessData(filename_id, rhythm, filename)
% add preprocessing steps
    % Baseline wanderer removal
    % Noise removal
    % Make every 12 lead data as clean as possible
    % create a datastore based on the rhythm label on data
    fs = 500;
    table = readtable(filename_id);
    [b,a] = butter(5, 45/fs); %for filtering of the power line noises frequncy at 60 Hz
    [d,c] = butter(5, 10/fs, 'high');  %for filtering of baseline wander 
    processed_data = zeros(size(table));
    % doing of butterworth filtering from both side to remove the phase
    % shift problem 
    for i = 1:12
        data = table2array(table(:,i));
        data_1 = filter(b, a, data);
        data_2 = filter(b, a, flip(data_1,1));
        data_2 = flip(data_2,1);
        data_3 = filter(d, c, data_2);
        data_4 = filter(d, c, flip(data_3,1));
        data_4 = flip(data_4,1);
        mask = smooth(smooth(data_4,300),10);
        data_4 = data_4 - mask;
        processed_data(:,i) = data_4;
    end
    
    rhythm = cell2mat(rhythm);
    if rhythm == "SB"
        filepath = "C:\Users\tripats\Documents\Biomedical Signal Analysis\Grad Single Project\ECG\SinusBradycardia";
    elseif rhythm == "SR"
        filepath = "C:\Users\tripats\Documents\Biomedical Signal Analysis\Grad Single Project\ECG\SinusRhythm";
    elseif rhythm == "AFIB"
        filepath = "C:\Users\tripats\Documents\Biomedical Signal Analysis\Grad Single Project\ECG\AtrialFibrilation";
    elseif rhythm == "ST"
        filepath = "C:\Users\tripats\Documents\Biomedical Signal Analysis\Grad Single Project\ECG\SinusTachycardia";
    elseif rhythm == "AF"
        filepath = "C:\Users\tripats\Documents\Biomedical Signal Analysis\Grad Single Project\ECG\AtrialFlutter";
    elseif rhythm == "SA"
        filepath = "C:\Users\tripats\Documents\Biomedical Signal Analysis\Grad Single Project\ECG\SinusIrregularity";
    elseif rhythm == "SVT"
        filepath = "C:\Users\tripats\Documents\Biomedical Signal Analysis\Grad Single Project\ECG\SupraventricularTachycardia";
    elseif rhythm == "AT"
        filepath = "C:\Users\tripats\Documents\Biomedical Signal Analysis\Grad Single Project\ECG\AtrialTachycardia";   
    elseif rhythm == "AVNRT"
        filepath = "C:\Users\tripats\Documents\Biomedical Signal Analysis\Grad Single Project\ECG\AtrioventricularNodeReentrantTachycardia";
    elseif rhythm == "AVRT"
        filepath = "C:\Users\tripats\Documents\Biomedical Signal Analysis\Grad Single Project\ECG\AtrioventricularReentrantTachycardia";
    elseif rhythm == "SAAWR"
        filepath = "C:\Users\tripats\Documents\Biomedical Signal Analysis\Grad Single Project\ECG\SinusAtriumtoAtrialWanderingRhythm";
    end

    EKG = processed_data;
    Leadc = {'I','II','III','aV_R','aV_L','aV_F','V_1','V_2','V_3','V_4','V_5','V_6'};
    figu = figure('Visible','off');
    e = 1;
    for f = 1:4
        for g = 1:4:9
            sbpt = (f-1)+g;
            subplot(3,4,sbpt)
            plot(EKG(1:1500,e))
            title(Leadc{e})
            grid
            e = e+1;
        end
    end
    
    figu.Position = [0 0 512 512];
    saveas(figu, fullfile(strcat(filepath,'\',filename,'.png')))
end
