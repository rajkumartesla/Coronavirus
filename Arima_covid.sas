DM 'LOG;CLEAR;OUT;CLEAR;';
options formdlim='-' pageno=min nodate;
title 'Time Series Analysis';
PROC IMPORT OUT= WORK.Global_Confirmed_TimeSeries_Data
     DATAFILE= "/home/u42951927/my_courses/Global_Confirmed_TimeSeries_Data.csv"
     DBMS=csv REPLACE;
     GETNAMES=Yes;
RUN;
data Global_Confirmed_TimeSeries_Data;
set Global_Confirmed_TimeSeries_Data;
d_conformed = dif(conformed);
l_conformed = lag(conformed);

proc arima data=Global_Confirmed_TimeSeries_Data;
  identify var=conformed;
run;

proc arima data=Global_Confirmed_TimeSeries_Data;
  identify var=conformed stationarity=(adf=1);
  run;
  identify var=conformed stationarity=(pp=1);
  run;
quit;

proc arima data=Global_Confirmed_TimeSeries_Data;
  identify var=d_conformed(1) stationarity=(adf);
run;
 identify var=d_conformed(1) stationarity=(pp);
  run;
* Dickey-Fuller test regressions;
proc reg data=Global_Confirmed_TimeSeries_Data;
model d_conformed = l_conformed;
model d_conformed = l_conformed day;
run; 
* ARIMA(1,0,0) or AR(1);
proc arima data=Global_Confirmed_TimeSeries_Data;
identify var=conformed;
estimate p=1 method=ml; 
run;

* ARIMA(2,0,0) or AR(2);
proc arima data=Global_Confirmed_TimeSeries_Data;
identify var=conformed;
estimate p=2;
run;

* ARIMA(0,0,1) or MA(1);
proc arima data=Global_Confirmed_TimeSeries_Data;
identify var=d_conformed;
estimate q=1;
run;

* ARIMA(1,0,1) or ARMA(1,1);
proc arima data=Global_Confirmed_TimeSeries_Data;
identify var=d_conformed;
estimate p=1 q=1;
run;

* ARIMA(1,1,0);
proc arima data=Global_Confirmed_TimeSeries_Data;
identify var=conformed;
estimate p=1;
run;

* ARIMA(0,1,1);
proc arima data=Global_Confirmed_TimeSeries_Data;
identify var=conformed;
estimate q=1;
run;

* ARIMA(1,1,1);
proc arima data=Global_Confirmed_TimeSeries_Data;
identify var=conformed;
estimate p=1 q=1;
run;

* ARIMA(1,1,3);
proc arima data=Global_Confirmed_TimeSeries_Data;
identify var=conformed;
estimate p=1 q=3;
run;

* ARIMA(2,1,3);
proc arima data=Global_Confirmed_TimeSeries_Data;
identify var=conformed;
estimate p=2 q=3;
run;

* ARIMA (1,0,0) forecasting;
proc arima data=Global_Confirmed_TimeSeries_Data;
identify var=conformed;
estimate p=1 q=0;
forecast lead=15;
run;

* ARIMA (0,0,0) forecasting;
proc arima data=Global_Confirmed_TimeSeries_Data;
identify var=conformed;
estimate p=0 q=0;
forecast lead=15;
run;
