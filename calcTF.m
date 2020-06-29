function [ tf ] = calcTF( )
%CALCTF Summary of this function goes here
%   Detailed explanation goes here

endmember = multibandread('C:\Users\ntste\Documents\Mars\Marathon Valley\pancam12f_sub_unimix_3_unit_sum_constraint.dat',[641,743, 4], 'float', 0, 'bsq', 'ieee-le'); %b1 shadow, b2 dust, b3 MnO, b4 dusty, b5 sulfate
%topo_pi = multibandread('Z:\transfer\dump\Nathan\APXS\Unmix Comps\topo_PI.img',[200,250, 1], 'float', 0, 'bsq', 'ieee-le');
%[num, txt, raw] = xlsread('apxs_fov_info.xlsx'); %Read in information about the FOV function
[num,txt,raw] = xlsread('C:\Users\ntste\Documents\Mars\Marathon Valley\apxs_oxide_comps.xlsx'); %Read in PI APXS oxide composition data
%[num_spec,txt_spec,raw_spec] = xlsread('APXS_spectra.xlsx'); 
%ox_comp = num(1:5,:);
%ox_comp_err = num(6:10,:);
%apxs_spec = num_spec(:,1:5)';

%%%%%%%%%%%CHANGE HERE%%%%%%%%%%%%%%%%%%%%%%%%%
cols = 743;
rows = 641;
num_APXS = 10;
num_endmembers = 3;
y_offset = 93; %offset of abundance image relating to Pancam 12F
x_offset = 101;
APXS_centers_y = [427+y_offset,421+y_offset,433+y_offset,651+y_offset,666+y_offset,705+y_offset,684+y_offset,231+y_offset,247+y_offset,274+y_offset]; %Adding offset manually here
APXS_centers_x = [359+x_offset,356+x_offset,363+x_offset,149+x_offset,149+x_offset,157+x_offset,149+x_offset,704+x_offset,709+x_offset,712+x_offset];
center_heights = [1 1 1 1 1 1 1 1 1 1]; %MI FF standoff distances (cm), assuming 1 cm standoff for now
rad_acc_calx = [1 4 8 10 12 14 16]; %Radial acceptance  nominal distance measurements (mm)
rad_acc_caly = [1 .9 .5 .31 .14 .055 .01]; %Radial acceptance  nominal relative signal
% APXS_centers_y = [137,136,121,91,92];
% APXS_centers_x = [81,93,79,77,84];
%APXS_centers_x = [137,136,121,134,92];
%APXS_centers_y = [81,93,79,109,84];
spacing = .062; %Spacing per pixel in cm PI
%spacing = .0490; %Spacing per pixel in cm SI
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

gauss_val = zeros(rows,cols,num_APXS);
tf = zeros(num_APXS,num_endmembers);
for i = 1:rows
    i
    for j = 1:cols
        for k = 1:num_APXS
            r = rad_acc_calx*(30 + .025*1000 + center_heights(k))/30; %FOV scaling factor using topo information
            d2center = 10*spacing*sqrt((APXS_centers_x(k)-i)^2 + (APXS_centers_y(k)-j)^2); %Distance of pixel to APXS measurement centers in mm
            %gval(k) = (-0.02618 +(14.46233/(11.2326*sqrt(pi/2)))*exp(-2*((d2center-1.48349)/11.2326)^2));
            f1 = fit(r',rad_acc_caly','smoothingspline');
            gauss_val(i,j,k) =  f1(d2center);
            gval(k) = f1(d2center); %Adjusted gaussian for 2.6cm standoff 
            if gval(k) < 0 %|| topo_pi(i,j) == 0%Remove negative values introduced by imperfect gaussian fit
                gval(k) = 0;
                gauss_val(i,j,k) = 0;
            end
            m1(i,j,k) = gval(k);
        end
         for k = 1:num_APXS
             for m = 1:3
                 tf1(k,m) = endmember(i,j,m)*gval(k); %Fill TF matrix
             end
         end
        tf = tf + tf1;
    end
end

