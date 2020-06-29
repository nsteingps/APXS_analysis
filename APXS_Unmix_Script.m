% Run APXS_Unmix function once
[pi_apxs_comps,txt,raw] = xlsread('C:\Users\ntste\Documents\Mars\Marathon Valley\apxs_oxide_comps.xlsx'); %Read in PI APXS oxide composition data
%tf = calcTF();

%spec_tot = zeros(507,4);
%divmat = zeros(507,4);
%spec_tot = zeros(16,4);
%divmat = zeros(16,4);
count = 0;
spec_tot_all = 0;
new_spec_all=0;
x_tot=zeros(3,10,1000);
x_f = zeros(3,16);
hold on;
tf_tracker = zeros(10,3,1000);
%tf_tracker_final = zeros(16,3,100);
%spec_tot_tracker = zeros(16,3,100);
%for j = 1:5
%    j
%    tf = rand(16,3);
%    tf_tracker(:,:,j)=tf;
% count = 0;
%spec_tot_all = 0;
%new_spec_all=0;=
%x_tot=zeros(3,16);  
%tf = z';
%USING ERRORS REPORTED BY RALF:
err2 = [0.28	0.20	0.15	0.42	0.12	0.37	0.03	0.07	0.08	0.09	0.05	0.03	0.20 .0112 .0033 .0025;
        0.31	0.18	0.14	0.38	0.10	0.24	0.02	0.06	0.06	0.09	0.04	0.02	0.14 .0066	.0019	.0018;
        0.32	0.19	0.13	0.34	0.10	0.25	0.01	0.06	0.05	0.07	0.04	0.01	0.13 .0072	.0016	.0017;
        0.25	0.16	0.15	0.44	0.10	0.25	0.03	0.07	0.08	0.09	0.05	0.02	0.17	.0081	.0032	.0023;
        0.25	0.15	0.14	0.42	0.10	0.22	0.02	0.06	0.07	0.10	0.04	0.02	0.14	.0067	.0025	.0023;
        0.32	0.20	0.23	0.60	0.12	0.20	0.04	0.08	0.11	0.10	0.06	0.03	0.19	.0097	.0043	.0027;
        0.22	0.12	0.13	0.35	0.10	0.18	0.03	0.07	0.07	0.09	0.05	0.02	0.11	.0078	.0030	.0021;
        0.26	0.15	0.16	0.53	0.10	0.14	0.03	0.06	0.07	0.08	0.04	0.02	0.10	.0056	.0018	.0022;
        0.28	0.17	0.19	0.59	0.10	0.15	0.03	0.07	0.08	0.09	0.05	0.02	0.12	.0064	.0022	.0024;
        0.28	0.20	0.15	0.42	0.12	0.37	0.03	0.07	0.08	0.09	0.05	0.03	0.20	.0112	.0033	.0025];
for index = 1:1
    index
%tf = tf_save + rand(1).*tf_deviation;
%tf(tf < 0.01) = 0.01;
for i = 1:1000
%tf=rand(7,2);
i

[D_est,new_images,new_spectra,x,z,idivFromData]=APXS_Unmix_Funct(pi_apxs_comps,tf,err2);

tf_tracker(:,:,i) = new_images';
%x_f = x + x_f;
%plot(idivFromData);

        spec_tot_all = spec_tot_all + new_spectra;
end
    %spec_tot_all_tracker(:,:,index) = spec_tot_all;
%end
% for i = 1:2
%    for j = 1:7
%            z(i,j) = median(x_tot(i,j,:));
%    end
% end
%tf_tracker_final(:,:,j) = x_tot'/100;
%spec_tot_tracker(:,:,j) = spec_tot_all;
end

%spec_tot = spec_tot/count;
% final_spec = spec_tot./divmat*100