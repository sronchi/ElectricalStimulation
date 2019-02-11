%% ADAPTED SCRIPT FOR VOLTAGE STIMULATION ANALYSIS %%
%%%% Done by Silvia Ronchi, 04.02.2019 %%%%

clear all 
close all
 
%% Add path and file upload
% Raw recording files are pre-uploaded (not filtered) in MATLAB and saved as .mat files (ChannelTraces_V.mat)
% Three example voltage traces, recorded from three neighboring electrodes.

addpath(genpath(''))  % to add the current folder path
load("dacTrace_V.mat") % dacTrace contains a voltage trace storing information about the electrical stimulation protocol 
load("voltagelist.mat") % voltagelist contains used voltage stimuation parameters
load("ChannelTraces_V.mat") % ChannelTracesVolt contains three voltage traces with neuronal signals, to be used for assessing cell response to electrical stimulation

%% DacTrace cut where the stimulation occurred

[ListVolt, AllignmentVector] = SignalCutting(dacTrace, voltagelist);

% ListVolt contains the stimulation protocol in voltage mode
% AllignmentVector takes the dacTrace as a reference to cut the readout channels where the stimulation happened

%% Waveforms separation 
   
[BPN, BNP, MN, MP] = SignalSeparator(AllignmentVector);

% BPN is biphasic pos-neg
% BNP is biphasic neg-pos
% MN is monophasic neg
% MP is monophasic pos

%% Readout electrodes selection indices

ReadoutElectrodes = [7043,7042,7263]; 
ReadoutChannels = [65,221,217];

%% Signal analysis - user selection of parameters

    % used waveform shapes were: BPN(biphasic pos-neg),BNP(biphasic neg-pos),MN(monophasic neg),MP(monophasic pos)
    % used amplitudes in bits were: 7(20mV),14(40mV),21(60mV),28(80mV),35(100mV),42(120mV)
    % used phases in samples were: 1(50us),2(100us),3(150us),4(200us)
    % sampling rate is 20 kS/s
    
WF = BPN; % The user can select here what stimulation waveform to analyze
          % choice between: BPN(biphasic pos-neg),BNP(biphasic neg-pos),MN(monophasic neg),MP(monophasic pos)
phase = 2; % The user can select here what stimulation duration to analyze 
            %choice between: 1(50us),2(100us),3(150us),4(200us)
cut_time_after_pulse = 5; % the user can adjust parameters to cut the artifact (how many samples to cut after electrical pulse before reading out eventual cell response)



Result = []; % number of times the neuron responed to electrical stimulation for each tested stimulation amplitude 

amp = [7,14,21,28,35,42]; % 7(20mV),14(40mV),21(60mV),28(80mV),35(100mV),42(120mV)

count_AP = 0; % to count the evoked AP over 30 repetitions
i = 1; % index for figure number

for ampl_idx = amp
    signal = [];
    X_noOffset = zeros(70,3);
    XtoCut = [];
    index = [];

    for k = 1:1:720
        if (WF(k).Ampl==ampl_idx && WF(k).Phase==phase) 
            XtoCut=[XtoCut WF(k)];
        end
    end
    figure(i)
    suptitle(['Same 3 readout electrodes over 30 reps, stimulation amplitude = ', num2str(ampl_idx), ' bits'])
    for y = 1:1:30
        for i_ch = 1:1:3
            signal = [signal ChannelTracesVolt( double(XtoCut(y).Cut+cut_time_after_pulse):double(XtoCut(y).Cut+cut_time_after_pulse+69) , double(i_ch))];  
        end
        X_noOffset = signal - repmat( mean(signal(:,:)) , 70,1); 
        stdev = median(std(X_noOffset(20:70,:))); 
        [count] = absoluteminima(X_noOffset,ReadoutChannels,stdev);
        if count >= (length(ReadoutElectrodes)/2)
            count_AP = count_AP + 1;
        else
            count_AP = count_AP;
        end
        t = [1:1:70]*50*1e-3; % time vector in ms (1 sample = 50 us)
        subplot(6,5,y)
        plot(t,X_noOffset*6.3) % result in uV (6.3 to convert from bits to uV)
        axis([0 3.5 -50*6.3 50*6.3])
        title(['Repetition #',num2str(y)])
        xlabel('time [ms]')
        ylabel('Voltage [uV]')
        hold on
        signal = [];
        X_noOffset = zeros(70,3);
        index = [];
        if y==1
           legend(['el = ',num2str(7043)],['el = ',num2str(7042)],['el = ',num2str(7263)]) 
        end
    end
    Result = [Result; count_AP]; % results over 30 reps
    count_AP = 0;
    i = i+1;
end

