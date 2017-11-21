function [ edge_set ] = TIGRE( graph, starting_node)
%UNTITLED7 Summary of this function goes here
%%%% Graph as incidence matrix and edge_set as output

%graph=graph';

number_of_nodes = size(graph,1)                    ;
number_of_edges= size(graph,2)                     ;

Edges_traversed =[];

edge_set=zeros(number_of_edges,1);


nodes_traversed(1)= starting_node;
entry_edge(1)= 0;

current_node= starting_node;

%current_node=4
%path_size=1;


exploration_over = 0;

k=1;

while exploration_over == 0,
 
  nodes_chrono(k)= current_node                                            ;

    %%% Extract incident edges

    graph(current_node,:);
    incident_edges = find( graph(current_node,:) ~= 0)                     ;
    choices = zeros(number_of_edges,1);
  
    %%% Find entry edge
    current_entry = entry_edge(  find(nodes_traversed == current_node) )   ;
  

    %%%% Remove edges traversed outwards
    filtered_choices=[];
    for i=1:length(incident_edges)
        query_edge = incident_edges(i)                                     ;
       
        nodes_in_edge = find (graph(:,incident_edges(:,i)) ~=0);
        connected_node(i) = nodes_in_edge ( find(nodes_in_edge ~= current_node) );
       
        edge_direction = graph(current_node,query_edge);%% Negative is outwards
        value_in_vector= edge_set(query_edge)                             ;
       
        switch edge_set(query_edge)
          case {0}
%            edge_has_NOT_been_traversed=1
            filtered_choices = [filtered_choices query_edge];
          case {2}
 %           edge_has_been_traversed_twice=1
          case {1}
            if(edge_direction == 1)
%              edge_has_ONLY_been_traversed_inward =1
              filtered_choices = [filtered_choices query_edge];
            else
%              edge_has_been_traversed_outward=1
            end
          case {-1}
            if(edge_direction == -1)
%              edge_has_ONLY_been_traversed_inward =1
              filtered_choices = [filtered_choices query_edge];
            else
%              edge_has_been_traversed_outward=1
            end
                       
          otherwise
              error ("invalid value");
        end
       %%%%%%%%%%%%%%%%%%%
       
    end
    filtered_choices                                                       ;
   
    if (  (length(filtered_choices)==0) || ( isempty(  find(edge_set == 0)  ) )  )
    %%%%%%%%%%% Exploration OVER %%%
        exploration_over=1;
        
        
        
        
        
    else         
      %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
      %%%%%%%%% NAVIGATION %%%%%%%%%%%%%%%%%%%%%%
     
      %%%%% Remove entry edge
      finder = find(filtered_choices == current_entry )                   ;
     
      filtered_choices (finder)=[]                                        ;
    
      %%%%%Choosing
      if (length(filtered_choices) == 0)
        %%%%% Traverse entry_edge
        edge_to_traverse = current_entry;
      else
        %%%%% Choose edge randomly
        random_index = ceil( length(filtered_choices )* rand() )          ;
        edge_to_traverse=filtered_choices(random_index);
      end
     
      edge_to_traverse                                                     ;
         
      %%%%%% Traversing
      next_index = find( graph(:,edge_to_traverse) ~= 0);
      next_node= next_index(find(next_index ~= current_node ))            ;
     
     
      current_node = next_node;
      is_node_present = find( nodes_traversed == current_node )           ;
     
      if isempty(is_node_present)
        nodes_traversed = [nodes_traversed next_node];
        entry_edge =[entry_edge edge_to_traverse];
      end 
%      nodes_traversed
     
     
      if edge_set (edge_to_traverse) == 0
        edge_set (edge_to_traverse) =graph(next_node, edge_to_traverse );
      else
        edge_set (edge_to_traverse) = 2;
      end
     
 %     edge_set'                                                         
         
   end
 
 
 %   graph(:,incident_edges)
%    find (graph(:,incident_edges) ~=0)
%     if k>50
%       exploration_over=1;
%     end
    k=k+1;
   
   
 %   pause
   
end

edge_set=abs(edge_set);



end


