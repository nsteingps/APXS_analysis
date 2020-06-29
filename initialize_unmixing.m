function [new_cube_out, new_images, new_spectra] = initialize_unmixing(old_cube,tf,num_components)

% Joseph A. O'Sullivan 02/21/2015.
%
% Initializes guesses for component spectra and images. m
% Sufficient statistics are the initial EM image are in the standard EM update
% factor that equals the backprojection of the ratio of the data to the
% predicted data.  The sensitivity image weights the various terms.
tic;
maxiter=100; % number of iterations in each of two stages of matching
%[c_num_rows,c_num_cols, num_bands] = size(old_cube);
%old_cube=reshape(old_cube,c_num_rows*c_num_cols,num_bands);
%good_row_index_list = find(isnan(sum(old_cube,2))==0);
%good_rows = old_cube(good_row_index_list,:);
%num_good_rows=length(good_row_index_list);
[num_energies, num_meas] = size(old_cube);

% There vars still exist for convenience in coding. They're pretty
% unnecessary, though.
%good_rows = old_cube;
%num_good_rows = num_energies;

% Try random initialization with twice the number of components
num2=2*num_components;
%old_images=rand(num2,num_meas);
old_images = tf';
% old_spectra=rand(num_energies,num2);
% new_cube=old_spectra*old_images;
% kiter=0;
% while kiter<maxiter
%     kiter=kiter+1;
%     factor=old_cube./new_cube;
%     factor(isnan(factor)) = 0;
%     old_spectra=old_spectra.*(factor*old_images');
%     new_sum=sum(old_spectra,1);
%     for i=1:num2
%         old_spectra(:,i)=old_spectra(:,i)/new_sum(i);
%     end
%     old_images=old_images.*(old_spectra'*factor);
%     new_cube=old_spectra*old_images;
% end
% % Pick the components with the largest image sums
% sum_images=sum(old_images,2);
% [~,ind]=sort(sum_images,'descend');
% old_images=old_images(ind(1:num_components),:);
% old_spectra=old_spectra(:,ind(1:num_components));
    %Morrison
    %const_vals_a = [2.65 5.53 10.05 50.02 1.05 6.64 .52 .78 4.01 .95 .42 .37 16.57 .1867 .2277 .0186];
    %const_vals_b = [2.38 6.51 9.62 49.38 1.28 6.98 .79 .68 4.71 1.23 .2 .26 15.88 .0305 .1555 .0204];
    %const_vals_c = [2.49 7.7 8.93 43.97 1.09 11.83 .65 .73 4.45 .95 .35 .33 15.84 .4474 .2217 .0142];
    %const_vals_d = [1.3 23.5 1 .1 1.4 49.6 1.6 .4 7.6 1 .1 .1 .0011 2.3422 .1781 .01];
const_vals_a = [1	5	10	55	1	10	1	1	5	1	0.5	5	10 .01 .01 .01];
const_vals_b = [2	10	10	60	1	5	1	0.5	6	1	0.5	0.5	20 .01 .01 .01];
const_vals_d = [0.5	10	10	35	1	25	0.5	0.5	5	1	0.5	0.5	20 .01 .01 .01];
%  const_vals_a = rand(1,16);%[1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1];
%  const_vals_b = rand(1,16);%[1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1];
%  const_vals_c = rand(1,16);%[1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1];
%  const_vals_d = rand(1,16);%[1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1];
%const_vals_a = [1.7745 6.68 5.826 36.328 .747 5.544 1.904 .0968 23.569 .612 .3672 1.023 16.73 .06615 .2574 .0183];
%const_vals_b = [1.5015 3.507 2.2333 8.6279 .4233 52.36 .476 .088 31.85 .09 .144 .0099 3.0114 .00098 .00572 .00122];
c = rand(16,num_components);
old_spectra(:,1) =c(:,1).*const_vals_a';
old_spectra(:,2) =c(:,2).*const_vals_b';
old_spectra(:,3) =c(:,3).*const_vals_d';
%old_spectra(:,4) =c(:,4).*const_vals_d';
%old_spectra(:,3) =c(:,3).*const_vals_c';
%old_spectra(:,3) =[2.53;7.31;8.89;43.3;.99;10.48;1.54;.37;6.38;1.02;.19;.27;16.7];
%old_spectra(:,4) =c(:,4).*const_vals_d';
%while old_spectra(4,1) < 45
%    old_spectra(4,1) = rand(1)*50;
%end
%old_spectra(9,3) = rand(1)*1;
% while old_spectra(4,3) < 45
%     old_spectra(4,3) = rand(1)*50;
% end
%old_spectra(9,1) = rand(1)*1;
%old_spectra(9,2) = rand(1)*60;
%old_spectra(4,2) = rand(1)*10;
%old_spectra(4,3) = rand(1)*8;
%while old_spectra(6,2) < 45
%    old_spectra(6,2) = rand(1)*50;
%end
%while old_spectra(6,3) < 45
%    old_spectra(6,3) = rand(1)*50;
%end
%old_spectra(6,1) = rand(1)*5;
%old_spectra(6,3) = rand(1)*5;
new_cube=old_spectra*old_images;
kiter=0;
while kiter<maxiter
    kiter=kiter+1;
    factor=old_cube./new_cube;
    factor(isnan(factor)) = 0;
    old_spectra=old_spectra.*(factor*old_images');
    new_sum=sum(old_spectra,1);
%     old_images = tf';
%     new_sum2=sum(old_images,1);

    for i=1:num_components
        old_spectra(:,i)=old_spectra(:,i)/new_sum(i);
    end
%      for i=1:5
%          old_images(:,i) = old_images(:,i)/new_sum2(i);
%      end

    old_images=old_images.*(old_spectra'*factor);
    new_cube=old_spectra*old_images;
end

% RESHAPE
% old_images = tf';
% new_sum2=sum(old_images,1);
%     for i=1:5
%        old_images(:,i) = old_images(:,i)/new_sum2(i);
%     end
% old_images    
% filter new_spectra to be reasonably smooth
new_spectra=old_spectra;
% new_spectra = zeros(size(old_spectra));
% WIDTH = 0;
% for i=1:size(old_spectra,1)
%     min_window = max(1,i-WIDTH);
%     max_window = min(size(old_spectra,1)-1,i+WIDTH);
%     new_spectra(i,:) = mean(old_spectra(min_window:max_window,:),1);
% end

% old_cube(good_row_index_list,:)=old_images;
% new_images=reshape(old_images,c_num_rows,c_num_cols,num_components);
new_images=old_images;
%new_cube_out=nan(c_num_rows*c_num_cols, num_bands);
%new_cube_out(good_row_index_list,:)=new_cube;
%new_cube_out=reshape(new_cube_out,c_num_rows,c_num_cols, num_bands);
new_cube_out=new_cube;

%display('Initializing Endmember Unmixing: ');
%toc;
end
