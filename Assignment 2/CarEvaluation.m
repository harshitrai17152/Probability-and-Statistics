t=readtable('car.txt');

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
        if (strcmp(attributes(i,j),'vhigh')==1 && (j==1 || j==2))
           new(i,j)=1;
        end
        if (strcmp(attributes(i,j),'high')==1 && (j==1 || j==2))
           new(i,j)=2;
        end
        if (strcmp(attributes(i,j),'med')==1 && (j==1 || j==2))
           new(i,j)=3;
        end
        if (strcmp(attributes(i,j),'low')==1 && (j==1 || j==2))
           new(i,j)=4;
        end
        if (strcmp(attributes(i,j),'2')==1 && (j==3 || j==4))
           new(i,j)=1;
        end
        if (strcmp(attributes(i,j),'3')==1 && j==3)
           new(i,j)=2;
        end
        if (strcmp(attributes(i,j),'4')==1 && j==3)
           new(i,j)=3;
        end
        if (strcmp(attributes(i,j),'5more')==1 && j==3)
           new(i,j)=4;
        end
        if (strcmp(attributes(i,j),'4')==1 && j==4)
           new(i,j)=2;
        end
        if (strcmp(attributes(i,j),'more')==1 && j==4)
           new(i,j)=3;
        end
        if (strcmp(attributes(i,j),'small')==1 && j==5)
           new(i,j)=1;
        end
        if (strcmp(attributes(i,j),'med')==1 && j==5)
           new(i,j)=2;
        end
        if (strcmp(attributes(i,j),'big')==1 && j==5)
           new(i,j)=3;
        end
        if (strcmp(attributes(i,j),'low')==1 && j==6)
           new(i,j)=1;
        end
        if (strcmp(attributes(i,j),'med')==1 && j==6)
           new(i,j)=2;
        end
        if (strcmp(attributes(i,j),'high')==1 && j==6)
           new(i,j)=3;
        end
    end
end

input_train=new(1:1555,:);
input_test=new(1556:n_row-1,:);
output_train=classes(1:1555,1);
output_test=classes(1556:n_row-1,1);

unacc=zeros([6,4]);
acc=zeros([6,4]);
good=zeros([6,4]);
v_good=zeros([6,4]);

for i=1:max(size(input_train))
    for j=1:min(size(input_train))
        if strcmp(output_train(i,1),'unacc')
            unacc(j,input_train(i,j))=unacc(j,input_train(i,j))+1;
        end
        if strcmp(output_train(i,1),'acc')
            acc(j,input_train(i,j))=acc(j,input_train(i,j))+1;
        end
        if strcmp(output_train(i,1),'good')
            good(j,input_train(i,j))=good(j,input_train(i,j))+1;
        end
        if strcmp(output_train(i,1),'v_good')
            v_good(j,input_train(i,j))=v_good(j,input_train(i,j))+1;
        end
    end
end

for i=1:6
    for j=1:4
        unacc(i,j)=1+unacc(i,j);
        acc(i,j)=1+acc(i,j);
        good(i,j)=1+good(i,j);
        v_good(i,j)=1+v_good(i,j);
    end
end
class=zeros(1,max(size(input_test)):1);

for i=1:max(size(input_test))
    
    unacc_prob=1;
    acc_prob=1;
    good_prob=1;
    v_good_prob=1;
    
    for j=1:min(size(input_test))
        unacc_prob=unacc_prob*( unacc(j,input_test(i,j)) / sum(unacc(j,:)) );
    end
    unacc_prob=unacc_prob*( sum(unacc(1,:)) / size(input_train,1) );
    
    for j=1:min(size(input_test))
        acc_prob=acc_prob*( acc(j,input_test(i,j)) / sum(acc(j,:)) );
    end
    acc_prob=acc_prob*( sum(acc(1,:)) / size(input_train,1) );
    
    for j=1:min(size(input_test))
        good_prob=good_prob*( good(j,input_test(i,j)) / sum(good(j,:)) );
    end
    good_prob=good_prob*( sum(good(1,:)) / size(input_train,1) );
    
    for j=1:min(size(input_test))
        v_good_prob=v_good_prob*( v_good(j,input_test(i,j)) / sum(v_good(j,:)) );
    end
    v_good_prob=v_good_prob*( sum(v_good(1,:)) / size(input_train,1) );
    
    
    if (unacc_prob>acc_prob) && (unacc_prob>good_prob) && (unacc_prob>v_good_prob)
       class(i,1)=10; 
    end
    
    if (acc_prob>unacc_prob) && (acc_prob>good_prob) && (acc_prob>v_good_prob)
       class(i,1)=20; 
    end
    
    if (good_prob>acc_prob) && (good_prob>unacc_prob) && (good_prob>v_good_prob)
       class(i,1)=30; 
    end
    
    if (v_good_prob>acc_prob) && (v_good_prob>good_prob) && (v_good_prob>unacc_prob)
       class(i,1)=40; 
    end
    
end

count=0;

for i=1:max(size(output_test))
    if class(i,1)==10 && output_test(i,1)=="unacc"
        count=count+1;
    end
    if class(i,1)==20 && output_test(i,1)=="acc"
        count=count+1;
    end
    if class(i,1)==30 && output_test(i,1)=="good"
        count=count+1;
    end
    if class(i,1)==40 && output_test(i,1)=="v_good"
        count=count+1;
    end
end

disp((count/max(size(output_test)))*100);

   
   
   
