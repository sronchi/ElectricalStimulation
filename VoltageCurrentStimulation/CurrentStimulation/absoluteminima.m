%% Function to calculate the absolute minima

function [count] = absoluteminima (X_noOffset,ReadoutChannels,stdev)

localminima = [];
for ii= 1:1:length(ReadoutChannels)
    [pks,locs] = findpeaks(abs(X_noOffset(1:30,ii)),'MinPeakHeight',4*stdev);
    if isempty(locs)
        localminima(ii) = 0;
    else
        localminima(ii) = max(pks);
    end
end

index = localminima > 4*stdev;
count = nnz(index);
clear localminima