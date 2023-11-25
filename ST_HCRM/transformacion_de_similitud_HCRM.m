clear
close all
clc

%% 
img_ref = imread("ref_2.png");
[H,W,~] = size(img_ref);

img_des = imread('des1.jpeg');
[h,w,~] = size(img_des);

[~,~,P] = readBarcode(img_ref,"QR-CODE");

%%
xr1 = P(1,:)';
xr2 = P(2,:)';
xr3 = P(3,:)';

x1 = [1 h]';
x2 = [1 1]';
x3 = [w 1]';

f = @(e1,e2, e3) (e1^2+e2^2+e3^2)/3;

% Parametros para optimizar
dx = 0;
dy = 0;
theta = 0;
s = 1.0;

q = [dx dy theta s]';
% Parametros para el HC
xl=[1 1 -pi 0]';
xu=[W H pi 10]';
N=10000;
D=4;
conv=zeros([1 N]);
% ayuda
for i=1:N
    y=q;
    j=randi([1 D]);
    y(j)=xl(j)+(xu(j)-xl(j)).*rand();

    %son con el arreglo q
    xp1 = Transformacion_Similitud(q,x1);
    xp2 = Transformacion_Similitud(q,x2);
    xp3 = Transformacion_Similitud(q,x3);

    e1 = Distancia_Euclidiana(xr1,xp1);
    e2 = Distancia_Euclidiana(xr2,xp2);
    e3 = Distancia_Euclidiana(xr3,xp3);

    %valores de y
    yp1 = Transformacion_Similitud(y,x1);
    yp2 = Transformacion_Similitud(y,x2);
    yp3 = Transformacion_Similitud(y,x3);

    y1 = Distancia_Euclidiana(xr1,yp1);
    y2 = Distancia_Euclidiana(xr2,yp2);
    y3 = Distancia_Euclidiana(xr3,yp3);

    if(f(y1, y2, y3)<f(e1,e2,e3))
        q=y;
    end
    conv(i)=f(e1,e2,e3);
    %la distancia euclediana deberia de dar 0 para quedar sobre el qr
end

img = Generar_Resultado(q,img_des,img_ref);
imshow(img)

figure
hold on
grid on
plot(conv,'LineWidth',1);
xlim([0 N]);
title("convergencia")



%% Funciones
function xp = Transformacion_Similitud (q,x)
    dx = q(1);
    dy = q(2);
    theta = q(3);
    s = q(4);
    
    xp = [s*cos(theta) -s*sin(theta); s*sin(theta) s*cos(theta)]*x + [dx dy]';
end

function e = Distancia_Euclidiana (xr,xp)
    e = sqrt((xr(1)-xp(1))^2+(xr(2)-xp(2))^2);
end

function img = Generar_Resultado (q,img_des,img_ref)
    dx = q(1);
    dy = q(2);
    theta = q(3);
    s = q(4);
    
    T = [s*cos(theta) -s*sin(theta) dx; s*sin(theta) s*cos(theta) dy; 0 0 1];
    Tp = projective2d(T');
    
    [N,M,~] = size(img_ref);
    [n,m,~] = size(img_des);

    panoramaView = imref2d([N M]);
    Iwarp = imwarp(img_des,Tp,'OutputView',panoramaView);
    Imask = imwarp(true(n,m),Tp,'OutputView',panoramaView);
    
    blender = vision.AlphaBlender('Operation','Binary mask','MaskSource','Input port');
    img = step(blender,img_ref,Iwarp,Imask);
end