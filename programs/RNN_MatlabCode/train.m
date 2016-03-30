function [ BiasWt_H,BiasWt_O, Wt_IH,Wt_HO,Contextwt_H, Output ] = train(input_data,output_data,No_of_Ip,No_of_Hidden,No_of_Op,No_of_Pat,BiasWt_H,BiasWt_O, ...
                            Wt_IH,Wt_HO,Contextwt_H,lr)
%TRAIN Summary of this function goes here
%   Detailed explanation goes here

 %% Initialize      
   for k = 1:No_of_Op
     Error(1,k) = 0.0 ;
   end
   
   %% Feedforward 
   for p = 1:No_of_Pat
    for j = 1:No_of_Hidden
        SumH(p,j) = BiasWt_H(j);
        for i = 1:No_of_Ip
            SumH(p,j) =SumH(p,j)+ input_data(p,i) * Wt_IH(i,j) ;
        end;

        if p>1
            for con = 1 : No_of_Op
                SumH(p,j) = SumH(p,j) + Output(p-1,con) * Contextwt_H(j,con);
            end;
        end;

        Hidden_Op(p,j) = 1.0/(1.0 + exp(-SumH(p,j))) ;
    end;
    for k = 1:No_of_Op
        SumO(p,k) = BiasWt_O(k);
        for j = 1:No_of_Hidden
            SumO(p,k) =SumO(p,k)+ Hidden_Op(p,j) * Wt_HO(j,k) ;
        end;
        Output(p,k) = 1.0/(1.0 + exp(-SumO(p,k))) ;       
        Error = Error+ 0.5 * (output_data(p,k) - Output(p,k)) * (output_data(p,k) - Output(p,k)) ;   
        DeltaO(k) = (output_data(p,k) - Output(p,k)) * Output(p,k) * (1.0 - Output(p,k)) ;       
     end;
 %%  Backpropogate
 
     for j=1:No_of_Hidden
        SumDOW(j) = 0.0 ;
        for k = 1:No_of_Op
            SumDOW(j) =SumDOW(j)+ Wt_HO(j,k) * DeltaO(k) ;
        end;
        DeltaH(j) = SumDOW(j) * Hidden_Op(p,j) * (1.0 - Hidden_Op(p,j)) ;
     end;
     for j = 1:No_of_Hidden
        BiasWt_H(j) = BiasWt_H(j) + lr * DeltaH(j);
        for i = 1:No_of_Ip 
         DeltaWt_IH(i,j) = lr * input_data(p,i) * DeltaH(j) ;
         Wt_IH(i,j) =Wt_IH(i,j)+ DeltaWt_IH(i,j) ;
        end;
     end;
     
     
     for j = 1 :No_of_Hidden
        if p>1
            for con = 1:No_of_Op
                DeltaWt_ConH(j,con) = lr * Output(p-1,con) * DeltaH(j) ;
                Contextwt_H(j,con) = Contextwt_H(j,con)+ DeltaWt_ConH(j,con);
            end;
        end;
     end;
     
     for k = 1:No_of_Op
       BiasWt_O(k) = BiasWt_O(k) +  lr * DeltaO(k);
         for j = 1:No_of_Hidden
             DeltaWt_HO(j,k) = lr * Hidden_Op(p,j) * DeltaO(k);
             Wt_HO(j,k) =Wt_HO(j,k)+ DeltaWt_HO(j,k) ;
          end;
      end;
   end;
  



        

      