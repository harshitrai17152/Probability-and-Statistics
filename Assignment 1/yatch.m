load yacht_hydrodynamics.txt
sum=0;
r=size(yacht_hydrodynamics,1);
c=size(yacht_hydrodynamics,2);

for i=[1:r]
    a1=yacht_hydrodynamics(1:i-1,1:(c-1));
    a2=yacht_hydrodynamics(i+1:(r-1),1:(c-1));
    a=vertcat(a1,a2);
    
    b1=yacht_hydrodynamics(1:i-1,c);
    b2=yacht_hydrodynamics(i+1:(r-1),c);
    b=vertcat(b1,b2);
    
    x=mldivide(a,b);
    y=yacht_hydrodynamics(i,1:(c-1))*x;
    error=(yacht_hydrodynamics(i,c)-y)^2;
    sum=sum+error;
end

disp(sum);


















