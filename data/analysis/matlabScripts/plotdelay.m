function plotdelay = plotdelay( delayMat, childNum, SessionNum)
%UNTITLED3 Summary of this function goes here
%   Detailed explanation goes here

mins = delayMat/120;



figure('Units','pixels','Position',[1,1,500,250])
colormap('summer');
bar(mins)
hXLabel = xlabel('Peaks')
hYLabel = ylabel('Time to Nearest Peak (min)')
hTitle = title(sprintf('Delay to Nearest OT Peak from Child Peak: Child %d, Session %s',childNum,SessionNum));

set( gca                       , ...
        'FontName'   , 'Arial' );
    set([hTitle, hYLabel], ...
        'FontName'   , 'AvantGarde');
    set([hYLabel]  , ...
        'FontSize'   , 10          );
    set( hTitle                    , ...
        'FontSize'   , 12          , ...
        'FontWeight' , 'bold'      );
    
    set(gca, ...
        'Box'         , 'on'     , ...
        'TickDir'     , 'in'     , ...
        'TickLength'  , [.005 .005] , ...
        'YGrid'       , 'off'      , ...
        'XColor'      , [.1 .1 .1], ...
        'YColor'      , [.1 .1 .1], ...
        'LineWidth'   , 1         );

    
    set(gcf, 'PaperPositionMode', 'auto');
    %print(gcf, '-djpeg', sprintf('c%ds%sdelay.jpg',childNum,SessionNum))
    %print(gcf, '-djpeg', sprintf('/Users/parama/Sites/affectiveSynchrony/images/c%ds%sdelay.jpg',childNum,SessionNum));
end