figure
hold on
plot(1:tot_stages,fi,'-r')
plot(1:tot_stages,di,'-g')
plot(1:tot_stages,F,'-k')
plot(1:tot_stages,D,'-b')
hold off
title('Experimental Accuracy')
ylabel('rate')
xlabel('stage')
legend('fi','di', 'false positive rate', 'detection rate')
lh=findall(gcf,'tag','legend');
set(lh,'location','northeastoutside')