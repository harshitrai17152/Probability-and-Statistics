load slump_test.txt
sum=0;

file=slump_test;
file=file(:,2:end);

file1=file(:,1:8);
r1=size(file1,1);
c1=size(file1,2);

for i=[1:r1]
    a1=file1(1:i-1,1:(c1-1));
    a2=file1(i+1:(r1-1),1:(c1-1));
    a=vertcat(a1,a2);
    
    b1=file1(1:i-1,c1);
    b2=file1(i+1:(r1-1),c1);
    b=vertcat(b1,b2);
    
    x=mldivide(a,b);
    y=file1(i,1:(c1-1))*x;
    error=(file1(i,c1)-y)^2;
    sum=sum+error;
end

disp(sum);


sum=0;

file2_1=file(:,1:7);
file2_2=file(:,9);
file2=horzcat(file2_1,file2_2);

r2=size(file2,1);
c2=size(file2,2);

for i=[1:r2]
    a1=file2(1:i-1,1:(c2-1));
    a2=file2(i+1:(r2-1),1:(c2-1));
    a=vertcat(a1,a2);
    
    b1=file2(1:i-1,c2);
    b2=file2(i+1:(r2-1),c2);
    b=vertcat(b1,b2);
    
    x=mldivide(a,b);
    y=file2(i,1:(c2-1))*x;
    error=(file2(i,c2)-y)^2;
    sum=sum+error;
end

disp(sum);


sum=0;

file3_1=file(:,1:7);
file3_2=file(:,10);
file3=horzcat(file3_1,file3_2);

r3=size(file3,1);
c3=size(file3,2);

for i=[1:r3]
    a1=file3(1:i-1,1:(c3-1));
    a2=file3(i+1:(r3-1),1:(c3-1));
    a=vertcat(a1,a2);
    
    b1=file3(1:i-1,c3);
    b2=file3(i+1:(r3-1),c3);
    b=vertcat(b1,b2);
    
    x=mldivide(a,b);
    y=file3(i,1:(c2-1))*x;
    error=(file3(i,c2)-y)^2;
    sum=sum+error;
end

disp(sum);






