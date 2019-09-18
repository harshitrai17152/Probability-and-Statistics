t=readtable('adult+stretch.txt');

n_row=height(t);
n_col=width(t);

s=RandStream('mt19937ar','Seed',1);

ta=t;
for i=1:n_row 
    x=randperm(s,n_row); 
    ta(x(1,i),:)=t(i,:);
end
t=ta;

attributes=table2array(t(:,1:n_col-1));
classes=table2array(t(:,n_col));
new=zeros(20,4);

[m,n]=size(attributes);

for i=1:n_row
    for j=1:n_col-1
        if (strcmp(attributes(i,j),'YELLOW')==1)
           new(i,j)=1;
        end
        if (strcmp(attributes(i,j),'PURPLE')==1)
           new(i,j)=2;
        end
        if (strcmp(attributes(i,j),'SMALL')==1 )
           new(i,j)=1;
        end
        if (strcmp(attributes(i,j),'LARGE')==1)
           new(i,j)=2;
        end
        if (strcmp(attributes(i,j),'STRETCH')==1)
           new(i,j)=1;
        end
        if (strcmp(attributes(i,j),'DIP')==1)
           new(i,j)=2;
        end
        if (strcmp(attributes(i,j),'ADULT')==1)
           new(i,j)=1;
        end
        if (strcmp(attributes(i,j),'CHILD')==1)
           new(i,j)=2;
        end
    end
end

input_train=new(1:17,:);
input_test=new(18:n_row,:);
output_train=classes(1:17,1);
output_test=classes(18:n_row,1);

t=zeros([4,2]);
f=zeros([4,2]);

for i=1:max(size(input_train))
    for j=1:min(size(input_train))
        if strcmp(output_train(i,1),'T')
            t(j,input_train(i,j))=t(j,input_train(i,j))+1;
        end
        if strcmp(output_train(i,1),'F')
            f(j,input_train(i,j))=f(j,input_train(i,j))+1;
        end
    end
end

for i=1:4
    for j=1:2
        t(i,j)=1+t(i,j);
        f(i,j)=1+f(i,j);
    end
end
class=zeros(1,min(size(input_test)):1);

for i=1:min(size(input_test))
    
    t_prob=1;
    f_prob=1;
    
    for j=1:max(size(input_test))
        t_prob=t_prob*( t(j,input_test(i,j)) / sum(t(j,:)) );
    end
    t_prob=t_prob*( sum(t(1,:)) / size(input_train,1) );
    for j=1:min(size(input_test))
        f_prob=f_prob*( f(j,input_test(i,j)) / sum(f(j,:)) );
    end
   
    if (t_prob>f_prob)
       class(i,1)=10; 
    end
    if (f_prob>t_prob)
       class(i,1)=20; 
    end
end

count=0;

for i=1:max(size(output_test))
    if class(i,1)==10 && strcmp(output_test(i,1),'T') 
        count=count+1;
    end
    if class(i,1)==20 && strcmp(output_test(i,1),'F')
        count=count+1;
    end
end

disp((count/max(size(output_test)))*100);






