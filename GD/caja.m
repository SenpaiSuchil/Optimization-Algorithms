clear
close all
clc

f=@(x) 400*x - 80*x.^2 + 4*x.^3;
fp=@(x) 400 -160*x+12*x.^2;
fpp=@(x) -160+24*x;
x=0:0.1:10;
xr=2;
N=10;

for i=1:N
    xr=xr-fp(xr)/fpp(xr);%newton raphson en ti confio
end

 %mostrar disp con resultados
if (fpp(xr)<=0)
    disp(["hay un maximo en x=" num2str(xr)])
else 
    disp([fpp(xr)])%mostrar disp con resultados
    disp(["es un minimo en x=" num2str(xr)])
end


figure%figure
hold on
grid on
plot(x, f(x), 'b-', 'LineWidth', 2)
plot(x, fp(x), 'r-', 'LineWidth', 2)
plot(x, fpp(x), 'g-', 'LineWidth', 2)
plot(xr, f(xr),'g*','LineWidth',2,'MarkerSize',12)
%plot(xr, fp(xr),'g*','LineWidth',2,'MarkerSize',12)
plot(xr, fpp(xr),'ro','LineWidth',2,'MarkerSize',12)
plot(xr, fp(xr),'ro','LineWidth',2,'MarkerSize',12)
legend({'función objetivo','fp(x)','fpp(x)', 'f(xr)', 'fpp(xr)'},'FontSize',10)
title('Problema de la caja','FontSize',10)
xlabel('x')
ylabel('f(x) fp(x) fpp(x)')