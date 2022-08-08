clear all
close all
clc

Data = load ('file.csv');                     % Loading the Data
length_file = length(Data);                   % Length of File
% Arrays for gain,loss and difference variables
difference=[];                                 
gain = [];
loss = [];

for i= 2:length_file                 % Loop to calculate gain and loss
    difference(i) = Data(i)- Data(i-1);
    if difference(i) > 0
        gain(i) = difference(i);
        loss(i) = 0;
    
    elseif difference(i) < 0
        gain(i) = 0;
        loss(i) = abs(difference(i));
    else 
        gain(i)=0;
        loss(i)=0;
    end;
end;

Average_gain = [];
Average_loss = [];
sum_gain = 0;
sum_loss = 0;
RS = [];
RSI = [];

for i= 1:length_file                     
	sum_gain = sum_gain + gain(i);
	sum_loss = sum_loss + loss(i);
	if (i==15)
	Average_gain(i) = sum_gain/14;
	Average_loss(i) = sum_loss/14;
    RS (i) = Average_gain(i)/Average_loss(i);
    RSI(i) = 100-(100/(1+RS(i)));

	elseif (i>15)
    Average_gain(i) = (((Average_gain(i-1))*13)+gain(i))/14;
	Average_loss(i) = ((Average_loss(i-1)*13)+loss(i))/14;
    RS (i) = Average_gain(i)/Average_loss(i);
    RSI(i) = 100-(100/(1+RS(i)));

	end;
end;

buy = [];
sell = [];

for i = 16 : length_file
   if (RSI(i-1)>= 30 && RSI(i) <30 ) 
       buy(i)= RSI(i);
   elseif ((RSI(i-1) <= 70 && RSI(i) >70 )  )
       sell(i) = RSI(i);
 end;
 end;
 
plot(RSI,'r')
hold on;
plot (buy,'o');
hold on;
plot (sell, '*');
hold on;
