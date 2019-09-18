load airfoil_self_noise.txt
sum=0;
r=size(airfoil_self_noise,1);
c=size(airfoil_self_noise,2);

for i=[1:r]
    a1=airfoil_self_noise(1:i-1,1:(c-1));
    a2=airfoil_self_noise(i+1:(r-1),1:(c-1));
    a=vertcat(a1,a2);
    
    b1=airfoil_self_noise(1:i-1,c);
    b2=airfoil_self_noise(i+1:(r-1),c);
    b=vertcat(b1,b2);
    
    x=mldivide(a,b);
    y=airfoil_self_noise(i,1:(c-1))*x;
    error=(airfoil_self_noise(i,c)-y)^2;
    sum=sum+error;
    
end

disp(sum);
    




