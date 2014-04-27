function runJK
frameBased = 1;
dev = 5;
sep = 5; %in pixels
frameDir = ['/home/aarslan/prj/data/CMU_mocap_stereo/frames/plw/'];
D = rdir([frameDir 'disp0/*/*/*.png']);

%%% init model things
addpath(genpath('/home/aarslan/prj/code/JK_stereo'))
phase                   = [0 90];
rot                     = [-90:45:67.5];%[-90:22.5:67.5];
corres_param.type       = 'stereo';

% Stereo parameters
%------------------
corres_param.numFrames  = 2;
r2l                     = 2/(1.7/1.3);
r2s                     = r2l * 0.2;
sigma_filter            = 1;
rad                     = sigma_filter/r2s; % multiQ parameter
corres_param.offsets    = -45:2:45;
% offset_half_vector      = logspace(-1, log10(60), 20);
% corres_param.offsets    = [-offset_half_vector(end:-1:1) 0 offset_half_vector];

% % Pre-processing
% %--------------------------------------------------------------------------------------------------
% [h, w, ~] 				= size(stim_uint);
% if strcmp(corres_param.type, 'motion')
%     stim 			    = stim_uint(:, :, (end-corres_param.numFrames+1):end);
% else
%     stim                = stim_uint;
% end

% Normalization parameters
%--------------------------------------------------------------------------------------------------
normscope 				= 'patch';
% normscope               = 'none';
nparams.p 				= 1; % multiQ parameter
nparams.q 				= 2; % multiQ parameter
nparams.sigma 			= sqrt(1); % multiQ parameter
% nparams.p 				= 2;
% nparams.q 				= 4;
% nparams.sigma 			= sqrt(10);
nparams.rad 			= 10;

% Generate filters
% if exist('./filter.mat')
%     load filter.mat
% else
%     fprintf(1,'Initializing gaussian derivative quadrature filters -- full set...');
%     filters = HMAX_Combined_Filterbank(rot, rad, phase, corres_param, 'dog');
%     fprintf(1,'done\n');
% end
%%%

for d=1:numel(D)
    things = regexp(D(d).name, '/', 'split');
    LName = D(d).name;
    RName = [frameDir 'disp' num2str(dev) '/' things{end-2} '/' things{end-1} '/' things{end}];
    
    padSize = 40;
    stimL = imread(LName);
    stimR = imread(RName);
    stimL = padarray(stimL,[40 40], 'replicate');
    stimR = padarray(stimR,[40 40], 'replicate');
    
    stim = cat(3,stimL(:,:,1), stimR(:,:,1));
%     c1 = HMAX_Combined_C1p(stim, filters, normscope, nparams);
    c1 = pyHMAX_KMS(stim, 'stereo');
    % Squeezed, simplified form (hypercubic array)
    c1 = c1(40:end-40, 40:end-40, :,:,:);
    c1 = squeeze(c1);
    
end

end



