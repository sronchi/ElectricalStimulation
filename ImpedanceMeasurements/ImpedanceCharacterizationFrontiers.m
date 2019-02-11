%% ADAPTED SCRIPT FOR IMPEDANCE MEASUREMENTS %%
%%%% Done by Silvia Ronchi, 04.02.2019 %%%%

clear all 
close all

%% Data and file upload

addpath(genpath('/home/sronchi/ElectricalStimulation/ImpedanceMeasurements/')) % to add the current folder path
load("dacTraceImp.mat") % dacTraceImp contains a voltage trace storing information about the electrical stimulation protocol 
load("fittingWf.mat") % .mat file of one of the stimulation repetitions over 20. Used for the fitting example.
load("WholeChannel.mat") % .mat file containing the whole stimulation and readout channel (it could be used for whole-channel plotting or further analysis)

Gain = 2; 
Amplitude = 8; % value in bits. it corresponds to 560 nA
Duration = 50; % value in samples. it corresponds to 2.5 ms
Reps = 20; % number of repetitions of the stimulation pulse
time = [0:0.00005:(Duration-2)*5e-5]; % time vector
MidVal = num2str(fittingWf(1)); % mid value of the stimulation channel. 

%% Readout electrodes selection indices

ReadoutChannel = 705;
stimel = 7107;

%% DacTrace cut where the stimulation occurred

[CutVector,midvalue] = SignalCuttingImp(dacTrace); 
  
%% Fitting - RESULTS ARE GIVEN IN nF FOR THE CAPACITANCE C

% FitEquation contains the electrical model function
[eq] = FitEquation (Amplitude, MidVal, Gain) % C is in nF

% ImpFit computes the fitting between experimental data and model function
[fitresult, gof] = ImpFit(time,fittingWf,eq)



