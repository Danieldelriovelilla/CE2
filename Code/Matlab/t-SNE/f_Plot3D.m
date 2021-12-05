function [h] = f_Plot3D(Y, y, Title)
    %{
    3D plot t-SNE results.
    Args:
        Y (Nx3 array): latent space coordinates.
        y (Nx1 array): labels.
        Title (string): figure title.
    %}

    cat = categorical( y );
    cats = categories( cat );
    N_cat = numel( cats );
    
    color = lines( N_cat );
    
    
    v = double(categorical(y));
    c = zeros(numel(v),3);
    
    for i = 1:N_cat
        idx = find(v == i);
        c(idx,:) = ones(numel(idx),1)*color(i,:);            
    end
    
    % idx = find(v == 2);
    % c(idx,:) = ones(numel(idx),1)*[74, 180, 47]/255;
 
    h = figure();
        hold on
        for i = 1:N_cat
            idx = find(v == i);
            scatter3( Y(idx,1), Y(idx,2), Y(idx,3), ...
            30, c(idx,:), 'filled', 'MarkerEdgeColor', 'k', ...
            'LineWidth', 0.01)
        end
        grid on; box on
        view(25,10)
        legend(categories(categorical(y)), 'Interpreter', 'Latex',...
            'Location','northeastoutside', 'NumColumns', 5)
        title(Title, 'Interpreter', 'Latex')
        xlabel('Dim 1', 'Interpreter', 'Latex')
        ylabel('Dim 2', 'Interpreter', 'Latex')
        zlabel('Dim 3', 'Interpreter', 'Latex')

end
