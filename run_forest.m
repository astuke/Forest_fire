function run_forest()

    %The ignition probability
    p=0.55;
    %The maximum size of the fire. If the fire grows bigger than this,
    %the simulation is stopped.
    MaxFireSize=10000;
    %The number of fires we want to simulate. Try first with NFires=1, 
    %and increase it when you want to get the statistics.
    NFires=10;
    %If true, burn_forest will plot every time step and wait until the user
    %presses some key.
    DoPlot=1;
    
    fire_sizes=zeros(NFires,1);
    UsedSteps=zeros(NFires,1);
    
    for k=1:NFires
        
        fire_sizes(k)=burn_forest(p,MaxFireSize,DoPlot);
        k
        
    end
    
    %The following lines plot the cumulative distribution function. This
    %only makes sense if you use at least about NForests=1000.
    fs=1:(MaxFireSize);
    P=zeros(1,MaxFireSize);
    
    for k=1:length(fs)
       
        P(k)=sum(fire_sizes<=fs(k))/NFires;
        
    end
    
    hold on;
    figure(1);
    plot(fs,P);
    ylabel('P(N_{burned})');
    xlabel('N_{burned}');
    
end

%This function runs the simulation starting from one burning tree and
%ending when the number of burned trees is more than MaxSize or there are
%no burning trees left (i.e. the fire has ended). It returns the number of
%burned trees in the last configuration. If DoPlot is true, it plots the
%burning and burned trees at every iteration.
function fire_size=burn_forest(p,MaxSize,DoPlot)

    %The lists are implemented here as simply matrices of size
    %Nx2, where N is the number of trees in that list. The rows
    %of the matrix are then the coordinates of the trees expressed
    %as two integers.

    %Start with just the tree at the origin burning.
    burning_list=[0,0]; 
    %Initially there are no burned trees, so this is a 0x2 matrix.
    burned_list=zeros(0,2);
        
    if DoPlot
       figure;
    end
    
    while(1)
        [burning_list,burned_list]=burn_step(burned_list,burning_list,p);
        
        if DoPlot
            cla;
            hold on;
            plot(burning_list(:,1),burning_list(:,2),'r*'); % plot x and y coordinate in burning list
            plot(burned_list(:,1),burned_list(:,2),'b*');   % plot x and y coordinate in burned list
            pause;
        end
        
        %Check if the fire has stopped or if it has grown too big.
        if size(burning_list,1)==0 || size(burned_list,1)>MaxSize
           break; 
        end
    end
    
    fire_size=size(burned_list,1);
    
end

    %function I=is_in_burning_list(burning_list,N)
    


%This function should implement one time step of the simulation.
function [new_burning_list,new_burned_list]=burn_step(burned_list,burning_list,p)
    
    %Initially there are no trees in the new_burning_list.
    new_burning_list=zeros(0,2);
    
    
    %TODO: 
    
    %for all trees T in burning_list (looping through old burning trees)
    for i=1:size(burning_list,1)
        T=burning_list(i,:); % burning trees
        m=T(1);
        n=T(2);

    %
    %   for all neigbours N of T 
        for j=1:4
            arr = [[m+1,n];[m-1,n];[m,n+1];[m,n-1]];
            N = arr(j,:);
          
            
    %         I=sum(burning_list(:,1) == N(1) & burning_list(:,2) == N(2))% compare x and y coordinates of N vector and burn lists
    %         J=sum(burned_list(:,1) == N(1) & burned_list(:,2) == N(2))
    %
    %      if rand<p (check if the
    %      neighbours of old burning trees are successfully ignited) and if N is not yet in any of the lists (check that ignited trees are not in the old list of burning or burned trees)
                   if rand<p && not(is_in_list(new_burning_list,N)) && not(is_in_list(burning_list,N)) && not(is_in_list(burned_list,N))
                       
                      
    %           
    %              add N to new_burning_list
                   new_burning_list=[new_burning_list;N];
                   end
        
        end
    %
    end
    
    %The trees that were burning at the previous time step have now been
    %completely burned, so add them to the list of burned trees.
    new_burned_list=[burned_list;burning_list];
    N_burned=size(new_burned_list,1);
end



%This function checks if a given site is in the list. The site should be
%given in the form [x,y], and the list must be given so that its size is
%Nx2 and every row gives the coordinates of one tree. For example, if
%site=[0,1] and the list is [2,4;5,3;0,1;3,0], then is_in_list(list,site)
%returns a nonzero (true) value, because its third row is [0,1].
function I=is_in_list(list,site)

   if size(list,1)==0
      I=0;
      return;
   end

    I=sum(list(:,1) == site(1) & list(:,2) == site(2)); %compares the x and y coordinates of the site-vector and every column-vector in the list

end

