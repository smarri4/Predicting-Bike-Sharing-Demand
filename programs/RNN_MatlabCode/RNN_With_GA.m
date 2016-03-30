
%%   Import the input and the output 
why_input_data = horzcat(season,yr,mnth,hr,holiday,weekday1,workingday,weathersit,temp,atemp,hum,windspeed);
input_data = why_input_data(1:1000,1:12);

why_output_data = horzcat(cnt);
output_data = why_output_data(1:1000,1);

%%  Initialize 

 x1 = size(input_data,1); %rows of input
 x2 = size(input_data,2); %cols of input
 
 y1 = size(output_data,1); %rows of output
 y2 = size(output_data,2);  %cols of output
 
 No_of_Ip = x2;
 No_of_Op = y2;   
 No_of_Hidden = ceil(((No_of_Ip + No_of_Op)/2));  % Hidden neurons
    
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
 
    Train_input_data =  input_data(1:1000,:);
     Train_output_data = output_data(1:1000,:);
     
    gainp{1} = BiasWt_H;
     gainp{2} = BiasWt_O;
     gainp{3} = Wt_IH;
     gainp{4} = Wt_HO;
     gainp{5} = Contextwt_H;
                              
    err = @(gainp)train(gainp,Train_input_data,Train_output_data,No_of_Ip,No_of_Hidden,No_of_Op,...
                                        size(Train_input_data,1),lr); 
    
    x = gaoptimset('TolFun',1e-5,'display','iter','Vectorized','off','PopulationSize',500,...
                            'Generations',1500);
    [x_ga_opt, err_ga] = ga(err,106,[],[],[],[],[],[],[],[],x);
                                         
   for i2 = 1: No_of_Hidden
        BiasWt_H(1,i2) = x_ga_opt(1,i2);
    end
     BiasWt_O(1,1) = x_ga_opt(1,i2+1);
     c = i2+2;
     for j2=1:No_of_Hidden
        for i2=1:No_of_Ip  
            Wt_IH(i2,j2) = x_ga_opt(1,c);
            c = c+1;
        end;
     end;
      for k2 = 1:No_of_Op
        for j2 = 1:No_of_Hidden
            Wt_HO(j2,k2) = x_ga_opt(1,c);
            c = c+1;
        end;
      end;
      
      for l3 = 1:No_of_Hidden
           Contextwt_H(l3,1) = x_ga_opt(1,c);
           c = c + 1;
      end;
      
    % Test
    Test_input_data =  why_input_data(1001:2000,:);
    Test_output_data = why_output_data(1001:2000,:);
     test_err = test(Test_input_data,Test_output_data,No_of_Ip,No_of_Hidden,No_of_Op,size(Test_input_data,1),...
      Wt_IH,BiasWt_H,BiasWt_O, Wt_HO,Contextwt_H);

 disp(abs(mean(test_err))); 
 
 %% Prediction    
 pred_no = 2001;    
 N_Input = why_input_data(1:pred_no,:);
 pred = predict2(N_Input,No_of_Ip,No_of_Hidden,No_of_Op,Wt_IH,BiasWt_H,BiasWt_O,...
                            Wt_HO,Contextwt_H,pred_no);
 disp(pred(pred_no,1));
 
 %% Display
 
 hold all;
 plot(output_data(1:10:1000,1));
 plot(pred(1:10:1000,1));
f1 = figure();


%Prediction accuracy
op = why_output_data(1001:10:2000);
f3 = figure;
hold 
plot(pred(1001:10:2000,1));
plot(op(1:end));

pred1 = pred(1:end,1);
disp(sqrt(mean(minus(pred1,op).^2)));
