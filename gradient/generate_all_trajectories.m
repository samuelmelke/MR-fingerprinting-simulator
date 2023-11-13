function[all_gradient_values, all_k_values] = generate_all_trajectories(g,k)
% Function generates gradients for all repetitions in MRF method
% by rotating the input gradient.
N_outer = 48; % no of interleaves
num_of_TRs = 1000; % number of repetitions
rot_angle = 2*pi/N_outer;
angles_to_rotate = 0:rot_angle:(rot_angle*(N_outer-1));
vec_to_mul_angles = exp(1i*angles_to_rotate).';
gradient_values = repmat(vec_to_mul_angles,1,length(g)).*repmat(g.',N_outer,1);
num_of_reps = ceil(num_of_TRs/N_outer);
all_gradient_values = repmat(gradient_values,num_of_reps,1);

%% kspace
k_values = repmat(vec_to_mul_angles,1,length(k)).*repmat(k.',N_outer,1);
num_of_reps = ceil(num_of_TRs/N_outer);
all_k_values = repmat(k_values,num_of_reps,1);

end
