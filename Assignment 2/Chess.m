t=readtable('chess.txt');

n_row=height(t);
n_col=width(t);

s=RandStream('mt19937ar','Seed',n_row);

ta=t;
for i=1:n_row 
    x=randperm(s,n_row); 
    ta(x(1,i),:)=t(i,:);
end
t=ta;

attributes=table2array(t(:,1:n_col-1));
classes=table2array(t(:,n_col));

new=[n_row-1:n_col-1];
[m,n]=size(attributes);

for i=1:n_row-1
    for j=1:n_col-1
        if (strcmp(attributes(i,j),'f')==1 && (j==1 || j==2 || j==3 || j==4 || j==5 || j==6 || j==7 || j==8 || j==9 || j==10 || j==11 || j==12 || j==14 || j==16 || j==17 || j==18 || j==19 || j==20 || j==21 || j==22 || j==23 || j==24 || j==25 || j==26 || j==27 || j==28 || j==29 || j==30 || j==31 || j==32 || j==33 || j==34 || j==35 ))
           new(i,j)=1;
        end
        if (strcmp(attributes(i,j),'t')==1 && (j==1 || j==2 || j==3 || j==4 || j==5 || j==6 || j==7 || j==8 || j==9 || j==10 || j==11 || j==12 || j==14 || j==16 || j==17 || j==18 || j==19 || j==20 || j==21 || j==22 || j==23 || j==24 || j==25 || j==26 || j==27 || j==28 || j==29 || j==30 || j==31 || j==32 || j==33 || j==34 || j==35 || j==36))
           new(i,j)=2;
        end
        if (strcmp(attributes(i,j),'g')==1 && (j==13)) 
            new(i,j)=1;
        end
        if (strcmp(attributes(i,j),'l')==1 && (j==13)) 
            new(i,j)=2;
        end
        if (strcmp(attributes(i,j),'n')==1 && (j==36)) 
            new(i,j)=1;
        end
        if (strcmp(attributes(i,j),'n')==1 && (j==15)) 
            new(i,j)=2;
        end
        if (strcmp(attributes(i,j),'b')==1 && (j==15)) 
            new(i,j)=1;
        end
        if (strcmp(attributes(i,j),'w')==1 && (j==15)) 
            new(i,j)=3;
        end
    end
end

input_train=new(1:2875,:);
input_test=new(2876:n_row-1,:);
output_train=classes(1:2875,1);
output_test=classes(2876:n_row-1,1);

won=zeros([36,3]);
nowin=zeros([36,3]);

for i=1:max(size(input_train))
    for j=1:min(size(input_train))
        if strcmp(output_train(i,1),'won')
            won(j,input_train(i,j))=won(j,input_train(i,j))+1;
        end
        if strcmp(output_train(i,1),'nowin')
            nowin(j,input_train(i,j))=nowin(j,input_train(i,j))+1;
        end
    end
end

for i=1:36
    for j=1:3
        won(i,j)=1+won(i,j);
        nowin(i,j)=1+nowin(i,j);
    end
end
class=zeros(1,max(size(input_test)):1);

for i=1:max(size(input_test))
    
    won_prob=1;
    nowin_prob=1;
    
    for j=1:min(size(input_test))
        won_prob=won_prob*( won(j,input_test(i,j)) / sum(won(j,:)) );
    end
    won_prob=won_prob*( sum(won(1,:)) / size(input_train,1) );
    
    for j=1:min(size(input_test))
        nowin_prob=nowin_prob*( nowin(j,input_test(i,j)) / sum(nowin(j,:)) );
    end
    nowin_prob=nowin_prob*( sum(nowin(1,:)) / size(input_train,1) );
    
    
    if (won_prob>nowin_prob)
       class(i,1)=10; 
    end
    
    if (nowin_prob>won_prob)
       class(i,1)=20; 
    end 
end

count=0;

for i=1:max(size(output_test))
    if class(i,1)==10 && output_test(i,1)=="won"
        count=count+1;
    end
    if class(i,1)==20 && output_test(i,1)=="nowin"
        count=count+1;
    end
end

disp((count/max(size(output_test)))*100);








