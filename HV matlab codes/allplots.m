figure
ax1 = subplot(3,1,1);
plotHVContour(HV421)

ax2 = subplot(3,1,2);
plotHVContour(HV621)

ax3 = subplot(3,1,3);
plotHVContour(HV821)

% ax1 = subplot(3,1,1);
% plotHVContour(HV611)
% x2 = linspace(0,5,100);
% y2 = sin(x2);
% ax2 = subplot(2,1,2);
% plot(ax2,x2,y2)

% axis([ax1 ax2],[0 10 -1 1])