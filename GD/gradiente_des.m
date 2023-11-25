clear
close all
clc

 f = @(x,y) x.*exp(-x.^2-y.^2); % funcion objetivo
 fpx=@(x,y) exp(-x.^2-y.^2)-2*exp(-x.^2-y.^2)*x.^2;%derivada parcial con respecto de x
 fpy=@(x,y) (-2*exp(-x.^2-y.^2))*(x*y);%derivada parcial con respecto de y
%f = @(x,y) (x-2).^2+(y-2).^2; % funcion objetivo


x_lim = linspace(-5,5,50); % límites para eje x, -5 es inferior, 5 es superior, con 50 puntos
y_lim = linspace(-5,5,50); % límites para eje y, -5 es inferior, 5 es superior, con 50 puntos
[x,y] = meshgrid(x_lim,y_lim); % creamos una rejilla de puntos (x,y) para crear el plot

x0=[-1 -1]';%posicion inicial x y
h=0.1;%parametro de ajuste
xi=x0;
for i=1:500
    gradiente=[fpx(x0(1,1),x0(2,1)),fpy(x0(1,1), x0(2,1))]';%vector de derivadas parciales
    xi =xi-h*(gradiente); % evaluación de cada elemento en la rejilla para crear su valor en el eje z
    x0=xi;
end
z=f(x,y);
disp(["f(x,y)=" num2str(f(x0(1,1),x0(2,1)))])
disp(["x=" x0(1,1)])
disp(["y=" x0(2,1)])

figure
hold on
grid on

surf(x,y,z) % plot de la rejilla en 3D
plot3(x0(1,1),x0(2,1),f(x0(1,1),x0(2,1)),'r*','LineWidth',2,'MarkerSize',10) % plot del minimo encontrado
%la solucion se plotea en las coordenadas que resulten de la iteracion en
%el vector x0
legend({'función','óptimo'},'FontSize',15)

title('Gráfica en 3D','FontSize',15)
xlabel('x','FontSize',15)
ylabel('y','FontSize',15)
zlabel('f(x,y)','FontSize',15)
view([-20,60]) % estos valores definen la vista 3D del plot

figure
hold on
grid on

contour(x,y,z,20) % plot de la rejilla en 2D
plot(x0(1,1),x0(2,1),'r*','LineWidth',2,'MarkerSize',10) % % plot del minimo encontrado
%la solucion se plotea en las coordenadas que resulten de la iteracion en
%el vector x0 pero ahora en 2D
legend({'función','óptimo'},'FontSize',15)

title('Gráfica en 2D','FontSize',15)
xlabel('x','FontSize',15)
ylabel('y','FontSize',15)