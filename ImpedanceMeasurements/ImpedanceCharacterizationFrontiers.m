%% ADAPTED SCRIPT FOR IMPEDANCE MEASUREMENTS %%
%%%% Done by Silvia Ronchi, 04.02.2019 %%%%

clear all 
close all

%% Data and file upload

addpath(genpath('/home/sronchi/ElectricalStimulation/ImpedanceMeasurements/')) 
load("dacTraceImp.mat") % dacTrace, signal where the information reguarding the stimulation is stored
load("fittingWf.mat") % .mat file of one of stimulation repetitions
load("WholeChannel.mat") % .mat file containing the stimulation and readout channel
load("midval.mat") % mid value of the stimulation channel

Gain = 2; 
Amplitude = 8;
Duration = 50; 
Reps = 20;
time = [0:0.00005:(Duration-2)*5e-5];
MidVal = num2str(fittingWf(1));

%% Readout electrodes selection - manually selected a priori, using the raw file

ReadoutChannel = 705;
stimel = 7107;

%% DacTrace cut where the stimulation occurred

[CutVector,midvalue] = SignalCuttingImp(dacTrace); 
  
%% Fitting - RESULTS ARE GIVEN IN nF FOR THE CAPACITANCE C

[eq] = FitEquation (Amplitude, MidVal, Gain) % C is in nF

[fitresult, gof] = ImpFit(time,fittingWf,eq)



