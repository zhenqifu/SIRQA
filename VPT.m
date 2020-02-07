function [ f3_L,f3_R,f4_L,f4_R ] = VPT( dis_l_ret, dis_r_ret )
%% Left
BLK_SIZE = 16;
C1 =  1e-6;
Disp = dis_l_ret;
[m,n] = size(Disp);
Occluded = ComputeOccl_L(Disp);
g = (m*n - sum(Occluded(:)))/(m*n);
[x,y] = meshgrid(1:n, 1:m);
Dmap = x + round(Disp);  
Vertex_set(:,:,2) = Dmap(1:BLK_SIZE:m,1:BLK_SIZE:n);
Vertex_set(:,:,1) = y(1:BLK_SIZE:m,1:BLK_SIZE:n);
Vertex = Vertex_set(:,:,2);
[h,w] = size( Vertex );
for j = 1:h-1
    for k = 1:w-1
        a1 = Vertex(j,k+1) - Vertex(j,k);
        a2 = Vertex(j+1,k+1) - Vertex(j+1,k);
        a = 0.5*(a1 + a2);
        score(j,k) = (2*a*BLK_SIZE + C1 )/(a^2 + BLK_SIZE^2 + C1);
    end
end
G_L = g;
[nn,mm] = size(score);
p = score;
F_L = sum(p(:))/(nn*mm);
    
%% Right
Disp = dis_r_ret;
[m,n] = size(Disp);
Occluded = ComputeOccl_R(Disp);
g = (m*n - sum(Occluded(:)))/(m*n);
[x,y] = meshgrid(1:n, 1:m);
Dmap = x + round(Disp); 
Vertex_set(:,:,2) = Dmap(1:BLK_SIZE:m,1:BLK_SIZE:n);
Vertex_set(:,:,1) = y(1:BLK_SIZE:m,1:BLK_SIZE:n);
Vertex = Vertex_set(:,:,2);
for j = 1:h-1
    for k = 1:w-1
        a1 = Vertex(j,k+1) - Vertex(j,k);
        a2 = Vertex(j+1,k+1) - Vertex(j+1,k);
        a = 0.5*(a1 + a2);
        score(j,k) = (2*a*BLK_SIZE + C1 )/(a^2 + BLK_SIZE^2 + C1);
    end
end
    G_R = g;
    [nn,mm] = size(score);
    p = score;
    F_R = sum(p(:))/(nn*mm);

f3_L = F_L;
f3_R = F_R;
f4_L = G_L;
f4_R = G_R;

end

