function str = printpercent( partial, total )
    str = sprintf('%d of %d (%0.2f%%)', partial, total, partial/total * 100);
end

