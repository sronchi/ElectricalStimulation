%% ADAPTED SCRIPT FOR VOLTAGE STIMULATION ANALYSIS %%
%%%% Done by Silvia Ronchi, 04.02.2019 %%%%

clear all 
close all
 
%% Add path and file upload
% The raw files are pre-uloaded and saved at .mat files
% Just three readout channels are saved, due to storage limitations

addpath(genpath('/home/sronchi/ElectricalStimulation/VoltageCurrentStimulation/')) 
load("dacTrace_V.mat") % dacTrace, signal where the information reguarding the stimulation is stored
load("voltagelist.mat") % list containing the voltage stimulation protocol
load("ChannelTraces_V.mat") % .mat file containing three channels for voltage readout and analysis

%% DacTrace cut where the stimulation occurred

[ListVolt, AllignmentVector] = SignalCutting(dacTrace, voltagelist);

% ListVolt is the list containing the voltage stimulation protocol
% AllignmentVector takes the dactrace as a reference to cut the readout channels where the stimulation happened

%% Waveforms separation 
   
[BPN, BNP, MN, MP] = SignalSeparator(AllignmentVector);

% BPN is biphasic pos-neg
% BNP is biphasic neg-pos
% MN is monophasic neg
% MP is monophasic pos

%% Readout electrodes selection - manually selected a priori, using the raw file

ReadoutElectrodes = [7043,7042,7263]; 
ReadoutChannels = [65,221,217];

%% Signal analysis - user selection of parameters

    % the waveforms change between BPN(biphasic pos-neg),BNP(biphasic neg-pos),MN(monophasic neg),MP(monophasic pos)
    % the amplitudes change between 7(20mV),14(40mV),21(60mV),28(80mV),35(100mV),42(120mV)
    % the phases change between 1(50us),2(100us),3(150us),4(200us)
    
WF = BPN; % choice between BPN(biphasic pos-neg),BNP(biphasic neg-pos),MN(monophasic neg),MP(monophasic pos)
amp = [7,14,21,28,35,42]; % 7(20mV),14(40mV),21(60mV),28(80mV),35(100mV),42(120mV)
phase = 2; % choice between 1(50us),2(100us),3(150us),4(200us)
Result = [];
count_AP = 0; % to count the evoked AP over 30 repetitions
a = 5; % adjust parameters to cut the artifact
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
    suptitle(['Same 3 readout electrodes over 30 reps, stimulation amplitude = ', num2str(ampl_idx)])
    for y = 1:1:30
        for i_ch = 1:1:3
            signal = [signal ChannelTracesVolt( double(XtoCut(y).Cut+a):double(XtoCut(y).Cut+a+69) , double(i_ch))];  
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
    end
    Result = [Result; count_AP]; % results over 30 reps
    count_AP = 0;
    i = i+1;
end

