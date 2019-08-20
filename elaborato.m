% Algoritmo di riconoscimento canzoni
% Angelo Amoako e Daniel Tinazzi
clear all;
close all;
clc;

% Prendo i nomi dei file audio
names = {struct(dir('songs/*.mp3')).name};
names = names(1:4);
len = length(names);

% Carico i file audio
fprintf('Loading audio files:\n');
fprintf('0/%i\n', len);

songs = {};
for i = 1 : len
    [songs{i}, ~] = audioread(strcat('songs/', names{i}));
    fprintf('%i/%i\n', i, len);
end
%% Elaborazione

% Carico il campione da testare
[test, ~] = audioread('test/californication(ok).MP3');

% Cross correlation
fprintf('Cross correlating: \n');
fprintf('0/%i\n', len);

for i = 1 : len
    [xc{i}, lagc{i}] = xcorr(songs{i}, test, 'none');
    fprintf('%i/%i\n', i, len);
end

% Find match
fprintf('Comparing results to find the max:\n');
fprintf('0/%i\n', len);

max_element = 0;
lag = 0;
song_index = 0;
for i = 1 : len
    [maxcorr, maxli] = max(xc{i});
    if maxcorr > max_element
        max_element = maxcorr;
        lag = lagc{i}(maxli);
        song_index = i;
    end
    fprintf('%i/%i\n', i, len);
end

%% Output
if (max_element < 0)
    fprintf('Song not recognised.\n');
else
    time = lag / (44100 * 60 * 60 * 24);
    fprintf('Song recognized: %s\nTime: %s\nMatch ratio: %i\n', names{song_index}, datestr(time, 'MM:SS'), max_element);
end
