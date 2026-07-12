function xloc = corr_dist_percentile(percentile,n_tsteps)
    syms r
    f(r) = (1-r.^2).^((n_tsteps-1)/2)/beta(1/2,(n_tsteps+1)/2);
    F(r) = int(f,r);
    xloc = double(vpasolve(percentile == F(r) - F(-1),r));
    clear syms
end