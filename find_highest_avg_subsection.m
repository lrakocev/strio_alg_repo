function [best_coords, max_mean_sq, max_avg, max_std, max_med] = find_highest_avg_subsection(data, min_size)
    % data: Input 3D array
    % min_size: Minimum number of 1x1x1 voxels required in the shape

    data(isnan(data)) = 0;
    
    [X, Y, Z] = size(data);
    N = numel(data);
    data_sq = data.^2;
    
    % --- 1. Graph Setup (1x1x1 Voxel Resolution) ---
    % Total nodes: N Voxel Nodes + Source (S) + Sink (T)
    S = N + 1;
    T = N + 2;
    
    % To keep the shape spatially contiguous, we must penalize spatial disconnection.
    % We add edges between adjacent 1x1x1 voxels. 
    % A small edge weight (smoothing factor) encourages contiguous shapes.
    smooth_factor = 0.01 * mean(data_sq(:)); 
    
    % Generate 3D grid adjacencies (6-connectivity)
    [x_idx, y_idx, z_idx] = ndgrid(1:X, 1:Y, 1:Z);
    linear_indices = reshape(1:N, X, Y, Z);
    
    src_adj = []; dst_adj = [];
    
    % X-Neighbor edges
    idx1 = linear_indices(1:X-1, :, :); idx2 = linear_indices(2:X, :, :);
    src_adj = [src_adj; idx1(:)]; dst_adj = [dst_adj; idx2(:)];
    
    % Y-Neighbor edges
    idx1 = linear_indices(:, 1:Y-1, :); idx2 = linear_indices(:, 2:Y, :);
    src_adj = [src_adj; idx1(:)]; dst_adj = [dst_adj; idx2(:)];
    
    % Z-Neighbor edges
    idx1 = linear_indices(:, :, 1:Z-1); idx2 = linear_indices(:, :, 2:Z);
    src_adj = [src_adj; idx1(:)]; dst_adj = [dst_adj; idx2(:)];
    
    num_adj = length(src_adj);
    
    % --- 2. Binary Search for Size-Constrained Max Mean ---
    low = min(data_sq(:));
    high = max(data_sq(:));
    tolerance = 1e-5;
    
    best_voxels = [];
    
    while (high - low) > tolerance
        lambda = (low + high) / 2;
        
        % Build edges for this iteration
        s_nodes = []; t_nodes = []; weights = [];
        
        % Voxel Rewards & Costs:
        % If data_sq(i) > lambda, it's a net reward -> connect S to Voxel
        % If data_sq(i) <= lambda, it's a net cost -> connect Voxel to T
        net_weights = data_sq(:) - lambda;
        
        % Connect Source (S) to positive reward voxels
        pos_idx = find(net_weights > 0);
        s_nodes = [s_nodes; repmat(S, length(pos_idx), 1)];
        t_nodes = [t_nodes; pos_idx];
        weights = [weights; net_weights(pos_idx)];
        
        % Connect negative cost voxels to Sink (T)
        neg_idx = find(net_weights <= 0);
        s_nodes = [s_nodes; neg_idx];
        t_nodes = [t_nodes; repmat(T, length(neg_idx), 1)];
        weights = [weights; -net_weights(neg_idx)];
        
        % Add spatial connectivity edges between neighboring voxels
        s_nodes = [s_nodes; src_adj; dst_adj];
        t_nodes = [t_nodes; dst_adj; src_adj];
        weights = [weights; repmat(smooth_factor, num_adj*2, 1)];
        
        % Compute Min-Cut via Max-Flow
        G = digraph(s_nodes, t_nodes, weights);
        [~, ~, source_side, ~] = maxflow(G, S, T);
        
        % Identify selected voxels
        v_nodes = source_side(source_side <= N);
        
        % We check if the largest connected component within the cut meets min_size
        if ~isempty(v_nodes)
            temp_mask = false(X, Y, Z);
            temp_mask(v_nodes) = true;
            CC = bwconncomp(temp_mask, 6); % 6-connectivity for 1x1x1 components
            num_pixels = cellfun(@numel, CC.PixelIdxList);
            
            if max(num_pixels) >= min_size
                % The shape meets our size constraint! Push lambda higher to tighten the shape.
                low = lambda;
                [~, largest_cc_idx] = max(num_pixels);
                best_voxels = CC.PixelIdxList{largest_cc_idx};
            else
                % A shape formed, but it's smaller than min_size. Lambda is too high.
                high = lambda;
            end
        else
            % No voxels selected at all. Lambda is too high.
            high = lambda;
        end
    end
    
    % --- 3. Reconstruction & Metric Calculation ---
    max_mean_sq = low;
    mask = false(size(data));
    
    if ~isempty(best_voxels)
        mask(best_voxels) = true;
        selected_data = data(mask);
        max_avg = mean(selected_data, 'omitnan');
        max_std = std(selected_data, 'omitnan');
        max_med = median(selected_data, 'omitnan');
    else
        max_avg = 0; max_std = 0; max_med = 0;
    end

    [r, c, p] = ind2sub(size(data), best_voxels);

    best_coords = [r c p];
end
