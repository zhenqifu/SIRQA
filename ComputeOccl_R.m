function [ Occluder ] = ComputeOccl_R(Disp)
[m,n] = size(Disp);
[x,~] = meshgrid(1:n, 1:m);

Occluder = zeros(m,n);
Occluded = zeros(m,n);
% the correponding pixels in the right view
Dmap = x+round(Disp);     
% occulsion due to "out of FOV" in the borders of the image
Occluded(Dmap> n | Dmap < 1 ) = NaN;   
CDisp = cumsum(abs(Disp),2);
Disp(CDisp==0) = NaN;
Occluded(CDisp ==0) = NaN;
ss = Occluded;
% sorting the disprity: first is the closest
[DispSorted, x_idx] = sort(Disp,2);

 for i=1:m
     in = find(~isnan(DispSorted(i,:)));
     % the sorted reference image coordinates that corresponds to 'in'
     x_idx_it = x_idx(i,in); 
     k = 1;
     j = 1 + n-length(in);
     while j < n
         if(Occluder(i,x_idx_it(k))~= 0 ) 
             j = j + 1;
             continue;
         end
         % The other pixels in the right image whose disparties are smaller
         Dmap_curr = Dmap(i,x_idx_it(k+1:end)); 
         % the reference pixels that correspond to Dmap_curr
         x_curr = x(i,x_idx_it(k+1:end));
         
         Occluded_indx = x_curr(abs(Dmap_curr - Dmap(i,x_idx_it(k))) < 1 & (abs(x_idx_it(k) - x_curr) > 1) );
                                       
         if(~isempty(Occluded_indx))
             j = j + 1 + length(Occluded_indx);
             Occluder(i,x(i,x_idx_it(k))) = 1;
             Occluded(i,Occluded_indx) = x(i,x_idx_it(k));
         else
             j = j + 1;
         end
         
          k = k+1;
     end

 end
 
     Occluder = Occluder + ss;
 
     Occluder(Occluder ~= 0) = -1;
     Occluder(Occluder == 0) = 1;
     Occluder(Occluder == -1) = 0;
end
    
    