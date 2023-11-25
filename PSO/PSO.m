clear
close all
clc


f = @(x,y) 10*2 + x.^2 + y.^2 - 10*cos(2*pi*x) - 10*cos(2*pi*y);  %Rastrigin
% f = @(x,y) (x).^2 +(y).^2;%Sphere
% f = @(x,y) (x+2*y-7).^2 +(2*x+y-5).^2; %booth function
xl = [-10 -10]';
xu = [10 10]';

x_lim = linspace(-5,5,50); % límites para eje x, -5 es inferior, 5 es superior, con 50 puntos
y_lim = linspace(-5,5,50); % límites para eje y, -5 es inferior, 5 es superior, con 50 puntos
[X,Y] = meshgrid(x_lim,y_lim); % creamos una rejilla de puntos (x,y) para crear el plot
Z=f(X,Y);

D=2;%dimension del problema
G=100;
N=50;

 
c1=3;% factores de aprendizaje cognitivos
c2=1;% c1 es el personal y c2 el social
w=0.6;%factor de inercia

x=zeros(D,N);% enjambre - mania_cardiaca(1).mp3
v=zeros(D,N);% velocidad de las particulas
xp=zeros(D,N);% x personal, el mejor movimiento personal de la particula
fitness=zeros(1,N);
f_plot=zeros(1,G);


for i=1:N %inicializacion
	    x(:,i) = xl+(xu-xl).*rand(D,1); 
        v(:,i)=randn(D,1);
        xp(:,i)=xp(:,i);
        fitness(i)=f(x(1,i),x(2,i));
end

for g=1:G

    for i=1:N
         fx= f(x(1,i),x(2,i));

         if fx<fitness(i)
            xp(:,i)=x(:,i);
            fitness(i)=fx;
         end
        
    end
    [f_plot(g), ig]=min(fitness);%ig es el mejor movimiento social de las particulas
    for i=1:N
        v(:,i)=w*v(:,i)+rand()*c1*(xp(:,i)-x(:,i))+ rand()*c2*(xp(:,ig)-x(:,i));
        x(:,i)=x(:,i)+v(:,i);
    end

end
[~,ig]=min(fitness);
figure
hold on
grid on

plot(f_plot,'b-','LineWidth',1);
title('Grafica de Convergencia');
xlabel('Iteracion');
ylabel('f(x)');

figure
hold on
grid on


contour(X,Y,Z,20) % plot de la rejilla en 2D
plot(x(1, ig), x(2, ig), 'o', 'LineWidth',	2, 'MarkerSize', 10) % % plot del minimo encontrado
plot(x(1, ig), x(2, ig), 'x', 'LineWidth',	2, 'MarkerSize', 10) % % plot del minimo encontrado

%la solucion se plotea en las coordenadas que resulten de la iteracion en
%el vector x0 pero ahora en 2D
legend({'función','óptimo'},'FontSize',15)
title('Gráfica en 2D','FontSize',15)
xlabel('x','FontSize',15)
ylabel('y','FontSize',15)

figure
hold on
grid on

surf(X,Y,Z) % plot de la rejilla en 3D

plot3(x(1, ig), ...
    x(2, ig), ...
    f(x(1, ig),x(2, ig)), 'r*', 'LineWidth',	2, 'MarkerSize', 10) 


%la solucion se plotea en las coordenadas que resulten de la iteracion en
%el vector x0
legend({'función','óptimo'},'FontSize',15)

title('Gráfica en 3D','FontSize',15)
xlabel('x','FontSize',15)
ylabel('y','FontSize',15)
zlabel('f(x,y)','FontSize',15)
view([-20,60]) % estos valores definen la vista 3D del plot


