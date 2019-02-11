function [eq] = FitEquation (Amplitude, MidVal, Gain) 

AmplitudeAmp = num2str(Amplitude * 70); %Already adjusted for Rct e9 (nA * GOhm)

gain = num2str(Gain);
Zin = num2str(7.69e7);  % adjusted already for the amplitude in nA

eq = ([MidVal '+(' AmplitudeAmp '*Rct*(1-exp(-time/(Rct*C))))/(1+Rct/' Zin '*(1-exp(-time/(Rct*C))))'])
