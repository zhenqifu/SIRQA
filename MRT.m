function [ f1_L,f1_R,f2_L,f2_R ] = MRT( saliency_l, ALL_XX_L, ALL_YY_L, saliency_r, ALL_XX_R, ALL_YY_R ) 
BLK_SIZE = 16;
C1 = 1e-6;
ALPHA = 0.3;
%% left
smap = double(saliency_l);
[height_org, width_org,~] = size(smap);
blk_h = floor(height_org/BLK_SIZE); blk_w = floor(width_org/BLK_SIZE);    
blk_sal_org = zeros(blk_h, blk_w);
smap = smap/sum(smap(:));
for bi = 1:blk_h
    for bj = 1:blk_w
            top_h = (bi-1)*BLK_SIZE+1; top_w = (bj-1)*BLK_SIZE+1;
            CBlock_sal = smap(top_h:(top_h+BLK_SIZE-1), ...
                top_w:(top_w+BLK_SIZE-1));
            blk_sal_org(bi, bj) = sum(sum(CBlock_sal));
    end
end
    CBlock_sal_org = blk_sal_org;
    XX = ALL_XX_L; YY = ALL_YY_L;
    [Func_aprox_X,   Func_aprox_Y] = ReforumlatedMapping(smap, XX, YY);
    [blk_h, blk_w] = size(CBlock_sal_org);
     for bi = 1:blk_h
        for bj = 1:blk_w
            [Block_change_info, Information_loss] = ReTransBLK(Func_aprox_X, Func_aprox_Y, BLK_SIZE, bi, bj);
            CBlock_info_w = Block_change_info(:,:,1);
            CBlock_info_h = Block_change_info(:,:,2);
            w_ratio = ( CBlock_info_w(bi, bj) )/BLK_SIZE;
            h_ratio = ( CBlock_info_h(bi, bj) )/BLK_SIZE;
            m_ratio = (w_ratio + h_ratio)/2;
            ARS(bi, bj) = exp( -ALPHA*(m_ratio-1).^2)*...
                                (2*w_ratio*h_ratio+C1)/(w_ratio^2+h_ratio^2+C1);
            INL(bi, bj) = Information_loss/(BLK_SIZE*BLK_SIZE);
        end
     end    
        foo_score = CBlock_sal_org.*ARS;
        ARS_L = sum(foo_score(:));  
        foo_score = CBlock_sal_org.*INL;
        INL_L = sum(foo_score(:)); 

%% right
smap = double(saliency_r);
[height_org, width_org,~] = size(smap);
blk_h = floor(height_org/BLK_SIZE); blk_w = floor(width_org/BLK_SIZE);    
blk_sal_org = zeros(blk_h, blk_w);
smap = smap/sum(smap(:));
for bi = 1:blk_h
    for bj = 1:blk_w
            top_h = (bi-1)*BLK_SIZE+1; top_w = (bj-1)*BLK_SIZE+1;
            CBlock_sal = smap(top_h:(top_h+BLK_SIZE-1), ...
                top_w:(top_w+BLK_SIZE-1));
            blk_sal_org(bi, bj) = sum(sum(CBlock_sal));
    end
end
    CBlock_sal_org = blk_sal_org;
    XX = ALL_XX_R; YY = ALL_YY_R;
    [Func_aprox_X,   Func_aprox_Y] = ReforumlatedMapping(smap, XX, YY);
    [blk_h, blk_w] = size(CBlock_sal_org);
     for bi = 1:blk_h
        for bj = 1:blk_w
            [Block_change_info, Information_loss] = ReTransBLK(Func_aprox_X, Func_aprox_Y, BLK_SIZE, bi, bj);
            CBlock_info_w = Block_change_info(:,:,1);
            CBlock_info_h = Block_change_info(:,:,2);
            w_ratio = ( CBlock_info_w(bi, bj) )/BLK_SIZE;
            h_ratio = ( CBlock_info_h(bi, bj) )/BLK_SIZE;
            m_ratio = (w_ratio + h_ratio)/2;
            ARS(bi, bj) = exp( -ALPHA*(m_ratio-1).^2)*...
                                (2*w_ratio*h_ratio+C1)/(w_ratio^2+h_ratio^2+C1);
            INL(bi, bj) = Information_loss/(BLK_SIZE*BLK_SIZE);
        end
     end    
        foo_score = CBlock_sal_org.*ARS;
        ARS_R = sum(foo_score(:));
        foo_score = CBlock_sal_org.*INL;
        INL_R = sum(foo_score(:)); 
%%
        f1_L = ARS_L;
        f1_R = ARS_R;
        f2_L = INL_L;
        f2_R = INL_R;
end

