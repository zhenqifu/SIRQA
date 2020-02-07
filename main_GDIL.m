%%  GDIL measurement 
% Add disparity and gbvs into your path, and run gbvs/gbvs_install.m.
% It will take a few minutes, due to the unoptimized matching algorithm.
clear all;
clc;
im_l = imread('left_source.png');  % source left image
im_r = imread('right_source.png'); % source right image
im_l_ret = imread('left_retargeted.png');  % retargeted left image
im_r_ret = imread('right_retargeted.png'); % retargeted right image 
    % SIFT-flow and disparity
    disp('flow calculating ...');
    uv1 = estimate_flow_interface(im_l, im_r, 'classic+nl-fast');
    uv2 = estimate_flow_interface(im_r, im_l, 'classic+nl-fast');
    uv3 = estimate_flow_interface(im_l_ret, im_r_ret, 'classic+nl-fast');
    uv4 = estimate_flow_interface(im_r_ret, im_l_ret, 'classic+nl-fast');
    dis_l = uv1(:,:,1);
    dis_r = uv2(:,:,1);    
    dis_l_ret = uv3(:,:,1);
    dis_r_ret = uv4(:,:,1);
    [foo_XX, foo_YY] = sift_flow(im_l, im_l_ret);
    ALL_XX_L = foo_XX;
    ALL_YY_L = foo_YY;
    [foo_XX, foo_YY] = sift_flow(im_r, im_r_ret);
    ALL_XX_R = foo_XX;
    ALL_YY_R = foo_YY;    
    
    disp('feature calculating ...');
    % 3D saliency
    s1 = gbvs(im_l);
    saliency = s1.master_map_resized;
    saliency = (saliency-min(saliency(:)))/(max(saliency(:))-min(saliency(:)));
    D1 = -dis_l;
    D1 = (D1-min(D1(:)))/(max(D1(:))-min(D1(:)));
    saliency_l = 0.5 * saliency + 0.5 * D1;
    s2 = gbvs(im_r);
    saliency = s2.master_map_resized;
    saliency = (saliency-min(saliency(:)))/(max(saliency(:))-min(saliency(:)));
    D1 = dis_r;
    D1 = (D1-min(D1(:)))/(max(D1(:))-min(D1(:)));
    saliency_r = 0.5 * saliency + 0.5 * D1;
    % MRT
    [ f1_L,f1_R,f2_L,f2_R ] = MRT( saliency_l, ALL_XX_L, ALL_YY_L, saliency_r, ALL_XX_R, ALL_YY_R );
    % VPT
    [ f3_L,f3_R,f4_L,f4_R ] = VPT( dis_l_ret, dis_r_ret );
    % quality evaluation
    disp('quality evaluating ...');  
    load model
    data_test = [f1_L;f1_R;f2_L;f2_R;f3_L;f3_R;f4_L;f4_R];
    score = predict(Factor, data_test');
    disp('============================')
    disp(['GDIL value =  ' num2str(score)]);
    disp('============================')




