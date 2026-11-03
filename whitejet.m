function J = whitejet()

    % modified from:
    %       - Author:   V�ctor Mart�nez-Cagigal                               %
    %       - Date:     16/05/2018                                            %
    %       - Version:  1.0                                                   %
    %       - E-mail:   victor.martinez (at) gib (dot) tel (dot) uva (dot) es %
    %                                                                         %
    %       Biomedical Engineering Group (University of Valladolid), Spain   

    m=200;

    if nargin < 1
       f = get(groot,'CurrentFigure');
       if isempty(f)
          m = size(get(groot,'DefaultFigureColormap'),1);
       else
          m = size(f.Colormap,1);
       end
    end
    % Colors
    color_palette = [1/2 0 0;   % Deep red
                     1 0 0;     % Red
                     1 1 0;     % Yellow
                     1 1 1;     % White
                     0 1 1;     % Cyan
                     0 0 1;     % Blue
                     0 0 1/2];  % Deep blue
                 
    % Compute distributions along the samples
    color_dist = cumsum([0 1/10 1/5 1/5 1/5 1/5 1/10]);
    color_samples = round((m-1)*color_dist)+1;
    % Make the gradients
    J = zeros(m,3);
    J(color_samples,:) = color_palette(1:7,:);
    diff_samples = diff(color_samples)-1;
    for d = 1:1:length(diff_samples)
        if diff_samples(d)~=0
            color1 = color_palette(d,:);
            color2 = color_palette(d+1,:);
            G = zeros(diff_samples(d),3);
            for idx_rgb = 1:1:3
                g = linspace(color1(idx_rgb), color2(idx_rgb), diff_samples(d)+2);
                g([1, length(g)]) = [];
                G(:,idx_rgb) = g';
            end
            J(color_samples(d)+1:color_samples(d+1)-1,:) = G;
        end
    end
    J = flipud(J);
end