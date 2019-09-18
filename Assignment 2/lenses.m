t=readtable('lenses.txt');

n_row=height(t);
n_col=width(t);

s=RandStream('mt19937ar','Seed',5);

ta=t;
for i=1:n_row 
    x=randperm(s,n_row); 
    ta(x(1,i),:)=t(i,:);
end
t=ta;

attributes=table2array(t(:,2:n_col-1));
classes=table2array(t(:,n_col));

[m,n]=size(attributes);

input_train=attributes(1:21,:);
input_test=attributes(22:n_row,:);
output_train=classes(1:21,1);
output_test=classes(22:n_row,1);

one=zeros([4,3]);
two=zeros([4,3]);
three=zeros([4,3]);

for i=1:max(size(input_train))
    for j=1:min(size(input_train))
        if output_train(i,1)==1
            one(j,input_train(i,j))=one(j,input_train(i,j))+1;
        end
        if output_train(i,1)==3
            three(j,input_train(i,j))=three(j,input_train(i,j))+1;
        end
        if output_train(i,1)==2
            two(j,input_train(i,j))=two(j,input_train(i,j))+1;
        end
    end
end

for i=1:4
    for j=1:3
        one(i,j)=1+one(i,j);
        two(i,j)=1+two(i,j);
        three(i,j)=1+three(i,j);
    end
end
class=zeros(1,min(size(input_test)):1);

for i=1:min(size(input_test))
    
    one_prob=1; 
    two_prob=1;
    three_prob=1;
    
    for j=1:max(size(input_test))
        one_prob=one_prob*( one(j,input_test(i,j)) / sum(one(j,:)) );
    end
    one_prob=one_prob*( sum(one(1,:)) / size(input_train,1) );
    for j=1:max(size(input_test))
        three_prob=three_prob*( three(j,input_test(i,j)) / sum(three(j,:)) );
    end
    three_prob=three_prob*( sum(three(1,:)) / size(input_train,1) );
    for j=1:max(size(input_test))
        two_prob=two_prob*( two(j,input_test(i,j)) / sum(two(j,:)) );
    end
    two_prob=two_prob*( sum(two(1,:)) / size(input_train,1) );
    
    if (two_prob>one_prob) && (two_prob>three_prob)
       class(i,1)=20; 
    end
    if (one_prob>two_prob) && (one_prob>three_prob)
       class(i,1)=10; 
    end
    if (three_prob>one_prob) && (three_prob>two_prob)
       class(i,1)=30; 
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
    if class(i,1)==30 && output_test(i,1)==3
        count=count+1;
    end
end

disp((count/max(size(output_test)))*100);



