%% ADAPTED SCRIPT FOR CURRENT STIMULATION ANALYSIS %%
%%%% Done by Silvia Ronchi, 04.02.2019 %%%%

clear all 
close all 

%% Add path and file upload
% The raw files are pre-uloaded and saved at .mat files
% Just three readout channels are saved, due to storage limitations

addpath(genpath('/home/sronchi/ElectricalStimulation/VoltageCurrentStimulation/')) 
load("dacTrace_C.mat") % dacTrace, signal where the information reguarding the stimulation is stored
load("currentlist.mat") % list containing the current stimulation protocol
load("ChannelTraces_C.mat") % .mat file containing three channels for voltage readout and analysis
 
%% DacTrace cut where the stimulation occurred

[ListCurr, AllignmentVector] = SignalCuttingCurr(dacTrace, currentlist);

% ListCurr is the list containing the current stimulation protocol
% AllignmentVector takes the dactrace as a reference to cut the readout channels where the stimulation happened

%% Waveforms separation 
   
[BPN, TPNP] = SignalSeparatorCurr(AllignmentVector);

% BPN is biphasic pos-neg
% TPNP is triphasic pos-neg-pos

%% Readout electrodes selection - manually selected a priori, using the raw file

ReadoutElectrodes = [17549,17550,17770];
ReadoutChannels = [909,38,698];

%% Signal analysis - user selection of parameters
    
    % the waveforms change between BPN(biphasic pos-neg)and TPNP(triphasic pos-neg-pos)
    % the amplitudes change between 2(42nA),3(63nA),4(84nA),5(105nA),6(126nA),7(147nA),8(168nA),9(198nA)
    % the phases change between 1053(10us),1579(15us),1895(18us),2105(20us),5250(50us)

WF = BPN; % choice between BPN (biphasic pos-neg) and TPNP (triphasic pos-neg-pos)
amp = [2,3,4,5,6,7,8,9]; % 2(42nA),3(63nA),4(84nA),5(105nA),6(126nA),7(147nA),8(168nA),9(198nA)
phase = 2105; % choice between 1053(10us),1579(15us),1895(18us),2105(20us),5250(50us)
Result = [];
count_AP = 0; % to count the evoked AP over 30 repetitions
a = 7; % adjust parameters to cut the artifact
i = 1; % index for figure number

for ampl_idx = amp
    signal = [];
    X_noOffset = zeros(150,8);
    XtoCut = [];

    for k = 1:1:length(WF)
        if (WF(k).Ampl==ampl_idx && WF(k).Phase==phase) 
            XtoCut=[XtoCut WF(k)];
        end
    end
    figure(i)
    suptitle(['Same 3 readout electrodes over 30 reps, stimulation amplitude = ', num2str(ampl_idx)])
    for y = 1:1:length(XtoCut)
        for i_ch = 1:1:3
            signal = [signal ChannelTracesCurr( double(XtoCut(y).Cut+a):double(XtoCut(y).Cut+a+69) , double(i_ch))]; 
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
        X_noOffset = zeros(70,8);
        index = [];
    end
    
    Result = [Result; count_AP]; % results over 30 reps
    count_AP = 0;
    i = i+1;
end
    
