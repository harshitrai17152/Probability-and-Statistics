file=xlsread('Concrete_Data.xlsx',1);
sum=0;
r=size(file,1);
c=size(file,2);

for i=[1:r]
    a1=file(1:i-1,1:(c-1));
    a2=file(i+1:(r-1),1:(c-1));
    a=vertcat(a1,a2);
    
    b1=file(1:i-1,c);
    b2=file(i+1:(r-1),c);
    b=vertcat(b1,b2);
    
    x=mldivide(a,b);
    y=file(i,1:(c-1))*x;
    error=(file(i,c)-y)^2;
    sum=sum+error;
end

disp(sum);
















