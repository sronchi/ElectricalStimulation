%% Vector separation depending on the WF, phase, amplitude

function [BPN, TPNP] = SignalSeparator (AllignmentVector)

BPN=struct('WF',{},'Ampl',{},'Phase',{}, 'Cut', {});
TPNP=struct('WF',{},'Ampl',{},'Phase',{}, 'Cut', {});
cc=0;
dd=0;

for j = 1:length(AllignmentVector)
    if strcmp(AllignmentVector{j,1},'currentBiPhasicPulse')
        for i = 2:1:9
            if AllignmentVector{j,2} == i
                for a = [1053,1579,1895,2105,5250]
                    if AllignmentVector{j,3} == a
                        cc=cc+1;
                        BPN(cc).WF = AllignmentVector{j,1};
                        BPN(cc).Ampl = AllignmentVector{j,2};
                        BPN(cc).Phase = AllignmentVector{j,3};
                        BPN(cc).Cut = AllignmentVector{j,4};
                    end
                end
            end
        end
    end
end
for j = 1:length(AllignmentVector)
    if strcmp(AllignmentVector{j,1},'currentTriPhasicPulse')
        for i = 2:1:9
            if AllignmentVector{j,2} == i
                for a = [1053,1579,1895,2105,5250]
                    if AllignmentVector{j,3} == a
                        dd=dd+1;
                        TPNP(dd).WF = AllignmentVector{j,1};
                        TPNP(dd).Ampl = AllignmentVector{j,2};
                        TPNP(dd).Phase = AllignmentVector{j,3};
                        TPNP(dd).Cut = AllignmentVector{j,4};
                    end
                end
            end
        end
    end
end
