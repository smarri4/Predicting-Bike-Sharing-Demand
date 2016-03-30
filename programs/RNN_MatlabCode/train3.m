function Error  = train3(gainp,input_data,output_data,No_of_Ip,No_of_Hidden,No_of_Op,No_of_Pat,lr)
%TRAIN Summary of this function goes here
%   Detailed explanation goes here
 
  	for i = 1: No_of_Hidden
        BiasWt_H(1,i) = gainp(1,i);
    end
     BiasWt_O(1,1) = gainp(1,i+1);
     c = i+2;
     for j=1:No_of_Hidden
        for i=1:No_of_Ip  
            Wt_IH(i,j) = gainp(1,c);
            c = c+1;
        end;
     end;
      for k = 1:No_of_Op
        for j = 1:No_of_Hidden
            Wt_HO(j,k) = gainp(1,c);
            c = c+1;
        end;
      end;
 
   for k = 1:No_of_Op
     Error(1,k) = 0.0 ;
   end
   for p = 1:No_of_Pat
    for j = 1:No_of_Hidden
        SumH(p,j) = BiasWt_H(j);
        for i = 1:No_of_Ip
            SumH(p,j) =SumH(p,j)+ input_data(p,i) * Wt_IH(i,j) ;
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
     end;
   end;
   
   Error = Error/No_of_Pat;
   


        

      