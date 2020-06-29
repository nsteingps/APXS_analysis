function [V]=idivergence(D,S)
% Computes the I-divergence of each pair of columns from D and S
% and returns it as row-vector V
if any(D==0 | isnan(D))
    inonzero = find(D>0 & ~isnan(D));
    V = sum( D(inonzero) .* log(D(inonzero) ./ S(inonzero)),1) - sum(D(inonzero)-S(inonzero), 1);
else
    V = sum( D .* log(D ./ S) - D + S,1);
end

end