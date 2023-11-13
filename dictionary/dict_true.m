function [dict, dict_norm, lut] = dict_true(RFpulses, TR)
% this function generates IR-BSSFP dictionary 
% Inputs: 
%                 RFpulses: sequence of L Flip Angles (RAD)
%                 TR: sequqnce of L repetition times (msec)
%                 T1: set of T1 values (msec)
%                 T2: set of T2 values (msec)
%                 off: set of off-resonance frequencies (kHz)

% Outputs: 
%                 dict: IR-BSSFP dictionaty (noormalized)
%                 dict_norm: fingerprints norm
%                 lut: look-up table for all atoms
%         CORRECTION DONE FOR T1<T2 
% (c) Mohammad Golbabaee, 2017

L = size(RFpulses,2);
T1=[100:20:2000,2300:300:5000];
off = [-250:40:-190, -50:2:50, 190:40:250];
T2=[20:5:100,110:10:200,400:200:3000];
counter = 1;
for i = T1
    for j = T2
         if i < j
            continue
         end
        T1_set(counter) = i;
        T2_set(counter) = j;
        counter = counter + 1;
    end
end
d=length(T2_set)*length(off);
T2_set=T2_set.';
T1_set=T1_set.';

% Build lookup table
lookup_table = cell(d, 1);
counter = 1;
for k = off
    for i = T1
        for j = T2
        if i < j
            continue
        end
             lookup_table{counter} = [k i j];
            counter = counter + 1;
        end
    end
end
dict = zeros(d, L);
Dprime=length(T1_set);
for k = 1:numel(off)
    dict((k-1)*Dprime+1:k*Dprime, :) = ...
        fastMRFdictionary_Grisword(RFpulses, TR, T1_set, T2_set, off(k));
end
dict = single(dict);
% dict = transpose(dict);
dict_norm =  (sqrt(sum(abs(dict).^2, 2)));
lut=zeros(size(lookup_table,1),3);
for i = 1:size(lookup_table,1)
    lut(i,3) = lookup_table{i}(1);
    lut(i,1) = lookup_table{i}(2);
    lut(i,2) = lookup_table{i}(3);
end