
%%   Import the input and the output 
whyinput_data = horzcat(season,yr,mnth,hr,holiday,weekday1,workingday,weathersit,temp,atemp,hum,windspeed);
input_data = whyinput_data(1:10000,1:12);


why_output_data = horzcat(cnt);
output_data = why_output_data(1:10000,1);

%%  Initialize 

 x1 = size(input_data,1); %rows of input
 x2 = size(input_data,2); %cols of input
 
 y1 = size(output_data,1); %rows of output
 y2 = size(output_data,2);  %cols of output
 
 No_of_Ip = x2;
 No_of_Op = y2;   
 No_of_Hidden = ((No_of_Ip + No_of_Op)/2);  % Hidden neurons
    
 for j=1:No_of_Hidden
   BiasWt_H(j) = 0.0;
   for i=1:No_of_Ip 
      DeltaWt_IH(i,j) = 0.0 ; 
      Wt_IH(i,j) = rand ;
   end;
 end;
 
 for k = 1:No_of_Op
    for j = 1:No_of_Hidden
      DeltaWt_HO(j,k) = 0.0 ;
      Wt_HO(j,k) = rand ;
      Contextwt_H(j,k) = rand;
    end;
 end;
 
 
 for k = 1:No_of_Op
     BiasWt_O(k) = 0.0;
 end
 
 %%  Learning

k = 100;   % Folds
No_of_Pat = y1;   
lr = 0.7;       % Learning Rate
min = 10000;

for itr = 1:25    %Iterations or epochs
 Indices = crossvalind('Kfold',No_of_Pat ,k);
 err = 0;
 for i = 1:k
    testindex = (Indices == i);                
    trainindex = ~testindex;
    
    % Train
     Train_input_data =  input_data(trainindex,:);
     Train_output_data = output_data(trainindex,:);
    [BiasWt_H,BiasWt_O, Wt_IH,Wt_HO,Contextwt_H,Output] = train(Train_input_data,Train_output_data,No_of_Ip,No_of_Hidden,No_of_Op,...
                                        size(Train_input_data,1),BiasWt_H,BiasWt_O,Wt_IH,Wt_HO,Contextwt_H,lr); 
                        
    % Test
    Test_input_data =  input_data(testindex,:);
    Test_output_data = output_data(testindex,:);
     err = test(Test_input_data,Test_output_data,No_of_Ip,No_of_Hidden,No_of_Op,size(Test_input_data,1),...
                        Wt_IH,BiasWt_H,BiasWt_O, Wt_HO,Contextwt_H);
     
 end;
 
 if abs(mean(err))< 0.00003
    break;
 end;
 
 clc;
 disp(itr);
 disp(abs(mean(err)));
 
 if(abs(mean(err))<abs(mean(min)))  % Minimum error copy
     min = err;
     temp1 = Wt_IH;
     temp2 = BiasWt_H;
     temp3 = BiasWt_O;
     temp4 = Wt_HO;
     temp5 = Contextwt_H;
     prev_val = Output(end,:);
 end;
 

end;
 disp(min);

    % Minimum error paste
     Wt_IH = temp1;
     BiasWt_H = temp2;
     BiasWt_O = temp3;
     Wt_HO = temp4;
     Contextwt_H = temp5;
 
 %% Prediction    
 pred_no = 10001;    
 N_Input = whyinput_data(1:pred_no,:);
 pred = predict(N_Input,No_of_Ip,No_of_Hidden,No_of_Op,Wt_IH,BiasWt_H,BiasWt_O,...
                            Wt_HO,Contextwt_H,pred_no);
 disp(pred(pred_no,1));
 
 %% Display
 
 hold all;
 plot(output_data(1:50:end,1));
 plot(pred(1:50:end,1));
f1 = figure();
plot(abs(pred(1:50:10000,1)-output_data(1:50:10000,1))/output_data(1:50:10000,1)); 
 
%Extrapolate
 pred_no = 15000;    
 N_Input = whyinput_data(1:pred_no,:);
 pred = predict(N_Input,No_of_Ip,No_of_Hidden,No_of_Op,Wt_IH,BiasWt_H,BiasWt_O,...
                            Wt_HO,Contextwt_H,pred_no);
f2 = figure();                        
plot(pred(1:50:end,1));

%Prediction accuracy

op = why_output_data(10001:50:15000);
f3 = figure();
hold 
plot(pred(10001:50:end,1));
plot(op(1:end));

pred1 = pred(10001:50:end,1);
disp(mean(minus(pred1,op).^2));
