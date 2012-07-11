function grad = makeGrad(s1,s2,overlap)
% grad = makeGrad(s1,s2,overlap)
% returns a gradient matrix for fading picture borders
% s1, s2 are the size in pixels of the gradient

% initializ gradient
grad = ones(s1,s2,3);

for i=1:3
    
    % top left, top right
    grad(1:overlap,1:overlap,i) = ([0:overlap-1]'/(overlap-1))*([0:overlap-1]/(overlap-1));
    grad(1:overlap,s2:-1:s2-overlap+1,i) = ([0:overlap-1]'/(overlap-1))*([0:overlap-1]/(overlap-1));

    % bottom left, bottom right
    grad(s1:-1:s1-overlap+1,1:overlap,i) = ([0:overlap-1]'/(overlap-1))*([0:overlap-1]/(overlap-1));
    grad(s1:-1:s1-overlap+1,s2:-1:s2-overlap+1,i) = ([0:overlap-1]'/(overlap-1))*([0:overlap-1]/(overlap-1));
    
    % left bar, right bar
    grad(overlap+1:s1-overlap,1:overlap,i) = repmat([0:overlap-1]/(overlap-1),s1-2*overlap,1);
    grad(overlap+1:s1-overlap,s2:-1:s2-overlap+1,i) = repmat([0:overlap-1]/(overlap-1),s1-2*overlap,1);
    
    % top bar, bottom bar
    grad(1:overlap,overlap+1:s2-overlap,i) = repmat([0:overlap-1]'/(overlap-1),1,s2-2*overlap);
    grad(s1:-1:s1-overlap+1,overlap+1:s2-overlap,i) = repmat([0:overlap-1]'/(overlap-1),1,s2-2*overlap);

end
