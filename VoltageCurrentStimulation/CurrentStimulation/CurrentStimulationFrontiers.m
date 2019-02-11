%% ADAPTED SCRIPT FOR CURRENT STIMULATION ANALYSIS %%
%%%% Done by Silvia Ronchi, 04.02.2019 %%%%

clear all 
close all 
 
%% Add path and file upload
% Raw recording files are pre-uploaded (not filtered) in MATLAB and saved as .mat files (ChannelTraces_C.mat)
% Three example voltage traces, recorded from three neighboring electrodes.

addpath(genpath('')) % to add the current folder path
load("dacTrace_C.mat") % dacTrace contains a voltage trace storing information about the electrical stimulation protocol 
load("currentlist.mat") % currentlist contains used current stimuation parameters
load("ChannelTraces_C.mat") % ChannelTracesCurr contains three voltage traces with neuronal signals, to be used for assessing cell response to electrical stimulation
 
%% DacTrace cut where the stimulation occurred

[ListCurr, AllignmentVector] = SignalCuttingCurr(dacTrace, currentlist);

% ListCurr contains the stimulation protocol in current mode
% AllignmentVector takes the dacTrace as a reference to cut the readout channels where the stimulation happened

%% Waveforms separation 
   
[BPN, TPNP] = SignalSeparatorCurr(AllignmentVector);

% BPN is biphasic pos-neg
% TPNP is triphasic pos-neg-pos

%% Readout electrodes selection indices

ReadoutElectrodes = [17549,17550,17770];
ReadoutChannels = [909,38,698];

%% Signal analysis - user selection of parameters
    
    % used waveform shapes were: BPN(biphasic pos-neg)and TPNP(triphasic pos-neg-pos)
    % used amplitudes in bits were: 2(42nA),3(63nA),4(84nA),5(105nA),6(126nA),7(147nA),8(168nA),9(198nA)
    % used phases in samples were: 1053(10us),1579(15us),1895(18us),2105(20us),5250(50us)
    % sampling rate is 20 kS/s

WF = BPN; % The user can select here what stimulation waveform to analyze
          % choice between BPN(biphasic pos-neg)and TPNP(triphasic pos-neg-pos)
phase = 2105; % The user can select here what stimulation duration to analyze 
              % choice between 1053(10us),1579(15us),1895(18us),2105(20us),5250(50us)    
cut_time_after_pulse = 7; % the user can adjust parameters to cut the artifact (how many samples to cut after electrical pulse before reading out eventual cell response)



amp = [2,3,4,5,6,7,8,9]; % 2(42nA),3(63nA),4(84nA),5(105nA),6(126nA),7(147nA),8(168nA),9(198nA)

Result = []; % number of times the neuron responed to electrical stimulation for each tested stimulation amplitude 

count_AP = 0; % to count the evoked AP over 30 repetitions
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
    suptitle(['Same 3 readout electrodes over 30 reps, stimulation amplitude = ', num2str(ampl_idx), ' bits'])
    for y = 1:1:length(XtoCut)
        for i_ch = 1:1:3
            signal = [signal ChannelTracesCurr( double(XtoCut(y).Cut+cut_time_after_pulse):double(XtoCut(y).Cut+cut_time_after_pulse+69) , double(i_ch))]; 
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
        if y==1
           legend(['el = ',num2str(17549)],['el = ',num2str(17550)],['el = ',num2str(17770)]) 
        end
    end
    
    Result = [Result; count_AP]; % results over 30 reps
    count_AP = 0;
    i = i+1;
end
    
