clear
clc
close all

%griewank
f = @(x,y) 1 + (x.^2 + y.^2)/4000 - cos(x).*cos(y./sqrt(2));
%Rastrigin
%f = @(x,y) 10*2 + x.^2 + y.^2 - 10*cos(2*pi*x) - 10*cos(2*pi*y);
%Sphere
%f = @(x,y) (x).^2 +(y).^2;

xl = [-5 -5]';
xu = [5 5]';

x_lim = linspace(-5,5,50); % límites para eje x, -5 es inferior, 5 es superior, con 50 puntos
y_lim = linspace(-5,5,50); % límites para eje y, -5 es inferior, 5 es superior, con 50 puntos
[X,Y] = meshgrid(x_lim,y_lim); % creamos una rejilla de puntos (x,y) para crear el plot
Z=f(X,Y);

G=150;
D=2;
N=50;
p=0.8; %probabilidad de polinizacion auto o no
lambda=0.5;
sigma2=(((gamma(1+lambda))/(lambda*gamma((1+lambda)/2)))*((sin((pi*lambda)/2))/(2^((lambda-1)/2))))^(1/lambda);

x=zeros(D,N);
fitness=zeros(1,N);
f_plot=zeros(1,G);

for i=1:N
    x(:,i)=xl+(xu-xl).*rand(D,1);
    fitness(i)=f(x(1,i),x(2,i));
end

for t=1:G
    [~ ,igb]=min(fitness);

    for i=1:N
        if rand()<p
            u=normrnd(0,sigma2,[D 1]);
            v=normrnd(0,1,[D 1]);
            L=u./(abs(v).^(1/lambda));
            y=x(:,i)+L.*(x(:,igb)-x(:,i));
        else
            rn=randperm(N,2);
            while ismember(i,rn)
                rn=randperm(N,2);
            end
            j=rn(1);
            k=rn(2);
            y=x(:,i)+rand()*(x(:,j)-x(:,k));
        end
        fy=f(y(1),y(2));
        
        if fy<fitness(i)
            x(:,i)=y;
            fitness(i)=fy;
        end
        
    end
     f_plot(t)=min(fitness);
end
f_plot(t)=min(fitness);
[~,igb]=min(fitness); 


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
plot(x(1, igb), x(2, igb), 'o', 'LineWidth',	2, 'MarkerSize', 10) % % plot del minimo encontrado
plot(x(1, igb), x(2, igb), 'x', 'LineWidth',	2, 'MarkerSize', 10) % % plot del minimo encontrado

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

plot3(x(1, igb), ...
    x(2, igb), ...
    f(x(1, igb),x(2, igb)), 'r*', 'LineWidth',	2, 'MarkerSize', 10) 


%la solucion se plotea en las coordenadas que resulten de la iteracion en
%el vector x0
legend({'función','óptimo'},'FontSize',15)

title('Gráfica en 3D','FontSize',15)
xlabel('x','FontSize',15)
ylabel('y','FontSize',15)
zlabel('f(x,y)','FontSize',15)
view([-20,60]) % estos valores definen la vista 3D del plot