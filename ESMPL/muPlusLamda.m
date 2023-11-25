clear
close all
clc
%% inicialicacion y variables

% f = @(x,y) x.*exp(-x.^2-y.^2);
% xl = [-2 -2]';
% xu = [2 2]';

f = @(x,y) (x-2).^2+(y-2).^2;
xl = [-5 -5]';
xu = [5 5]';

x_lim = linspace(-5,5,50); % límites para eje x, -5 es inferior, 5 es superior, con 50 puntos
y_lim = linspace(-5,5,50); % límites para eje y, -5 es inferior, 5 es superior, con 50 puntos
[x0,y0] = meshgrid(x_lim,y_lim); % creamos una rejilla de puntos (x,y) para crear el plot

G = 1000;
D = 2;
mu = 50;
lamda=200;

x = zeros(D,mu+lamda);
y = zeros(D,mu+lamda);
sigma = zeros(D,mu+lamda);
fitness = zeros(1,mu+lamda);

fx_plot = zeros(1,G);

for i=1:mu
    x(:,i) = xl+(xu-xl).*rand(D,1);
    sigma(:,i) = 0.1*rand(D,1);
end

f_plot = zeros(1,G);

%% inicio de las generaciones

for g=1:G
%     Plot_Contour(f,x(:,1:mu),xl,xu);
    %aqui inicia el lambda
    for i=1:lamda
        r1 = randi([1 mu]);
        r2 = r1;
    
        while r2==r1
            r2 = randi([1 mu]);
        end
    
        y =(x(:,r1)+x(:,r2))/2;
        sigma_y = (sigma(:,r1)+sigma(:,r2))/2;
    
        r = normrnd(0,sigma_y);
        y = y + r;
    end
    %aqui finalizaria el lamda

    x(:,mu+lamda) = y;
    sigma(:,mu+lamda) = sigma_y;

    for i=1:mu+lamda
        fitness(i) = f(x(1,i),x(2,i));
    end
    
    [~,I] = sort(fitness);

    x = x(:,I);
    sigma = sigma(:,I);
    fitness = fitness(I);

    fx_plot(g) = fitness(1);
end
%% 
z=f(x0,y0);

figure
hold on
grid on
plot(fx_plot)

figure
hold on
grid on

contour(x0,y0,z,20) % plot de la rejilla en 2D
plot(x(1,1),x(2,1),'r*','LineWidth',2,'MarkerSize',10) % % plot del minimo encontrado
%la solucion se plotea en las coordenadas que resulten de la iteracion en
%el vector x0 pero ahora en 2D
legend({'función','óptimo'},'FontSize',15)

title('Gráfica en 2D','FontSize',15)
xlabel('x','FontSize',15)
ylabel('y','FontSize',15)
% figure
% Plot_Surf(f,x(:,1:mu),xl,xu) % Gráfica
% disp([' mínimo global en: x=' num2str(x(1,1)) ', y=' num2str(x(2,1)) ', f(x,y)=' num2str(f(x(1,1),x(2,1)))])

