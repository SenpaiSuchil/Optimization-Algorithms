clear
close all
clc

% f = @(x,y) x.*exp(-x.^2-y.^2);
% xl = [-2 -2]';
% xu = [2 2]';

f = @(x,y) (x-2).^2+(y-2).^2;
xl = [-5 -5]';
xu = [5 5]';


x_lim = linspace(-5,5,50); % límites para eje x, -5 es inferior, 5 es superior, con 50 puntos
y_lim = linspace(-5,5,50); % límites para eje y, -5 es inferior, 5 es superior, con 50 puntos
[X,Y] = meshgrid(x_lim,y_lim); % creamos una rejilla de puntos (x,y) para crear el plot
z=f(X,Y);

N = 50;
D = 2;
G = 100;
pm = 0.01;
fx= zeros(1,N);
f_plot = zeros(1,G);

x = zeros(D,N);
aptitud = zeros(1,N);
% Inicializacion
    for i=1:N
	    x(:,i) = xl+(xu-xl).*rand(D,1); 
    end

for g=1:G
    
    % Calculo de aptitud
    for i=1:N
	    fx(i)= f(x(1,i),x(2,i));
            
	    if fx(i) >= 0
            aptitud(i) = 1/(1+fx(1));
        else
            aptitud(i) = 1+abs(fx(1));
	    end
    end
    f_plot(g) = min(fx);
    y = zeros(D,N);
    for i=1:2:N
        % Seleccion
        r1 = Seleccion(aptitud);
        r2 = r1;
                
        while r1 == r2
	        r2 = Seleccion(aptitud);
        end
        
         
        p1 = x(:,r1);
        p2 = x(:,r2);
        %cruza
        pc = randi([1 D]);
            
        h1 = p1;
        h2 = p2;
        
        h1(pc:D) = p2(pc:D);
        h2(pc:D) = p1(pc:D);
             
        y(:,i) = h1;
        y(:,i+1) = h2;
    end   
    
    % Mutacion, la mutacion se aplica a los hijos y!
    for i=1:N
	    for j=1:D
            if rand()>pm
                y(j,i) = xl(j) + (xu(j) - xl(j))*rand();
            end
	    end
    end
 x = y;
end

for i=1:N
    fx(i) = f(x(1,i),x(2,i));
    
    if fx(i) >= 0
        aptitud(i) = 1/(1+fx(i));
    else
        aptitud(i) = 1 + abs(fx(i));
    end
end

[~,i_best] = min(fx);

figure
hold on
grid on

surf(X,Y,z) % plot de la rejilla en 3D

plot3(x(1, i_best), x(2, i_best), f(x(1, i_best),x(2, i_best)), 'r*', 'LineWidth',	2, 'MarkerSize', 10) 


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


contour(X,Y,z,20) % plot de la rejilla en 2D
plot(x(1, i_best), x(2, i_best), 'o', 'LineWidth',	2, 'MarkerSize', 10) % % plot del minimo encontrado
plot(x(1, i_best), x(2, i_best), 'x', 'LineWidth',	2, 'MarkerSize', 10) % % plot del minimo encontrado

%la solucion se plotea en las coordenadas que resulten de la iteracion en
%el vector x0 pero ahora en 2D
legend({'función','óptimo'},'FontSize',15)
title('Gráfica en 2D','FontSize',15)
xlabel('x','FontSize',15)
ylabel('y','FontSize',15)


figure
hold on
grid on

plot(f_plot,'b-','LineWidth',2);
title('Grafica de Convergencia');
xlabel('Iteracion');
ylabel('f(x)');


