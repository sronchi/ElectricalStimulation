   %% Vector separation depending on the WF, phase, amplitude

function [BPN, BNP, MN, MP] = SignalSeparator (AllignmentVector)

MN=struct('WF',{},'Ampl',{},'Phase',{}, 'Cut', {});
MP=struct('WF',{},'Ampl',{},'Phase',{}, 'Cut', {});
BPN=struct('WF',{},'Ampl',{},'Phase',{}, 'Cut', {});
BNP=struct('WF',{},'Ampl',{},'Phase',{}, 'Cut', {});
cc=0;
dd=0;
ee=0;
ff=0;
for j = 1:length(AllignmentVector)
    if strcmp(AllignmentVector{j,1},'monophasic_neg')
        for i = 7:7:42
            if AllignmentVector{j,2} == i
                for a = 1:1:4
                    if AllignmentVector{j,3} == a
                        cc=cc+1;
                        MN(cc).WF = AllignmentVector{j,1};
                        MN(cc).Ampl = AllignmentVector{j,2};
                        MN(cc).Phase = AllignmentVector{j,3};
                        MN(cc).Cut = AllignmentVector{j,4};
                    end
                end
            end
        end
    end
end
for j = 1:length(AllignmentVector)
    if strcmp(AllignmentVector{j,1},'monophasic_pos')
        for i = 7:7:42
            if AllignmentVector{j,2} == i
                for a = 1:1:4
                    if AllignmentVector{j,3} == a
                        dd=dd+1;
                        MP(dd).WF = AllignmentVector{j,1};
                        MP(dd).Ampl = AllignmentVector{j,2};
                        MP(dd).Phase = AllignmentVector{j,3};
                        MP(dd).Cut = AllignmentVector{j,4};
                    end
                end
            end
        end
    end
end
for j = 1:length(AllignmentVector)
    if strcmp(AllignmentVector{j,1},'biphasic_neg_pos')
        for i = 7:7:42
            if AllignmentVector{j,2} == i
                for a = 1:1:4
                    if AllignmentVector{j,3} == a
                        ee=ee+1;
                        BNP(ee).WF = AllignmentVector{j,1};
                        BNP(ee).Ampl = AllignmentVector{j,2};
                        BNP(ee).Phase = AllignmentVector{j,3};
                        BNP(ee).Cut = AllignmentVector{j,4};
                    end
                end
            end
        end
    end
end
for j = 1:length(AllignmentVector)
    if strcmp(AllignmentVector{j,1},'biphasic_pos_neg')
        for i = 7:7:42
            if AllignmentVector{j,2} == i
                for a = 1:1:4
                    if AllignmentVector{j,3} == a 
                        ff=ff+1;
                        BPN(ff).WF = AllignmentVector{j,1};
                        BPN(ff).Ampl = AllignmentVector{j,2};
                        BPN(ff).Phase = AllignmentVector{j,3};
                        BPN(ff).Cut = AllignmentVector{j,4};
                    end
                end
            end
        end
    end
end