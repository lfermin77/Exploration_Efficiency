function [ Euler_Value, Optimal_Value, TIGRE_Value] = Optimal_Statistics(Incidence_Matrices, p)
%UNTITLED3 Summary of this function goes here
%   Detailed explanation goes here

global current_p
current_p = p;

global current_Incidence

j=0;
Euler_Value=[];
Optimal_Value=[];
TIGRE_Value=[];


for i=1: length(Incidence_Matrices)
    current_Incidence = Incidence_Matrices{i}';
    number_of_edges= size(current_Incidence,2);
    approximation = ones(number_of_edges,1);

    current_p = -100;
    graph = i
    connected = -information_function_dynamic( approximation );
    current_p = p;
    
    if (connected< 1e-10)
        graph_is_not_connected =0
    else
        graph_is_connected=1
        j=j+1;
        
        %%%%%%%%% Calculate using every Edge
        Euler_Value(j) = -information_function_dynamic( approximation )/number_of_edges;
        
        %%%%%%%%% Calculate using TIGRE
        starting_node=1; % ceil(number_of_nodes*rand()  )
        TIGRE_edges = TIGRE( current_Incidence, starting_node);
        
        TIGRE_Value(j) = -information_function_dynamic( TIGRE_edges )/( sum(TIGRE_edges)  );
        
        
        %%%%%%% Calculate optimal
        x0=ones(number_of_edges,1)/(number_of_edges);
        A=[];
        b=[];
        Aeq = ones(number_of_edges,1)';
        beq = 1;
        lb=zeros(number_of_edges,1);
        ub= ones(number_of_edges,1);
        
        [edge_set,fval,exitflag,output,lambda,grad,hessian]= fmincon(@information_function_dynamic,x0,A,b,Aeq,beq,lb,ub);
        
        Optimal_Value(j) = -fval;
        %%%%%%%%%%%
       
        
        
        
        
    end
    
%    laplacian_size = size(Incidence_Matrices{i}' * Incidence_Matrices{i})


end

Number_of_graph_connected_is =j

Efficiency = Euler_Value./Optimal_Value;

Efficiency_average = sum(Efficiency )/length(Efficiency )
Efficiency_RMS = sqrt(sum( (Efficiency-Efficiency_average).^2 )/length(Efficiency ))

TIGRE_Efficiency = TIGRE_Value./Optimal_Value;

TIGRE_Efficiency_average = sum(TIGRE_Efficiency )/length(TIGRE_Efficiency )
TIGRE_Efficiency_RMS = sqrt(sum( (TIGRE_Efficiency-TIGRE_Efficiency_average).^2 )/length(TIGRE_Efficiency ))


% plot(Efficiency)
% hold on
% plot(TIGRE_Efficiency,'r')
% hold off
% axis([0 inf 0 1.1])
bar([Efficiency; TIGRE_Efficiency]')

end
