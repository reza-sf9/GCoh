function [] = initial_paper(fft_seg, config)

fr = config.f_l;
sr = config.sample_r;

%% generate Y_k and estimate mu
m = size(fft_seg);
mm = size(fft_seg{1});
fft_ch = zeros(m(2), mm(1)*mm(2));
% mu_ch = zeros(m(2),1);
for i=1: m(2)
    temp = fft_seg{i};
    
    temp_ch = zeros(1,mm(1)*mm(2));
    for j=1: mm(1)
        temp_ch(1,(j-1)*mm(2)+1:j*mm(2)) = temp(j,:);
    end
%     mu_ch(i,1) = mean(temp_ch);
    fft_ch(i, :) = temp_ch;
end

Y_k = fft_ch.';
% mu_init = mu_ch;
% 
% %%  cross spectral
% cross_spect_mat = zeros(m(2), m(2));
% for i=1:m(2)
%     for j=1:m(2)
%         
%         X_i = fft_ch(i,:);
%         X_j = fft_ch(j,:);
%         K = length(X_i);
%         
%         cross_spect_mat(i,j) = (1/K)*sum(X_i.*conj(X_j));
%     end
% end
% 
% %% L, D
% [L , D] = eig(cross_spect_mat);
% 
% % sort
% D_sort = zeros(m(2));
% L_sort = zeros(m(2));
% for i=1 : m(2)
%     D_sort(i , i) = D(end - (i-1) , end - (i-1));
%     L_sort(: , i) = L(: , end - (i-1));
% end
% D_init = D_sort;
% L_init = L_sort;
% 
% %%  estimate a and b
% x0 = log(D_init(1,1));
% b_init = ones(m(2), 1);
% a_init = zeros(m(2), 1);
% 
% b_init(1, 1) =  1;
% for i=2:m(2)
%     a_init(i, 1) = log(D_init(i,i))-x0;
% end

cfg_Init.Y_k = Y_k;
% cfg_Init.mu = mu_init;
% cfg_Init.L = L_init;
% cfg_Init.D = D_init;
% cfg_Init.a = a_init;
% cfg_Init.b = b_init;
% cfg_Init.x0 = x0;
cfg_Init.cfgGen = config;

str_save = sprintf('cfg_Init_fr%d_sr%d.mat', fr, sr);
save(str_save, 'cfg_Init');
end