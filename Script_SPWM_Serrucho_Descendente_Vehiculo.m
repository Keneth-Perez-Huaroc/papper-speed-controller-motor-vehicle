clear all;
clc;


Frecuencia_PWM=20000; % Pulsos en un segundo
Frecuencia_Voltaje=50; % Ciclos de Onda Senoidal en un Segundo
Periodo_PWM=1/Frecuencia_PWM; % Duración de un Pulso en Segundos
Periodo_Voltaje=1/Frecuencia_Voltaje; % Duración de un ciclo en Segundos
Pulsos_por_Ciclo=Periodo_Voltaje/Periodo_PWM; % Pulsos que 

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%ONDAS SENOIDALES EN LA INDUSTRIA%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
syms tiempo;
Onda_Voltaje_R=1*sin(2*pi*Frecuencia_Voltaje*tiempo); 
Onda_Voltaje_S=1*sin(2*pi*Frecuencia_Voltaje*tiempo+2*pi/3); 
Onda_Voltaje_T=1*sin(2*pi*Frecuencia_Voltaje*tiempo+4*pi/3); 

hold all;
figure (1), ezplot(Onda_Voltaje_R,[0 Periodo_Voltaje]); % Gráfica de la Onda R, desfasada en 0°
figure (1), ezplot(Onda_Voltaje_S,[0 Periodo_Voltaje]); % Gráfica de la Onda S, desfasada en 120°
figure (1), ezplot(Onda_Voltaje_T,[0 Periodo_Voltaje]); % Gráfica de la Onda T, desfasada en 240°

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%ANALISIS DE PULSOS EN LA ONDA%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%DIBUJANDO UNA SOLA ONDA PARA EL ANALISIS
figure (2), ezplot(Onda_Voltaje_R,[0,Periodo_Voltaje]);  %Grafica de una Onda Senoidal (R)
hold all;
figure (3), ezplot(Onda_Voltaje_S,[0,Periodo_Voltaje]);  %Grafica de una Onda Senoidal (S)
hold all;
figure (4), ezplot(Onda_Voltaje_T,[0,Periodo_Voltaje]);  %Grafica de una Onda Senoidal (T)
hold all;

%%%%%%DIBUJANDO LOS PULSOS TRIANGULARES POR CICLO SENOIDAL%%%%%%%%
%%PENDIENTE m1=(y2-y1)/(x2-x1) DE RECTA ASCENDENTE%%%
x1=0;y1=-1; %Primer punto de la recta ascendente
x2=Periodo_PWM/2;y2=1; %Segundo punto de la recta ascendente
m1=(y2-y1)/(x2-x1);
%%PENDIENTE m2=(y4-y3)/(x4-x3) DE RECTA DESCENDENTE%%%
x2=Periodo_PWM/2;y2=1; %Primer punto de la recta ascendente
x3=Periodo_PWM;y3=-1; %Segundo punto de la recta descendente
m2=(y3-y2)/(x3-x2);

%Para dibujar la recta solo se requiere un punto de la recta (eligiremos el punto en común que une a las 2 rectas, este punto (x,y) contiene a la variable Periodo_PWM para hallar un patron entre las rectas siguientes y tambien se utilizará la pendiente ya sea m1 ó m2
tiempos_OndaR_milisegundos=[];
tiempos_OndaS_milisegundos=[];
tiempos_OndaT_milisegundos=[];
for i=1:2:2*Pulsos_por_Ciclo %Se obtiene el doble de graficas de rectas por que es el doble de numero de graficas triangulares
x2_cambiante=x2*i;
Recta_ascendente_del_pulso_triangular=m1*(tiempo-x2_cambiante)+y2; %Ecuación de la recta 1: f(t)=m*(t-x1)+y1 usando el segundo punto (x2,y2)
Recta_descendente_del_pulso_triangular=m2*(tiempo-x2_cambiante)+y2; %Ecuación de la recta 2: f(t)=m*(t-x2)+y2 usando el segundo punto (x2,y2)
figure (2), ezplot(Recta_ascendente_del_pulso_triangular,[0,Periodo_Voltaje,-1,1]); % Gráfica de la recta ascendente
figure (2), ezplot(Recta_descendente_del_pulso_triangular,[0,Periodo_Voltaje,-1,1]); % Gráfica de la recta descendente

figure (3), ezplot(Recta_ascendente_del_pulso_triangular,[0,Periodo_Voltaje,-1,1]); % Gráfica de la recta ascendente
figure (3), ezplot(Recta_descendente_del_pulso_triangular,[0,Periodo_Voltaje,-1,1]); % Gráfica de la recta descendente

figure (4), ezplot(Recta_ascendente_del_pulso_triangular,[0,Periodo_Voltaje,-1,1]); % Gráfica de la recta ascendente
figure (4), ezplot(Recta_descendente_del_pulso_triangular,[0,Periodo_Voltaje,-1,1]); % Gráfica de la recta descendente

tiempos_OndaR_milisegundos=[tiempos_OndaR_milisegundos; solve(Recta_ascendente_del_pulso_triangular-Onda_Voltaje_R)*1000000]; %Intersección de recta ascendente en microsegundos
tiempos_OndaR_milisegundos=[tiempos_OndaR_milisegundos; solve(Recta_descendente_del_pulso_triangular-Onda_Voltaje_R)*1000000]; %Intersección de recta descendente en microsegundos

tiempos_OndaS_milisegundos=[tiempos_OndaS_milisegundos; solve(Recta_ascendente_del_pulso_triangular-Onda_Voltaje_S)*1000000]; %Intersección de recta ascendente en microsegundos
tiempos_OndaS_milisegundos=[tiempos_OndaS_milisegundos; solve(Recta_descendente_del_pulso_triangular-Onda_Voltaje_S)*1000000]; %Intersección de recta descendente en microsegundos

tiempos_OndaT_milisegundos=[tiempos_OndaT_milisegundos; solve(Recta_ascendente_del_pulso_triangular-Onda_Voltaje_T)*1000000]; %Intersección de recta ascendente en microsegundos
tiempos_OndaT_milisegundos=[tiempos_OndaT_milisegundos; solve(Recta_descendente_del_pulso_triangular-Onda_Voltaje_T)*1000000]; %Intersección de recta descendente en microsegundos

end

tiempos_OndaR_milisegundos=[0;tiempos_OndaR_milisegundos;Periodo_Voltaje*1000000] %En microsegundos,aumentamos los extremos del intervalo 0 y Tvoltaje, para encontrar todos los subperiodos de on y off
tiempos_OndaS_milisegundos=[0;tiempos_OndaS_milisegundos;Periodo_Voltaje*1000000] %En microsegundos,aumentamos los extremos del intervalo 0 y Tvoltaje, para encontrar todos los subperiodos de on y off
tiempos_OndaT_milisegundos=[0;tiempos_OndaT_milisegundos;Periodo_Voltaje*1000000] %En microsegundos,aumentamos los extremos del intervalo 0 y Tvoltaje, para encontrar todos los subperiodos de on y off

%Para generar una matriz de tiempos On y tiempos OFF agrupamos los datos de 2 en 2 y los restamos para obtener el intervalo de tiempo off y el tiempo on que sigue
% Extraemoslos tiempos de On
tiempos_OndaR_milisegundos_ON=[];
tiempos_OndaS_milisegundos_ON=[];
tiempos_OndaT_milisegundos_ON=[];
for i=2:2:length(tiempos_OndaR_milisegundos) %Agrupamos de 2 en 2 para restarlos y hallar el tiempo On
tiempos_OndaR_milisegundos_ON=[tiempos_OndaR_milisegundos_ON;tiempos_OndaR_milisegundos(i)-tiempos_OndaR_milisegundos(i-1)];
tiempos_OndaS_milisegundos_ON=[tiempos_OndaS_milisegundos_ON;tiempos_OndaS_milisegundos(i)-tiempos_OndaS_milisegundos(i-1)];
tiempos_OndaT_milisegundos_ON=[tiempos_OndaT_milisegundos_ON;tiempos_OndaT_milisegundos(i)-tiempos_OndaT_milisegundos(i-1)];
end

% Extraemoslos tiempos de Off
tiempos_OndaR_milisegundos_OFF=[];
tiempos_OndaS_milisegundos_OFF=[];
tiempos_OndaT_milisegundos_OFF=[];
for i=3:2:length(tiempos_OndaR_milisegundos) %Agrupamos de 2 en 2 para restarlos y hallar el tiempo off
tiempos_OndaR_milisegundos_OFF=[tiempos_OndaR_milisegundos_OFF;tiempos_OndaR_milisegundos(i)-tiempos_OndaR_milisegundos(i-1)];
tiempos_OndaS_milisegundos_OFF=[tiempos_OndaS_milisegundos_OFF;tiempos_OndaS_milisegundos(i)-tiempos_OndaS_milisegundos(i-1)];
tiempos_OndaT_milisegundos_OFF=[tiempos_OndaT_milisegundos_OFF;tiempos_OndaT_milisegundos(i)-tiempos_OndaT_milisegundos(i-1)];
end

%En el ciclo senoidal analizado debería haber el mismo numero de tiempos on y off, pero siempre habrá un tiempo on mas que el número de tiempos off
%Entonce para igualar el tamaño de ambas matrices, aumentamos un valor de 0 a la matriz tiempos_OndaR_milisegundos_OFF:
tiempos_OndaR_milisegundos_ON
tiempos_OndaR_milisegundos_OFF=[tiempos_OndaR_milisegundos_OFF;0]
tiempos_OndaS_milisegundos_ON
tiempos_OndaS_milisegundos_OFF=[tiempos_OndaS_milisegundos_OFF;0]
tiempos_OndaT_milisegundos_ON
tiempos_OndaT_milisegundos_OFF=[tiempos_OndaT_milisegundos_OFF;0]

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Construcción de los pulsos SPWM para gráficarlos y exportarlos a arduino
tiempos_OndaR_milisegundos_arduino=[];
tiempos_OndaS_milisegundos_arduino=[];
tiempos_OndaT_milisegundos_arduino=[];
for i=1:1:length(tiempos_OndaR_milisegundos_ON)
   tiempos_OndaR_milisegundos_arduino=[tiempos_OndaR_milisegundos_arduino;ones(double(round(tiempos_OndaR_milisegundos_ON(i))),1)];
   tiempos_OndaR_milisegundos_arduino=[tiempos_OndaR_milisegundos_arduino;zeros(double(round(tiempos_OndaR_milisegundos_OFF(i))),1)];
   
   tiempos_OndaS_milisegundos_arduino=[tiempos_OndaS_milisegundos_arduino;ones(double(round(tiempos_OndaS_milisegundos_ON(i))),1)];
   tiempos_OndaS_milisegundos_arduino=[tiempos_OndaS_milisegundos_arduino;zeros(double(round(tiempos_OndaS_milisegundos_OFF(i))),1)];
   
   tiempos_OndaT_milisegundos_arduino=[tiempos_OndaT_milisegundos_arduino;ones(double(round(tiempos_OndaT_milisegundos_ON(i))),1)];
   tiempos_OndaT_milisegundos_arduino=[tiempos_OndaT_milisegundos_arduino;zeros(double(round(tiempos_OndaT_milisegundos_OFF(i))),1)];
end

% Obtener el tamaño mas pequeño de las 3 matrices R S T
size_matriz_arduino=min([length(tiempos_OndaR_milisegundos_arduino),length(tiempos_OndaS_milisegundos_arduino),length(tiempos_OndaT_milisegundos_arduino)]) %tamaño menor para construir las 3 matrices de ceros y unos, las tres matrices del mismo tamaño
% Ajustar el mimo tamaño a las 3 matrices, para que tengan el tamaño mas pequeño las 3 matrices
tiempos_OndaR_milisegundos_arduino=tiempos_OndaR_milisegundos_arduino(1:size_matriz_arduino);
tiempos_OndaS_milisegundos_arduino=tiempos_OndaS_milisegundos_arduino(1:size_matriz_arduino);
tiempos_OndaT_milisegundos_arduino=tiempos_OndaT_milisegundos_arduino(1:size_matriz_arduino);

tiempos_spwm_r=linspace(0,Periodo_Voltaje,size_matriz_arduino);
figure(2), plot(tiempos_spwm_r,tiempos_OndaR_milisegundos_arduino)
tiempos_spwm_s=linspace(0,Periodo_Voltaje,size_matriz_arduino);
figure(3), plot(tiempos_spwm_s,tiempos_OndaS_milisegundos_arduino)
tiempos_spwm_t=linspace(0,Periodo_Voltaje,size_matriz_arduino);
figure(4), plot(tiempos_spwm_t,tiempos_OndaT_milisegundos_arduino)

%Construyendo el string para exportar al arduino
matriz_tiempos_OndaR_milisegundos_arduino1='{'; % Inicializamos la variable string
matriz_tiempos_OndaS_milisegundos_arduino1='{'; % Inicializamos la variable string
matriz_tiempos_OndaT_milisegundos_arduino1='{'; % Inicializamos la variable string

matriz_tiempos_OndaR_milisegundos_arduino2='...'; % Inicializamos la variable string
matriz_tiempos_OndaS_milisegundos_arduino2='...'; % Inicializamos la variable string
matriz_tiempos_OndaT_milisegundos_arduino2='...'; % Inicializamos la variable string


for i=1:1:10000  %length(tiempos_OndaR_milisegundos_arduino) es siempre alrededor de 20000, para 50 Herzios
matriz_tiempos_OndaR_milisegundos_arduino1=strcat(matriz_tiempos_OndaR_milisegundos_arduino1,string(tiempos_OndaR_milisegundos_arduino(i)),',');
end
for i=10001:1:size_matriz_arduino  %length(tiempos_OndaR_milisegundos_arduino) es siempre alrededor de 20000, para 50 Herzios
matriz_tiempos_OndaR_milisegundos_arduino2=strcat(matriz_tiempos_OndaR_milisegundos_arduino2,string(tiempos_OndaR_milisegundos_arduino(i)),',');
end

for i=1:1:10000  %length(tiempos_OndaR_milisegundos_arduino) es siempre alrededor de 20000, para 50 Herzios
matriz_tiempos_OndaS_milisegundos_arduino1=strcat(matriz_tiempos_OndaS_milisegundos_arduino1,string(tiempos_OndaS_milisegundos_arduino(i)),',');
end
for i=10001:1:size_matriz_arduino  %length(tiempos_OndaR_milisegundos_arduino) es siempre alrededor de 20000, para 50 Herzios
matriz_tiempos_OndaS_milisegundos_arduino2=strcat(matriz_tiempos_OndaS_milisegundos_arduino2,string(tiempos_OndaS_milisegundos_arduino(i)),',');
end

for i=1:1:10000  %length(tiempos_OndaR_milisegundos_arduino) es siempre alrededor de 20000, para 50 Herzios
matriz_tiempos_OndaT_milisegundos_arduino1=strcat(matriz_tiempos_OndaT_milisegundos_arduino1,string(tiempos_OndaT_milisegundos_arduino(i)),',');
end
for i=10001:1:size_matriz_arduino  %length(tiempos_OndaR_milisegundos_arduino) es siempre alrededor de 20000, para 50 Herzios
matriz_tiempos_OndaT_milisegundos_arduino2=strcat(matriz_tiempos_OndaT_milisegundos_arduino2,string(tiempos_OndaT_milisegundos_arduino(i)),',');
end

matriz_tiempos_OndaR_milisegundos_arduino1, matriz_tiempos_OndaR_milisegundos_arduino2
matriz_tiempos_OndaS_milisegundos_arduino1, matriz_tiempos_OndaS_milisegundos_arduino2
matriz_tiempos_OndaT_milisegundos_arduino1, matriz_tiempos_OndaT_milisegundos_arduino2


% Graficar los Voltajes trifasicos resultantes
tiempos_spwm_r=linspace(0,Periodo_Voltaje,size_matriz_arduino);
tiempos_spwm_s=linspace(0,Periodo_Voltaje,size_matriz_arduino);
tiempos_spwm_t=linspace(0,Periodo_Voltaje,size_matriz_arduino);

hold all;
figure (5)
ax1 = subplot(3,1,1);
ax2 = subplot(3,1,2);
ax3 = subplot(3,1,3);
subplot(ax1);plot(tiempos_spwm_r,tiempos_OndaR_milisegundos_arduino);title('Onda R');xlabel('Señal');ylabel('Tiempo');
subplot(ax2);plot(tiempos_spwm_s,tiempos_OndaS_milisegundos_arduino);title('Onda S');xlabel('Señal');ylabel('Tiempo');
subplot(ax3);plot(tiempos_spwm_t,tiempos_OndaR_milisegundos_arduino-tiempos_OndaS_milisegundos_arduino);title('Onda R - Onda S');xlabel('Señal');ylabel('Tiempo');

hold all;
figure (6)
ax1 = subplot(3,1,1);
ax2 = subplot(3,1,2);
ax3 = subplot(3,1,3);
subplot(ax1);plot(tiempos_spwm_r,tiempos_OndaR_milisegundos_arduino);title('Onda R');xlabel('Señal');ylabel('Tiempo');
subplot(ax2);plot(tiempos_spwm_s,tiempos_OndaT_milisegundos_arduino);title('Onda T');xlabel('Señal');ylabel('Tiempo');
subplot(ax3);plot(tiempos_spwm_t,tiempos_OndaR_milisegundos_arduino-tiempos_OndaT_milisegundos_arduino);title('Onda R - Onda T');xlabel('Señal');ylabel('Tiempo');


hold all;
figure (7)
ax1 = subplot(3,1,1);
ax2 = subplot(3,1,2);
ax3 = subplot(3,1,3);
subplot(ax1);plot(tiempos_spwm_r,tiempos_OndaS_milisegundos_arduino);title('Onda S');xlabel('Señal');ylabel('Tiempo');
subplot(ax2);plot(tiempos_spwm_s,tiempos_OndaT_milisegundos_arduino);title('Onda T');xlabel('Señal');ylabel('Tiempo');
subplot(ax3);plot(tiempos_spwm_t,tiempos_OndaS_milisegundos_arduino-tiempos_OndaT_milisegundos_arduino);title('Onda S - Onda T');xlabel('Señal');ylabel('Tiempo');

hold all;
figure (8)
ax1 = subplot(3,1,1);
ax2 = subplot(3,1,2);
ax3 = subplot(3,1,3);
subplot(ax1);plot(tiempos_spwm_r,tiempos_OndaR_milisegundos_arduino-tiempos_OndaS_milisegundos_arduino);title('Onda R - Onda S');xlabel('Señal');ylabel('Tiempo');
subplot(ax2);plot(tiempos_spwm_s,tiempos_OndaR_milisegundos_arduino-tiempos_OndaT_milisegundos_arduino);title('Onda R - Onda T');xlabel('Señal');ylabel('Tiempo');
subplot(ax3);plot(tiempos_spwm_t,tiempos_OndaS_milisegundos_arduino-tiempos_OndaT_milisegundos_arduino);title('Onda S - Onda T');xlabel('Señal');ylabel('Tiempo');