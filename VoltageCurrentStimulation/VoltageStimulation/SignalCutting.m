%% Script for cutting the file with the dacTrace as a reference %%

function [ListVolt, AllignmentVector] = SignalCutting(dacTrace, voltagelist)

[row_a,col_a] = find(dacTrace(:, 1) ~= 512);
CutVector = [];

for i = 1:length(row_a)-1
    if row_a(i+1) > row_a(i)+1
        CutVector = [CutVector row_a(i)];
    else
        CutVector = CutVector; % signal with the first sample of every applied waveform
    end
end
Cutvector = [CutVector row_a(9000)]'; 
ListVolt = repmat(voltagelist,30,1); % the list now is as long as the stimulation signal
AllignmentVector = [ListVolt, num2cell(Cutvector)]; % info for every WF
