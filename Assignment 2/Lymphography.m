t=readtable('lymphography.txt');


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

input_train=attributes(1:133,:);
input_test=attributes(134:n_row,:);
output_train=classes(1:133,1);
output_test=classes(134:n_row,1);

nfind=zeros([18,8]);
metastases=zeros([18,8]);
mlymph=zeros([18,8]);
fibrosis=zeros([18,8]);

for i=1:max(size(input_train))
    for j=1:min(size(input_train))
        if output_train(i,1)==1
            nfind(j,input_train(i,j))=nfind(j,input_train(i,j))+1;
        end
        if output_train(i,1)==2
            metastases(j,input_train(i,j))=metastases(j,input_train(i,j))+1;
        end
        if output_train(i,1)==3
            mlymph(j,input_train(i,j))=mlymph(j,input_train(i,j))+1;
        end
        if output_train(i,1)==4
            fibrosis(j,input_train(i,j))=fibrosis(j,input_train(i,j))+1;
        end
    end
end

for i=1:18
    for j=1:8
        nfind(i,j)=1+nfind(i,j);
        metastases(i,j)=1+metastases(i,j);
        mlymph(i,j)=1+mlymph(i,j);
        fibrosis(i,j)=1+fibrosis(i,j);
    end
end
class=zeros(1,min(size(input_test)):1);

for i=1:min(size(input_test))
    
    nfind_prob=1;
    metastases_prob=1;
    mlymph_prob=1;
    fibrosis_prob=1;
    
    for j=1:max(size(input_test))
        nfind_prob=nfind_prob*( nfind(j,input_test(i,j)) / sum(nfind(j,:)) );
    end
    nfind_prob=nfind_prob*( sum(nfind(1,:)) / size(input_train,1) );
    
    for j=1:max(size(input_test))
        metastases_prob=metastases_prob*( metastases(j,input_test(i,j)) / sum(metastases(j,:)) );
    end
    metastases_prob=metastases_prob*( sum(metastases(1,:)) / size(input_train,1) );
    
    for j=1:max(size(input_test))
        mlymph_prob=mlymph_prob*( mlymph(j,input_test(i,j)) / sum(mlymph(j,:)) );
    end
    mlymph_prob=mlymph_prob*( sum(mlymph(1,:)) / size(input_train,1) );
    
    for j=1:max(size(input_test))
        fibrosis_prob=fibrosis_prob*( fibrosis(j,input_test(i,j)) / sum(fibrosis(j,:)) );
    end
    fibrosis_prob=fibrosis_prob*( sum(fibrosis(1,:)) / size(input_train,1) );
    
    
    if (nfind_prob>metastases_prob) && (nfind_prob>fibrosis_prob) && (nfind_prob>mlymph_prob)
       class(i,1)=10; 
    end
    
    if (metastases_prob>fibrosis_prob) && (metastases_prob>nfind_prob) && (metastases_prob>mlymph_prob)
       class(i,1)=20; 
    end
    
    if (mlymph_prob>metastases_prob) && (mlymph_prob>nfind_prob) && (mlymph_prob>fibrosis_prob)
       class(i,1)=30; 
    end
    
    if (fibrosis_prob>metastases_prob) && (fibrosis_prob>nfind_prob) && (fibrosis_prob>mlymph_prob)
       class(i,1)=40; 
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
    if class(i,1)==40 && output_test(i,1)==4
        count=count+1;
    end
end

disp((count/max(size(output_test)))*100);




