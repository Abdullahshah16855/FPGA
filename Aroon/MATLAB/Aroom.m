 clear all
close all
clc

Data = load ('arron.csv');                     % Loading the Data
Current_High= Data(:,1);	
Low =  Data(:,2);
length_file = length(Current_High);
Frame_size=14;
period=[];
Count=0;
Count1=0;
%------------------------------- PART 1------------------------------------
for i = 1:length_file-Frame_size         %AROON UP
    
    Previous_High =Current_High(i);
     
        for k=i+1:i+Frame_size
            
            if  Current_High(k) > Previous_High 
                Previous_High=Current_High(k);
                Count=0;
            else
                Count=Count+1;
            end
            
            if k == i+Frame_size
             period(k)=Count;
             aroon_up(k)= ((14-period(k))/14)*100;
             Count=0;
            end
        end
end
%-----------------------AROON Down---------------- PART 2------------------
for i= 1:length_file-Frame_size                          
    
    Min=Low(i);
        
        for k=i+1:i+Frame_size
            
            if  Min > Low(k)
                Min=Low(k);
                Count1=0;
            else
                Count1=Count1+1;
            end
            
            if k == i+Frame_size
            period1(k)=Count1;
            aroon_down(k)= ((14-period1(k))/14)*100;
             Count1=0;
            end

        end
end

plot(aroon_up)
hold on;
plot(aroon_down,'r')