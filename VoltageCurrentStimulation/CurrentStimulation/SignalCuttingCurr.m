%% Script for cutting the file with the dacTrace as a reference %%

function [ListCurr, AllignmentVector] = SignalCuttingCurr(dacTrace, currentlist)

%[dacrow,daccol] = find(dacTrace(5.3e5:5.5e5,1)<550 & dacTrace(5.3e5:5.5e5,1)>450)
if (dacTrace(500000,1)<550 && dacTrace(500000,1)> 450)
    midvalue = dacTrace(500000,1)
else 
    midvalue = dacTrace(500005,1)
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

ListCurr = repmat(currentlist,30,1); % the list now is as long as the stimulation signal
AllignmentVector = [ListCurr(1:length(Cutvector),1:3), num2cell(Cutvector)]; % info for every WF
