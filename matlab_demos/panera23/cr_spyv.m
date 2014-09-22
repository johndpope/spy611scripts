% /a/ks/b/matlab/panera23/cr_spyv.m

% I use this script to create a table full of vectors full of features
% from a table full of dates, open-prices, and close-prices.

% Demo:
% % cp is closing-price:
% [ydate, cp, openp, lowp, highp, volume, closeadj]=StockQuoteQuery(symbl, startDate, endDate, freq);
% 
% dateprice = table();
% dateprice.ydatestr = datestr(ydate,'yyyy-mm-dd');
% dateprice.ydate    = ydate;
% dateprice.openp    = openp;
% dateprice.cp       = cp;
% 
% writetable(dateprice, 'data/dateprice.csv');

% spyv = cr_spyv(dateprice);

function spyv = cr_spyv(dateprice)

spyv = dateprice;


spyv.opnxt = vertcat(spyv.openp(2:end), NaN);
spyv.pctg  = 100.0*(spyv.opnxt - spyv.cp)./spyv.cp;
spyv.yval  = 1+(spyv.pctg >= 0);
% cpma is my 1st feature:
wndw             = 100;
bval             = ones(1,wndw)/wndw;
mvgavg100        = filter(bval, 1, spyv.cp);
mvgavg100(1:100) = spyv.cp(1:100);
spyv.cpma = spyv.cp ./ mvgavg100;

spyv.ocg   = (spyv.cp - spyv.openp) ./ spyv.openp ;
cplag      = vertcat(spyv.cp(1), spyv.cp(1:end-1) )    ;
spyv.n1dg1 = (spyv.cp - cplag) ./ cplag         ;
spyv.n1dg2 = vertcat(0, spyv.n1dg1(1:end-1) ) ;
spyv.n1dg3 = vertcat(0, spyv.n1dg2(1:end-1) ) ;

lag = 5;
wlag1 = vertcat(spyv.cp(1:lag), spyv.cp(1:end - lag));
spyv.n1wlagd = (spyv.cp - wlag1) ./ wlag1;
spyv.n2wlagd = vertcat(spyv.n1wlagd(1:lag), spyv.n1wlagd(1:end - lag));

lag = 20
mlag1 = vertcat(spyv.cp(1:lag), spyv.cp(1:end - lag));
spyv.n1mlagd = (spyv.cp - mlag1) ./ mlag1;
spyv.n2mlagd = vertcat(spyv.n1mlagd(1:lag), spyv.n1mlagd(1:end - lag));

% Features calculated now.

