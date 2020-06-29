function [new_cube_out, new_images, new_spectra] = compute_unmixing(update_factor, old_images, old_spectra)
% Joseph A. O'Sullivan 02/21/2015.
%
% Takes current guesses for component spectra and images an updates them
% Sufficient statistics from the last image are in the standard EM update
% factor that equals the backprojection of the ratio of the data to the
% predicted data.  The sensitivity image weights the various terms.
tic;

[num_energies, num_meas] = size(update_factor);
[~,num_components]=size(old_spectra);

%factor = reshape(update_factor,c_num_rows*c_num_cols, num_bands);
%
%factor=factor(good_row_index_list,:); % select only the spatial locations that have spectra
%
% old_images=reshape(old_images,c_num_rows*c_num_cols,num_components); do
% not reshape old_images until all iterations are finished
new_spectra=old_spectra.*(update_factor*old_images');
new_sum=sum(new_spectra,1);
% FIX THE NEXT LINE
new_spectra=new_spectra*diag(1./new_sum);
new_images=old_images.*(old_spectra'*update_factor);
new_cube=new_spectra*new_images;
% RESHAPE
% new_images=reshape(new_images,c_num_rows,c_num_cols,num_components);
%new_cube_out=nan(c_num_rows*c_num_cols, num_bands);
%new_cube_out(good_row_index_list,:)=new_cube;
%new_cube_out=reshape(new_cube_out,c_num_rows,c_num_cols, num_bands);
new_cube_out = new_cube;
%toc;
end