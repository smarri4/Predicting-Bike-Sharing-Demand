function [ err ] = test3(Test_Input,Test_Output,No_of_Ip,No_of_Hidden,No_of_Op,val,Wt_IH,BiasWt_H,BiasWt_O,...
                            Wt_HO)
%TEST Summary of this function goes here
%   Detailed explanation goes here

 for p = 1 : val
   for j = 1:No_of_Hidden
    SumH2(p,j) = BiasWt_H(j);
    for i = 1:No_of_Ip
        SumH2(p,j) =SumH2(p,j)+ Test_Input(p,i) * Wt_IH(i,j) ;
    end
    Hidden_Op2(p,j) = 1.0/(1.0 + exp(-SumH2(p,j))) ;
  end;
  for k = 1:No_of_Op
    SumO2(p,k) = BiasWt_O(k);
    for j = 1:No_of_Hidden
        SumO2(p,k) =SumO2(p,k)+ Hidden_Op2(p,j) * Wt_HO(j,k) ;
    end;
    Output2(p,k) = 1.0/(1.0 + exp(-SumO2(p,k))) ;          
  end;
 end;
    err = mean((minus(Output2,Test_Output)));
end
