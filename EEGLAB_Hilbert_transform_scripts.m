%%  Perform the Hilbert transform on multiple data stored in ALLEEG structure (EEGLAB)

% Script allows to perform Hilbert transform on multiple EEG signals stored in ALLEEG structure.
% Input: ALLEEG structure with multiple EEG datasets.
% Output: Simple structure HilbertResults that can be used for further
% statistical analysis or calculations.

%%
%% Step 1: filter the data for a given EEG band (e.g. alpha, theta)

% User provided data (optional):
% NewNameAdd - specifies a suffix to be added to the name of each dataset to be analyzed
newNameU = 'Theta'; % np. Theta
% lowFreq and highFreq specify the filter bandwidth, e.g. for the theta EEG band it will be 4-7 Hz
lowFreq = 4; %e.g 4
highFreq = 7; %e.g. 7

for ii = 1:numel(ALLEEG)  
    [ALLEEG EEG CURRENTSET] = pop_newset(ALLEEG, EEG, 1,'retrieve',ii,'study',0);  
    oldName = EEG.setname;  
    newName=sprintf('%s_%s',oldName, newNameU);
    EEG = pop_eegfiltnew(EEG, lowFreq, highFreq,[],0,[],1);
    [ALLEEG EEG CURRENTSET] = pop_newset(ALLEEG, EEG, 1,'setname',newName,'gui','off'); 
    [ALLEEG EEG] = eeg_store(ALLEEG, EEG, CURRENTSET);
end

%% Step 2: Hilbert transform

for jj=1:numel(ALLEEG)    
    elNum = numel(ALLEEG(jj).data(:,1,1)); % liczba elektrod

    for ii=1:elNum
        HilbertResults(jj).setname = ALLEEG(jj).setname;
        HilbertResults(jj).hilbert(ii,:,:) = abs(hilbert(ALLEEG(jj).data(ii,:,:)));
    end
    
end
clearvars jj ii elNum

%% Step 3: additional calculations creating results structure

% Average of epochs for each electrode
for jj=1:numel(HilbertResults)
    HilbertResults(jj).meanEpochs = mean(HilbertResults(jj).hilbert,3);
end
clearvars jj

% Average of epochs and time points for each electrode
for jj=1:numel(HilbertResults)
    HilbertResults(jj).meanEpochsTime = mean(HilbertResults(jj).meanEpochs,2);
end
clearvars jj
