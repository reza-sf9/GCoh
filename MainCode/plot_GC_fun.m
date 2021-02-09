function plot_GC_fun(GC , config)
% PLOT_GC_FUN(GC , config , method_GC) function plot GC 
% if we have an interval for desired freq our plot is 2D
% if we only want to plot an individual freq, we have a 1D plot
%INPUTS
%  GC a cell that contains GC for different frequencies and window times
%
% config is a structure with 9 fields in it
% 1 - ch_num :    number of channels
% 2 - Fs :        sampling rate of data
% 3 - sample_r :  chosen sample rate for making windows and segments (this is not sample rate of data)
% 4 - win_sec :   this value multiply to sample_r = length of window uses for chunking data
% 5 - win_length  (sample) length of window that we want to calc Global Coherence on them
% 6 - seg_num     (number) number of segments that we want to devide a window into them  (number)
% 7 - seg_length  (sample) number of samples of segments
% 8 - f_l         lower bound of desired freq interval
% 9 - f_u         upper bound of desired freq interval
% 10 - method_GC  specify the method that we use
% with method_GC, the method that we want use to calculate GC is selected
% there are two options,
% first = Proposed, means without subtracting from mean FFT
% second = PNAS, based PNAS Brown paper and subtracting FFT results from FFT's mean
% 11 - over_lap : (of 1) length of overlap window based win length 


%%%% Extract config info
ch_num = config.ch_num;
sample_r = config.sample_r;
win_length = config.win_length;
seg_num = config.seg_num;
f_l = config.f_l;
f_u = config.f_u;
method_GC = config.method_GC; 
over_lap = config.over_lap;

m = size(GC);
%%% m(1) = num of desired frequencies
%%% m(2) = num of windows

f_ind = [f_l f_u];

win_sec = win_length./sample_r;
% data_length = m(2)*win_sec;
% t_ind = win_sec/2 :win_sec: data_length-win_sec/2;
% % t_ind = t_ind./(60*60); %%% change second scale to hour
% t_ind = t_ind./(60); %%% change second scale to min


T = config.T;
t_ind = 1 :T(end)/length(GC): T(end);
t_ind = t_ind./(60); 

% color_rgb_1 = [13, 55, 122]./255;
% color_rgb_2 = [109, 19, 52]./255;

color_rgb_1 = [174, 16, 232]./255;
color_rgb_2 = [244, 209, 66]./255;

switch method_GC
    case 'Proposed'
        color_plot = color_rgb_1;
    case 'PNAS'
        color_plot = color_rgb_2;
end


%%% 2d plot
if m(1)>1
    
    figure
%     figure('units','normalized','outerposition',[0 0 1 1]),


    

    imagesc(f_ind,t_ind,GC.'),colorbar;
    str_tit_1 = sprintf('Global Coherence for %d channels',ch_num);
    str_tit_2 = sprintf('window length = %d sec * number of segment per each window = %d * overlap = %.0f%%',...
        win_sec , seg_num , over_lap*100);
    str_tit_3 = sprintf('%s' , method_GC);
    xlabel('Freq (Hz)'),
    ylabel('Time (mins)')
    
    set(gca,'FontSize',20)
    
%     title({str_tit_1 , str_tit_2 , str_tit_3})
    view(-90,90);
    colormap('jet')
    %% % 1d plot
else
    figure
%     figure('units','normalized','outerposition',[0 0 1 1]);
    plot(t_ind , GC , 'LineWidth',4 , 'color' , 'b')
    xlim([0 t_ind(end)]) , ylim([0 1])
    xlabel('Time (mins)'),ylabel('GC');
%     hold on

     set(gca,'FontSize',20)

    str_tit_1 = sprintf('GC');
    str_tit_2 = sprintf('%d channels at freq = %d * window length = %d sec * segments per each window = %d * overlap = %.0f%%'...
        ,ch_num, f_l ,win_sec , seg_num , over_lap*100);
    str_tit_3 = sprintf('%s' , method_GC);
%     title({str_tit_1 , str_tit_2 , str_tit_3});

%     legend('Original Signal','Smoothed Signal')
    
colormap jet 
    
end

end