function [D_est,new_images,new_spectra,x,z,idivFromData]=APXS_Unmix_Funct(pi_apxs_comps,tf,err2)
%tic_total = tic;

% ------------- parameters -------------

num_energies = 16;
num_meas = 10;

%APXS_data_filename = 'APXS_spectra.xlsx';

num_components =3; % num endmembers to use in unmixing
num_iter = 1e4;

% --------- end parameters -------------


D = pi_apxs_comps(1:num_meas,1:16);%+pi_apxs_comps(17:30,1:16)';%+pi_apxs_comps(6:10,:)'; %comps
%D(11:12,:) = pi_apxs_comps(15:16,1:16);
% for i = 1:num_meas
%     err2(i,:) = [15 3 2 2 10 2 4 10 2 4 4 10 2 4 4 4];
% end
D=D';
%D = D + D.*err2'./100; 
%D(D < 0.01) = .01;

%D = pi_apxs_comps(6:10,:)'; %errors
% load data from file
%D = xlsread(APXS_data_filename);
D_est = D;

[D_est, old_images,old_spectra]=initialize_unmixing(D_est,tf,num_components);


z = old_spectra(6,2);
%
idivFromData = idivergence(D(:),D_est(:));

%%% Iterations %%
%x = zeros(4,10);
%x=old_images;
for k = 1:num_iter
    %tic_iter=tic;
    %display(sprintf('\nStarting iteration %d...',k));
    factor = D ./ (old_spectra*old_images); % should this be D or D_est?

    [D_est,new_images,new_spectra]=compute_unmixing(factor, old_images,old_spectra);
    
    if any(isnan(D_est(:)))
        error('D_est went NaN...');
    end
    
    old_images=new_images;
    if k == num_iter
        x = old_images;
    end
    old_spectra=new_spectra;

    oldIdivFromData = idivFromData;
    idivFromData(k) = idivergence(D(:),D_est(:));
    %idivProportionalDiff = abs( (idivFromData - oldIdivFromData) / oldIdivFromData);
    %display(sprintf('\nIteration %d...done: idiv changed %f -> %f (a change by %f)',k,oldIdivFromData,idivFromData,idivProportionalDiff));
    %toc(tic_iter);
end

% % Plots!
% 
% figure; plot(D);
% title('Raw Data');
% 
% figure; plot(D_est);
% title('Estimated Data');
% 
% figure; plot(new_spectra);
% title('Endmembers');
% new_spectra

%save Data_fit.mat I_Div;
%'Write image.';

%display(sprintf('\nTotal run time: '));
%toc(tic_total);
end
