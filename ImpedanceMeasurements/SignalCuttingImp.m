%% Script for cutting the file with the dacTrace as a reference %%

function [CutVector,midvalue] = SignalCuttingImp(dacTrace)

if (dacTrace(1.5e5,1)<550 && dacTrace(1.5e5,1)> 450)
    midvalue = dacTrace(1.5e5,1)
else 
    midvalue = dacTrace(70005,1)
end
[row_a,col_a] = find(dacTrace(:, 1) ~= midvalue); % all the samples
CutVector = [];

for i = 1:length(row_a)-1
    if row_a(i+1) > row_a(i)+1
        CutVector = [CutVector row_a(i)];
    else
        CutVector = CutVector; % signal with the first sample of every applied waveform
    end
end
CutVector = [CutVector row_a(length(row_a))];
Cutvector = [CutVector]'; 