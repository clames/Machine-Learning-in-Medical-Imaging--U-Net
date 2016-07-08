function Y = unpool(X, pool, varargin)

backMode = numel(varargin) > 0 ;

s = [size(X,1), size(X,2), size(X,3), size(X,4)];
pool = pool(1);

if ~backMode
    Y = zeros(s(1)*pool, s(2)*pool, s(3), s(4), 'like', X);               %output has pool-times the original size
    Y(1:pool:s(1)*pool, 1:pool:s(2)*pool, :, :) = X;
    %Y(end+1, end+1, :, :) = 0;
    %Y(end+1, :, :, :) = 0;
%     sY = [size(Y,1), size(Y,2), size(Y,3), size(Y,4)];              %output size
%     [r,c,d,b] = ndgrid(1:pool:sY(1), 1:pool:sY(2), 1:s(3), 1:s(4)); %construct 4-D grid
%     indices = sub2ind([sY(1),sY(2),s(3),s(4)], r,c,d,b);            %find corresponding indices
%     Y(indices(:)) = X(:);                                           %pass X-values to chosen locations
    
    % ----- Older version: ----- %
    %r = 1:s(1);
    %r(2:end) = r(2:end) + (pool-1)*r(1:end-1) ;
    %c = pool^2 * s(1) * (0:s(2)-1);
    %indices = repmat(r, 1, s(2)) + repelem(c, 1, s(1));   % (2D indices) per channel, per image
    %dim3 = repelem(0:s(3)-1, 1, s(1)*s(2));
    %indices3D = dim3*s(1)*s(2)*(pool^2) + repmat(indices, 1, s(3));
    %dim4 = repelem(0:s(4)-1, 1, s(1)*s(2)*s(3));
    %indices4D = dim4*s(1)*s(2)*s(3)*(pool^2) + repmat(indices3D, 1, s(4));
    %Y(indices4D) = X(:);
    %Y = gpuArray(single(Y)) ;
    %Y = single(Y);
    % --------------------------- %
    
else
    dzdy = varargin{1}; %backpropagate derivatives
    %X = dzdy;
    Y = dzdy(1:pool:s(1), 1:pool:s(2),:,:); %return back to size(X)
    %Y = single(Y);
end

end
