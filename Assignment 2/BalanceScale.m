t=readtable('balance_scale.txt');

n_row=height(t);
n_col=width(t);

s=RandStream('mt19937ar','Seed',n_row);

ta=t;
for i=1:n_row 
    x=randperm(s,n_row); 
    ta(x(1,i),:)=t(i,:);
end
t=ta;

attributes=table2array(t(:,2:n_col));
classes=table2array(t(:,1));

[m,n]=size(attributes);

input_train=attributes(1:563,:);
input_test=attributes(564:n_row,:);
output_train=classes(1:563,1);
output_test=classes(564:n_row,1);

l=zeros([4,5]);
b=zeros([4,5]);
r=zeros([4,5]);

for i=1:max(size(input_train))
    for j=1:min(size(input_train))
        if strcmp(output_train(i,1),'B')
            b(j,input_train(i,j))=b(j,input_train(i,j))+1;
        end
        if strcmp(output_train(i,1),'R')
            r(j,input_train(i,j))=r(j,input_train(i,j))+1;
        end
        if strcmp(output_train(i,1),'L')
            l(j,input_train(i,j))=l(j,input_train(i,j))+1;
        end
    end
end

for i=1:4
    for j=1:5
        l(i,j)=1+l(i,j);
        b(i,j)=1+b(i,j);
        r(i,j)=1+r(i,j);
    end
end
class=zeros(1,max(size(input_test)):1);

for i=1:max(size(input_test))
    
    l_prob=1;
    b_prob=1;
    r_prob=1;
    
    for j=1:min(size(input_test))
        b_prob=b_prob*( b(j,input_test(i,j)) / sum(b(j,:)) );
    end
    b_prob=b_prob*( sum(b(1,:)) / size(input_train,1) );
    
    for j=1:min(size(input_test))
        r_prob=r_prob*( r(j,input_test(i,j)) / sum(r(j,:)) );
    end
    r_prob=r_prob*( sum(r(1,:)) / size(input_train,1) );
    
    for j=1:min(size(input_test))
        l_prob=l_prob*( l(j,input_test(i,j)) / sum(l(j,:)) );
    end
    l_prob=l_prob*( sum(l(1,:)) / size(input_train,1) );
    
    
    if (l_prob>b_prob) && (l_prob>r_prob)
       class(i,1)=10; 
    end
    if (b_prob>l_prob) && (b_prob>r_prob)
       class(i,1)=20; 
    end
    if (r_prob>b_prob) && (r_prob>l_prob)
       class(i,1)=30; 
    end
end

count=0;

for i=1:max(size(output_test))
    if class(i,1)==10 && strcmp(output_test(i,1),'L')
        count=count+1;
    end
    if class(i,1)==20 && strcmp(output_test(i,1),'B')
        count=count+1;
    end
    if class(i,1)==30 && strcmp(output_test(i,1),'R')
        count=count+1;
    end
end

disp((count/max(size(output_test)))*100);









