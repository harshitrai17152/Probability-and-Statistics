t=readtable('shuttle_landing_control.txt');

n_row=height(t);
n_col=width(t);

s=RandStream('mt19937ar','Seed',5);

ta=t;
for i=1:n_row 
    x=randperm(s,n_row); 
    ta(x(1,i),:)=t(i,:);
end
t=ta;

attributes1=table2array(t(:,2));
attributes2=table2array(t(:,3));
attributes3=table2array(t(:,4));
attributes4=table2array(t(:,5));
attributes5=table2array(t(:,6));
attributes6=table2array(t(:,7));
classes=table2array(t(:,1));

for i=1:n_row
    if attributes1(i,1)=="*"
        attributes1{i,1}='1';
    end
    if attributes2(i,1)=="*"
        attributes2{i,1}='1';
    end
    if attributes3(i,1)=="*"
        attributes3{i,1}='1';
    end
    if attributes4(i,1)=="*"
        attributes4{i,1}='1';
    end
    if attributes5(i,1)=="*"
        attributes5{i,1}='1';
    end
end

attributes1=cell2mat(attributes1);
attributes2=cell2mat(attributes2);
attributes3=cell2mat(attributes3);
attributes4=cell2mat(attributes4);
attributes5=cell2mat(attributes5);

for i=1:n_row
   attributes6(i,1)=num2str(attributes6(i,1));
end

attributes=horzcat(attributes1,attributes2);
attributes=horzcat(attributes,attributes3);
attributes=horzcat(attributes,attributes4);
attributes=horzcat(attributes,attributes5);
attributes=horzcat(attributes,attributes6);

[m,n]=size(attributes);

input_train=attributes(1:12,:);
input_test=attributes(13:n_row,:);
output_train=classes(1:12,1);
output_test=classes(13:n_row,1);

no_auto=zeros([6,4]);
auto=zeros([6,4]);

for i=1:max(size(input_train))
    for j=1:min(size(input_train))
        if output_train(i,1)==1
            no_auto(j,str2double(input_train(i,j)))=no_auto(j,str2double(input_train(i,j)))+1;
        end
        if output_train(i,1)==2
            auto(j,str2double(input_train(i,j)))=auto(j,str2double(input_train(i,j)))+1;
        end
    end
end

for i=1:6
    for j=1:4
        no_auto(i,j)=1+no_auto(i,j);
        auto(i,j)=1+auto(i,j);
    end
end
class=zeros(1,min(size(input_test)):1);

for i=1:min(size(input_test))
    
    no_auto_prob=1; 
    auto_prob=1;
    
    for j=1:max(size(input_test))
        no_auto_prob=no_auto_prob*( no_auto(j,str2double(input_test(i,j))) / sum(no_auto(j,:)) );
    end
    no_auto_prob=no_auto_prob*( sum(no_auto(1,:)) / size(input_train,1) );
    
    for j=1:max(size(input_test))
        auto_prob=auto_prob*( auto(j,str2double(input_test(i,j))) / sum(auto(j,:)) );
    end
    auto_prob=auto_prob*( sum(auto(1,:)) / size(input_train,1) );
    
    
    if (no_auto_prob>auto_prob)
       class(i,1)=10; 
    end
    if (auto_prob>no_auto_prob)
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









