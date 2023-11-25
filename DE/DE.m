clear
clc
close all


%griewank
%f = @(x,y) 1 + (x.^2 + y.^2)/4000 - cos(x).*cos(y./sqrt(2));

%Rastrigin
f = @(x,y) 10*2 + x.^2 + y.^2 - 10*cos(2*pi*x) - 10*cos(2*pi*y);

%Sphere
%f = @(x,y) (x).^2 +(y).^2;

xl = [-5 -5]';
xu = [5 5]';

x_lim = linspace(-5,5,50); % límites para eje x, -5 es inferior, 5 es superior, con 50 puntos
y_lim = linspace(-5,5,50); % límites para eje y, -5 es inferior, 5 es superior, con 50 puntos
[X,Y] = meshgrid(x_lim,y_lim); % creamos una rejilla de puntos (x,y) para crear el plot
Z=f(X,Y);


G=150;
N=50;
D=2;


F=1.2; %1.2 o 0.6
CR=0.6;%0.6 o 0.9

x=zeros(D,N);
fitness=zeros(1,N);

for i=1:N %inicializacion
	    x(:,i) = xl+(xu-xl).*rand(D,1); 
        fitness(i)=f(x(1,i),x(2,i));
end

f_plot=zeros(1,G);

for n=1:G
    for i=1:N
        %mutacion
        rn=randperm(N,3);
        while ismember(i,rn) 
            rn=randperm(N,3);
        end
        r1=rn(1);
        r2=rn(2);
        r3=rn(3);
    
        v=x(:,r1)+F*(x(:,r1)-x(:,r3));
        %recombinacion
        u=zeros(D,1);

        for j=1:D
            r=rand;
    
            if r<=CR
                u(j)=v(j);
            else
                u(j)=x(j,i);
            end
        end
    
        %seleccion
        fitness_u =f(u(1),u(2));
    
        if fitness_u < fitness(i)
            x(:,i)=u;
            fitness(i)=fitness_u;
        end
    end
    [f_plot(n)]=min(fitness);
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



figure
hold on
grid on

surf(X,Y,Z) % plot de la rejilla en 3D

plot3(x(1, ig),x(2, ig),f(x(1, ig),x(2, ig)), 'r*', 'LineWidth',	2, 'MarkerSize', 10) 


%la solucion se plotea en las coordenadas que resulten de la iteracion en
%el vector x0
legend({'función','óptimo'},'FontSize',15)

title('Gráfica en 3D','FontSize',15)
xlabel('x','FontSize',15)
ylabel('y','FontSize',15)
zlabel('f(x,y)','FontSize',15)
view([-20,60]) % estos valores definen la vista 3D del plot
