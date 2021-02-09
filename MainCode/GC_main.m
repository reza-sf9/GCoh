clc
clearvars -except data_det T Fs
close all



%% data
%%% loading data
if exist('data_det') ~=1
    load('eeganes07laplac250_detrend_all.mat');
end




%% scatter plot
%%% plotting scatter plot for Angle between Largest Corresponding
%%% Eigenvectors and Global Coherence over time

% f_vec = [12 25]; % frequecies that we want to calc scatter plot for them
% fun_scatter_eigVec_GC(f_vec)
%

%% configuration
%%% with method_GC, the method that we want use to calculate GC is selected
%%% there are two options,
%%% first = Proposed, means without subtracting from mean FFT
%%% second = PNAS, based PNAS Brown paper and subtracting FFT results from FFT's mean

% this method type only affects on FFT calculatoin (removed_fft_mean_fun)
% method_GC = 'Proposed';






method_GC = 'PNAS';

% this method affetcs only on angle_eig_vec_fun
% method_angle = 1;
method_angle = 2;

%%% analyze configuration
config.ch_num = 32;                                      % number of channels
config.Fs = 250;                                         % sampling rate of data
config.sample_r = 256;
config.win_sec = config.ch_num*2 ;
config.win_length = config.win_sec*config.sample_r;      % (sample) length of window that we want to calc Global Coherence on them
config.seg_num = config.win_sec;                     % (number) number of segments that we want to devide a window into them  (number)
config.seg_length = config.win_length./config.seg_num;   % (sample)
config.f_l = 12;                                         % lower bound of desired freq interval
config.f_u = config.f_l + 0;                             % upper bound of desired freq interval
config.method_GC = method_GC;
config.over_lap = .0;                                   % (of 1) length of overlap window based win length
config.method_angle = method_angle;
config.T = T;

%%% data extraction
m=size(data_det);
data_chs = zeros(m(1) , config.ch_num);
t_min = T./(60);

%%% Time Plot
plt_time = 0;
if plt_time == 1
    ch_plt_vec = [6 40];
    fnt_size = 25;
    
    for i=25 : config.ch_num
%         ch_plt = ch_plt_vec(i);
        figure('units','normalized','outerposition',[0 0 1 1]),
        plot(t_min, data_det(:,i), 'Color', [27, 27, 28]./255)
        
        ylim([-3000 3000])
        
        set(gca,'FontSize', fnt_size)
        
% 
        set(gca, 'YTIck', [-500:500:500])
        set(gca, 'YAxisLocation', 'right')
        
        


        xlabel('Time (mins)')
        ylabel('Amplitude')
        xlim([0 t_min(end)])
        ylim([-800 800])
        
        set(gca, 'XTIck', [20:40:140])
        
        
        set(gcf, 'PaperPosition', [0 0 6 4]);
%         print('time_40','-dpng','-r600')
        
        
        
    end
    close all
end
%% extracting data
ch_rand = [1 2 3 4 5 6 7 11 12 13 14 17 18 19 24 25 29 33 34 35 36 37 38 40 41 42 43 48 49 54 55 60];
% ch_rand = [17, 12, 41, 6, 2, 1, 22, 53];
for i=1: length(ch_rand)
    data_chs(:, i) = data_det(:,ch_rand(i));
end

% for i=1: config.ch_num
%     data_chs(:, i) = data_det(:,i);
% end




%% multitaper & ordinary spectrogram

% input structure of multitaper spectrogram
cfg_mtp_spect = struct;

cfg_mtp_spect.T = T;               % time indices
cfg_mtp_spect.ch_des_num = length(ch_rand);     % desired channel for plotting spectrogram
cfg_mtp_spect.f_des_l = 1;         % (freq(Hz)) the lower range for plotting spectrogram
cfg_mtp_spect.f_des_u = 100;         % (freq(Hz)) the lower range for plotting spectrogram
cfg_mtp_spect.mtp_NW = 3.5;         % NW (halfbandwidth) value for calculating multitaper
cfg_mtp_spect.mtp_win_length = 8;  % (sec) win length for calculating multitaper
cfg_mtp_spect.mtp_over_lap = .5;   % (of 1) length of overlap window based win length

% this fuction plot spectrogram based multitaper approach for desired channel
% multiTaper_spectrogram(data_chs , cfg_mtp_spect)

%


%% calc GC and Igen info
[GC , sorted_eig_info] = calc_GC_steps(data_chs , config);

% we can load instead of calculating again GC adn EIGEN info if we saved it
% for desired freq before

% struct_sub6_gc = [];

% load('ch32_win32_seg32_frL12_frU12_overLap0')
% load('ch32_win32_seg32_frL25_frU25_overLap0')

%% (ANALYZING RESULTS)

fnt_size = 20;

%%% Global Coherence PLOTTING
plot_GC_fun(GC , config);
close all;

% ang_diff_phase_ev(sorted_eig_info , config, fnt_size)
close all 

%%% calculating angle between largest corresponding eigenvectors over time (1d)
% ang_eigVec = angle_eig_vec_fun(sorted_eig_info , config, fnt_size);
close all;

% trace_ev(sorted_eig_info , config, fnt_size )
close all

%% sum eigenvalues
[max_eig_val , sum_eig_val] = max_sum_eig_value(sorted_eig_info , config );
close all

%% saving part for using in FUN_SCATTER_EIGVEC_GC

% scatter_info = struct;
% scatter_info.cfg = config;
% scatter_info.GC = GC(2:end);
% scatter_info.ang_eigVec = ang_eigVec;
%
%
% if config.f_l == config.f_u
%     str_save = sprintf('scatter_info_ch%d_win%d_seg%d_f%d.mat' ,...
%         config.ch_num, config.win_sec,  config.seg_num, config.f_l);
%     save(str_save , 'scatter_info')
% end

%% plotting max & sum of eigenvalues over time (1dmax_sum_eig_value(sorted_eig_info , config);
% close all


