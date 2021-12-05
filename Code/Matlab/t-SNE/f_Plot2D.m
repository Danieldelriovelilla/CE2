function [h] = f_Plot2D(Y, y, Title)
    %{
    2D plot t-SNE results.
    Args:
        Y (Nx2 array): latent space coordinates.
        y (Nx1 array): labels.
        Title (string): figure title.
    %}

    categ = categorical( y );

    c = [[178, 22, 149];
         [74, 180, 47];
         [0, 80, 255];
         [255, 0, 0];
         [178, 151, 22];
         [22, 127, 178];
         [178, 22, 68]]/255;
    % color = lines( 6 );
    
    h = figure();
        hold on
        gscatter( Y(:,1), Y(:,2), categ, c, 'odph*s' )
        box on; grid on;
        legend( 'Location','northeastoutside', 'Interpreter', 'Latex', 'NumColumns', 5 )  
        title(Title, 'Interpreter', 'Latex')
        xlabel('Dim 1', 'Interpreter', 'Latex')
        ylabel('Dim 2', 'Interpreter', 'Latex')
        
  
%     m = '.';% 'odph*s';
%     h = figure();
%         hold on
%         % gscatter( Y(:,1), Y(:,2), categ, 'odph*s', 8, 'Lat_1', 'Lat_2' )
%         gscatter( Y(:,1), Y(:,2), categ, color, m, 10 )
% %         for i = 1:numel(categories(categorical(y)))
% %             idx = find(v == i);
% %             scatter(Y(idx,1),Y(idx,2),30,'filled',m(i), 'MarkerEdgeColor','k')
% %         end
%         grid on; box on
%         legend( 'Location', 'northeastoutside', 'Interpreter', 'Latex', 'NumColumns', 4 )
% %         legend(categories(categorical(y)), 'Location', 'NorthEastOutside', 'Interpreter', 'Latex', 'Location', 'best')
%         title(Title, 'Interpreter', 'Latex')
%         xlabel('Dim 1', 'Interpreter', 'Latex')
%         ylabel('Dim 2', 'Interpreter', 'Latex')


end
