t=readtable('monks1.txt');

n_row=height(t);
n_col=width(t);

s=RandStream('mt19937ar','Seed',5);

ta=t;
for i=1:n_row 
    x=randperm(s,n_row); 
    ta(x(1,i),:)=t(i,:);
end
t=ta;

attributes1=table2array(t(:,2:n_col-1));
attributes2=table2array(t(:,n_col));
classes=table2array(t(:,1));

for i=1:n_row
    attributes2(i)={i};
end

attributes2=cell2mat(attributes2);
attributes=horzcat(attributes1,attributes2);

[m,n]=size(attributes);

input_train=attributes(1:387,:);
input_test=attributes(388:n_row,:);
output_train=classes(1:387,1);
output_test=classes(388:n_row,1);

zero=zeros([7,432]);
one=zeros([7,432]);

for i=1:max(size(input_train))
    for j=1:min(size(input_train))
        if output_train(i,1)==1
            one(j,input_train(i,j))=one(j,input_train(i,j))+1;
        end
        if output_train(i,1)==3
            zero(j,input_train(i,j))=zero(j,input_train(i,j))+1;
        end
    end
end

for i=1:7
    for j=1:432
        one(i,j)=1+one(i,j);
        zero(i,j)=1+zero(i,j);
    end
end
class=zeros(1,min(size(input_test)):1);

for i=1:max(size(input_test))
    
    zero_prob=1; 
    one_prob=1;
    
    for j=1:min(size(input_test))
        one_prob=one_prob*( one(j,input_test(i,j)) / sum(one(j,:)) );
    end
    one_prob=one_prob*( sum(one(1,:)) / size(input_train,1) );
    
    for j=1:min(size(input_test))
        zero_prob=zero_prob*( zero(j,input_test(i,j)) / sum(zero(j,:)) );
    end
    zero_prob=zero_prob*( sum(zero(1,:)) / size(input_train,1) );
    
    
    if (one_prob>zero_prob)
       class(i,1)=10; 
    end
    if (zero_prob>one_prob)
       class(i,1)=20; 
    end
end

count=0;

for i=1:max(size(output_test))
    if class(i,1)==10 && output_test(i,1)==1
        count=count+1;
    end
    if class(i,1)==20 && output_test(i,1)==2
        count=count+1;
    end
end

disp((count/max(size(output_test)))*100);



