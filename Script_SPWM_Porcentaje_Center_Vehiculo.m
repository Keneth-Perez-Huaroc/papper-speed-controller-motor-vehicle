clear all;
clc;

Frecuencia_PWM=100000 %(Hertz, Número de pulsos generados en un segundo) Frecuencias aceptables 1000,2000,2500,4000,5000,*8000*,10000,*12500*,20000,*25000*,*40000*,*50000*,62500,*80000*,*100000* ya que generan periodos PWM decimales no periodicos como 166.666666... ya que generan tamaños de matrices diferentes
Frecuencia_Onda_Senoidal=50 %(Hertz, Número de ondas senoidales generadas en un segundo)
Periodo_PWM=1/Frecuencia_PWM % Duración de un Pulso en Segundos
Periodo_Onda_Senoidal=1/Frecuencia_Onda_Senoidal % Duración de un ciclo en Segundos
Pulsos_por_Ciclo=Periodo_Onda_Senoidal/Periodo_PWM % Número de pulsos pwm que caben en un ciclo senoidal


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%ONDAS SENOIDALES EN LA INDUSTRIA%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
syms tiempo;
Onda_Senoidal_A=1*sin(2*pi*Frecuencia_Onda_Senoidal*tiempo+0*pi/3);
Onda_Senoidal_B=1*sin(2*pi*Frecuencia_Onda_Senoidal*tiempo-2*pi/3);
Onda_Senoidal_C=1*sin(2*pi*Frecuencia_Onda_Senoidal*tiempo+2*pi/3);

figure (1);hold all;subplot(3,1,1); ezplot(Onda_Senoidal_A,[0 Periodo_Onda_Senoidal]);title('Onda_A=1*sin(2*pi*FrecuenciaOndaSenoidal*tiempo+0*pi/3)'); grid; xlabel('(tiempo del primer ciclo senoidal A)');ylabel('(amplitud de onda A)'); % Gráfica de la Onda A, desfasada en 0°
figure (1);hold all;subplot(3,1,2); ezplot(Onda_Senoidal_B,[0 Periodo_Onda_Senoidal]);title('Onda_B=1*sin(2*pi*FrecuenciaOndaSenoidal*tiempo-2*pi/3)'); grid; xlabel('(tiempo del primer ciclo senoidal B)');ylabel('(amplitud de onda B)'); % Gráfica de la Onda B, desfasada en 120°
figure (1);hold all;subplot(3,1,3); ezplot(Onda_Senoidal_C,[0 Periodo_Onda_Senoidal]);title('Onda_C=1*sin(2*pi*FrecuenciaOndaSenoidal*tiempo+2*pi/3)'); grid; xlabel('(tiempo del primer ciclo senoidal C)');ylabel('(amplitud de onda C)'); % Gráfica de la Onda C, desfasada en 240°

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%DIBUJANDO LAS DIVISIONES PWM POR CICLO SENOIDAL%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
linea_vertical=-1.5:0.2:1.5; %linea desde -1.5 hasta 1.5 en el eje y
for i=0:Periodo_PWM:Periodo_Onda_Senoidal; %Número de Divisiones de la Onda Senoidal
    tiempo_division=i*ones(1,length(linea_vertical));
    figure (1);hold all;subplot(3,1,1);plot(tiempo_division,linea_vertical,':'); %xlim([0 Periodo_Onda_Senoidal]);ylim([-1.5 1.5]);
    figure (1);hold all;subplot(3,1,2);plot(tiempo_division,linea_vertical,':'); %xlim([0 Periodo_Onda_Senoidal]);ylim([-1.5 1.5]);
    figure (1);hold all;subplot(3,1,3);plot(tiempo_division,linea_vertical,':'); %xlim([0 Periodo_Onda_Senoidal]);ylim([-1.5 1.5]);
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%PUNTOS X PARA OBTENER PORCENTAJES DE ANCHO DE PULSO%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
puntos_x=[];
for i=Periodo_PWM/2:Periodo_PWM:Periodo_Onda_Senoidal-Periodo_PWM/2
    puntos_x=[puntos_x;i];
end

% Graficar los puntos a evaluar en la onda para hallar el porcentaje el PWM en esa division
amplitudes_puntos_x_Onda_Senoidal_A = sin(2*pi*Frecuencia_Onda_Senoidal*puntos_x+0*pi/3); %Puntos y de la Onda A
amplitudes_puntos_x_Onda_Senoidal_B = sin(2*pi*Frecuencia_Onda_Senoidal*puntos_x-2*pi/3); %Puntos y de la Onda B
amplitudes_puntos_x_Onda_Senoidal_C = sin(2*pi*Frecuencia_Onda_Senoidal*puntos_x+2*pi/3); %Puntos y de la Onda C
figure (1);hold all;subplot(3,1,1);plot(puntos_x,amplitudes_puntos_x_Onda_Senoidal_A,'X') % Graficar los Puntos x de la Onda A
figure (1);hold all;subplot(3,1,2);plot(puntos_x,amplitudes_puntos_x_Onda_Senoidal_B,'X') % Graficar los Puntos x de la Onda B
figure (1);hold all;subplot(3,1,3);plot(puntos_x,amplitudes_puntos_x_Onda_Senoidal_C,'X') % Graficar los Puntos x de la Onda C

%Convertimos a porcentajes donde el 100% es 2, considerando q la ampiltud maxima esta determinada desde la comba negativa hasta la comba positiva de la onda senoidal
porcentajes_spwm_Onda_Senoidal_A=(1+amplitudes_puntos_x_Onda_Senoidal_A)*100/2; %se suma 1 para que no haya valores negativos y luego poder hallar el porcentanje
porcentajes_spwm_Onda_Senoidal_B=(1+amplitudes_puntos_x_Onda_Senoidal_B)*100/2; %se suma 1 para que no haya valores negativos y luego poder hallar el porcentanje
porcentajes_spwm_Onda_Senoidal_C=(1+amplitudes_puntos_x_Onda_Senoidal_C)*100/2; %se suma 1 para que no haya valores negativos y luego poder hallar el porcentanje

% Construimos los tiempos de On y off en microsegundos:
tiempos_ON_microsegundos_Onda_Senoidal_A=porcentajes_spwm_Onda_Senoidal_A/100*Periodo_PWM*1000000
tiempos_OFF_microsegundos_Onda_Senoidal_A=(Periodo_PWM-porcentajes_spwm_Onda_Senoidal_A/100*Periodo_PWM)*1000000
tiempos_ON_microsegundos_Onda_Senoidal_B=porcentajes_spwm_Onda_Senoidal_B/100*Periodo_PWM*1000000
tiempos_OFF_microsegundos_Onda_Senoidal_B=(Periodo_PWM-porcentajes_spwm_Onda_Senoidal_B/100*Periodo_PWM)*1000000
tiempos_ON_microsegundos_Onda_Senoidal_C=porcentajes_spwm_Onda_Senoidal_C/100*Periodo_PWM*1000000
tiempos_OFF_microsegundos_Onda_Senoidal_C=(Periodo_PWM-porcentajes_spwm_Onda_Senoidal_C/100*Periodo_PWM)*1000000

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Construcción de los pulsos SPWM para gráficarlos y exportarlos a arduino
tiempos_microsegundos_Onda_Senoidal_A_arduino=[];
tiempos_microsegundos_Onda_Senoidal_B_arduino=[];
tiempos_microsegundos_Onda_Senoidal_C_arduino=[];
for i=1:1:Pulsos_por_Ciclo
   tiempos_microsegundos_Onda_Senoidal_A_arduino=[tiempos_microsegundos_Onda_Senoidal_A_arduino;zeros(double(round(tiempos_OFF_microsegundos_Onda_Senoidal_A(i)/2)),1)];
   tiempos_microsegundos_Onda_Senoidal_A_arduino=[tiempos_microsegundos_Onda_Senoidal_A_arduino;ones(double(round(tiempos_ON_microsegundos_Onda_Senoidal_A(i))),1)];
   tiempos_microsegundos_Onda_Senoidal_A_arduino=[tiempos_microsegundos_Onda_Senoidal_A_arduino;zeros(double(round(tiempos_OFF_microsegundos_Onda_Senoidal_A(i)/2)),1)];
   
   tiempos_microsegundos_Onda_Senoidal_B_arduino=[tiempos_microsegundos_Onda_Senoidal_B_arduino;zeros(double(round(tiempos_OFF_microsegundos_Onda_Senoidal_B(i)/2)),1)];
   tiempos_microsegundos_Onda_Senoidal_B_arduino=[tiempos_microsegundos_Onda_Senoidal_B_arduino;ones(double(round(tiempos_ON_microsegundos_Onda_Senoidal_B(i))),1)];
   tiempos_microsegundos_Onda_Senoidal_B_arduino=[tiempos_microsegundos_Onda_Senoidal_B_arduino;zeros(double(round(tiempos_OFF_microsegundos_Onda_Senoidal_B(i)/2)),1)];
   
   tiempos_microsegundos_Onda_Senoidal_C_arduino=[tiempos_microsegundos_Onda_Senoidal_C_arduino;zeros(double(round(tiempos_OFF_microsegundos_Onda_Senoidal_C(i)/2)),1)];
   tiempos_microsegundos_Onda_Senoidal_C_arduino=[tiempos_microsegundos_Onda_Senoidal_C_arduino;ones(double(round(tiempos_ON_microsegundos_Onda_Senoidal_C(i))),1)];
   tiempos_microsegundos_Onda_Senoidal_C_arduino=[tiempos_microsegundos_Onda_Senoidal_C_arduino;zeros(double(round(tiempos_OFF_microsegundos_Onda_Senoidal_C(i)/2)),1)];
end

%sizematriz=min([length(tiempos_microsegundos_Onda_Senoidal_A_arduino),length(tiempos_microsegundos_Onda_Senoidal_B_arduino),length(tiempos_microsegundos_Onda_Senoidal_C_arduino)])
%tiempos_microsegundos_Onda_Senoidal_A_arduino=tiempos_microsegundos_Onda_Senoidal_A_arduino(1:sizematriz);
%tiempos_microsegundos_Onda_Senoidal_B_arduino=tiempos_microsegundos_Onda_Senoidal_B_arduino(1:sizematriz);
%tiempos_microsegundos_Onda_Senoidal_C_arduino=tiempos_microsegundos_Onda_Senoidal_C_arduino(1:sizematriz);

periodo_Onda_Senoidal_A_arduino=linspace(0,Periodo_Onda_Senoidal,length(tiempos_microsegundos_Onda_Senoidal_A_arduino));
periodo_Onda_Senoidal_B_arduino=linspace(0,Periodo_Onda_Senoidal,length(tiempos_microsegundos_Onda_Senoidal_B_arduino));
periodo_Onda_Senoidal_C_arduino=linspace(0,Periodo_Onda_Senoidal,length(tiempos_microsegundos_Onda_Senoidal_C_arduino));

figure(1);hold all;subplot(3,1,1);plot(periodo_Onda_Senoidal_A_arduino,tiempos_microsegundos_Onda_Senoidal_A_arduino,'k'); %xlim([0 Periodo_Onda_Senoidal]);ylim([-0.5 1.5]);
figure(1);hold all;subplot(3,1,2);plot(periodo_Onda_Senoidal_B_arduino,tiempos_microsegundos_Onda_Senoidal_B_arduino,'k'); %xlim([0 Periodo_Onda_Senoidal]);ylim([-0.5 1.5]);
figure(1);hold all;subplot(3,1,3);plot(periodo_Onda_Senoidal_C_arduino,tiempos_microsegundos_Onda_Senoidal_C_arduino,'k'); %xlim([0 Periodo_Onda_Senoidal]);ylim([-0.5 1.5]);

%Construyendo el string para exportar al arduino
matriz_tiempos_microsegundos_Onda_Senoidal_A_arduino1='{'; % Inicializamos la variable string
matriz_tiempos_microsegundos_Onda_Senoidal_B_arduino1='{'; % Inicializamos la variable string
matriz_tiempos_microsegundos_Onda_Senoidal_C_arduino1='{'; % Inicializamos la variable string

matriz_tiempos_microsegundos_Onda_Senoidal_A_arduino2='...'; % Inicializamos la variable string
matriz_tiempos_microsegundos_Onda_Senoidal_B_arduino2='...'; % Inicializamos la variable string
matriz_tiempos_microsegundos_Onda_Senoidal_C_arduino2='...'; % Inicializamos la variable string


for i=1:1:10000  %length(tiempos_OndaR_milisegundos_arduino) es siempre alrededor de 20000, para 50 Herzios
matriz_tiempos_microsegundos_Onda_Senoidal_A_arduino1=strcat(matriz_tiempos_microsegundos_Onda_Senoidal_A_arduino1,string(tiempos_microsegundos_Onda_Senoidal_A_arduino(i)),',');
end
for i=10001:1:length(tiempos_microsegundos_Onda_Senoidal_A_arduino)  %length(tiempos_OndaR_milisegundos_arduino) es siempre alrededor de 20000, para 50 Herzios
matriz_tiempos_microsegundos_Onda_Senoidal_A_arduino2=strcat(matriz_tiempos_microsegundos_Onda_Senoidal_A_arduino2,string(tiempos_microsegundos_Onda_Senoidal_A_arduino(i)),',');
end

for i=1:1:10000  %length(tiempos_OndaR_milisegundos_arduino) es siempre alrededor de 20000, para 50 Herzios
matriz_tiempos_microsegundos_Onda_Senoidal_B_arduino1=strcat(matriz_tiempos_microsegundos_Onda_Senoidal_B_arduino1,string(tiempos_microsegundos_Onda_Senoidal_B_arduino(i)),',');
end
for i=10001:1:length(tiempos_microsegundos_Onda_Senoidal_B_arduino)  %length(tiempos_OndaR_milisegundos_arduino) es siempre alrededor de 20000, para 50 Herzios
matriz_tiempos_microsegundos_Onda_Senoidal_B_arduino2=strcat(matriz_tiempos_microsegundos_Onda_Senoidal_B_arduino2,string(tiempos_microsegundos_Onda_Senoidal_B_arduino(i)),',');
end

for i=1:1:10000  %length(tiempos_OndaR_milisegundos_arduino) es siempre alrededor de 20000, para 50 Herzios
matriz_tiempos_microsegundos_Onda_Senoidal_C_arduino1=strcat(matriz_tiempos_microsegundos_Onda_Senoidal_C_arduino1,string(tiempos_microsegundos_Onda_Senoidal_C_arduino(i)),',');
end
for i=10001:1:length(tiempos_microsegundos_Onda_Senoidal_C_arduino)  %length(tiempos_OndaR_milisegundos_arduino) es siempre alrededor de 20000, para 50 Herzios
matriz_tiempos_microsegundos_Onda_Senoidal_C_arduino2=strcat(matriz_tiempos_microsegundos_Onda_Senoidal_C_arduino2,string(tiempos_microsegundos_Onda_Senoidal_C_arduino(i)),',');
end

matriz_tiempos_microsegundos_Onda_Senoidal_A_arduino1, matriz_tiempos_microsegundos_Onda_Senoidal_A_arduino2
matriz_tiempos_microsegundos_Onda_Senoidal_B_arduino1, matriz_tiempos_microsegundos_Onda_Senoidal_B_arduino2
matriz_tiempos_microsegundos_Onda_Senoidal_C_arduino1, matriz_tiempos_microsegundos_Onda_Senoidal_C_arduino2

% Graficar los Voltajes trifasicos resultantes

%%%%%%%%%DIBUJANDO LAS DIVISIONES PWM POR CICLO SENOIDAL%%%%%%%%%%%
linea_vertical=-1.5:0.2:1.5; %linea desde -1.5 hasta 1.5 en el eje y
for i=0:Periodo_PWM:Periodo_Onda_Senoidal; %Número de Divisiones de la Onda Senoidal
    tiempo_division=i*ones(1,length(linea_vertical));
    figure (2);hold all;subplot(3,1,1);plot(tiempo_division,linea_vertical,':'); %xlim([0 Periodo_Onda_Senoidal]);ylim([-1.5 1.5]);
    figure (2);hold all;subplot(3,1,2);plot(tiempo_division,linea_vertical,':'); %xlim([0 Periodo_Onda_Senoidal]);ylim([-1.5 1.5]);
    figure (2);hold all;subplot(3,1,3);plot(tiempo_division,linea_vertical,':'); %xlim([0 Periodo_Onda_Senoidal]);ylim([-1.5 1.5]);
    
    figure (3);hold all;subplot(3,1,1);plot(tiempo_division,linea_vertical,':'); %xlim([0 Periodo_Onda_Senoidal]);ylim([-1.5 1.5]);
    figure (3);hold all;subplot(3,1,2);plot(tiempo_division,linea_vertical,':'); %xlim([0 Periodo_Onda_Senoidal]);ylim([-1.5 1.5]);
    figure (3);hold all;subplot(3,1,3);plot(tiempo_division,linea_vertical,':'); %xlim([0 Periodo_Onda_Senoidal]);ylim([-1.5 1.5]);
    
    figure (4);hold all;subplot(3,1,1);plot(tiempo_division,linea_vertical,':'); %xlim([0 Periodo_Onda_Senoidal]);ylim([-1.5 1.5]);
    figure (4);hold all;subplot(3,1,2);plot(tiempo_division,linea_vertical,':'); %xlim([0 Periodo_Onda_Senoidal]);ylim([-1.5 1.5]);
    figure (4);hold all;subplot(3,1,3);plot(tiempo_division,linea_vertical,':'); %xlim([0 Periodo_Onda_Senoidal]);ylim([-1.5 1.5]);
    
    figure (5);hold all;subplot(3,1,1);plot(tiempo_division,linea_vertical,':'); %xlim([0 Periodo_Onda_Senoidal]);ylim([-1.5 1.5]);
    figure (5);hold all;subplot(3,1,2);plot(tiempo_division,linea_vertical,':'); %xlim([0 Periodo_Onda_Senoidal]);ylim([-1.5 1.5]);
    figure (5);hold all;subplot(3,1,3);plot(tiempo_division,linea_vertical,':'); %xlim([0 Periodo_Onda_Senoidal]);ylim([-1.5 1.5]);
end

% Representar Onda Senoidal PWM de salida retrasada en 60°
Onda_Senoidal_A_PWM=1*sin(2*pi*Frecuencia_Onda_Senoidal*tiempo+0*pi/3+pi/6);
Onda_Senoidal_B_PWM=1*sin(2*pi*Frecuencia_Onda_Senoidal*tiempo-2*pi/3+pi/6);
Onda_Senoidal_C_PWM=1*sin(2*pi*Frecuencia_Onda_Senoidal*tiempo+2*pi/3+pi/6);

%A-B
figure (2);hold all;subplot(3,1,1); ezplot(Onda_Senoidal_A,[0 Periodo_Onda_Senoidal]); grid; xlabel('(tiempo del primer ciclo senoidal A)');ylabel('(amplitud de onda A)'); % Gráfica de la Onda A, desfasada en 0°
figure (2);hold all;subplot(3,1,2); ezplot(Onda_Senoidal_B,[0 Periodo_Onda_Senoidal]); grid; xlabel('(tiempo del primer ciclo senoidal A)');ylabel('(amplitud de onda A)'); % Gráfica de la Onda A, desfasada en 0°
figure (2);hold all;subplot(3,1,3); ezplot(Onda_Senoidal_A_PWM,[0 Periodo_Onda_Senoidal]); grid; xlabel('(tiempo del primer ciclo senoidal A)');ylabel('(amplitud de onda A)'); % Gráfica de la Onda A, desfasada en 0°
hold all;
figure (2)
ax1 = subplot(3,1,1); ax2 = subplot(3,1,2); ax3 = subplot(3,1,3);
subplot(ax1);plot(periodo_Onda_Senoidal_A_arduino,tiempos_microsegundos_Onda_Senoidal_A_arduino);title('SPWM "A"');xlabel('Señal');ylabel('Tiempo');
subplot(ax2);plot(periodo_Onda_Senoidal_B_arduino,tiempos_microsegundos_Onda_Senoidal_B_arduino);title('SPWM "B"');xlabel('Señal');ylabel('Tiempo');
subplot(ax3);plot(periodo_Onda_Senoidal_C_arduino,tiempos_microsegundos_Onda_Senoidal_A_arduino-tiempos_microsegundos_Onda_Senoidal_B_arduino);title('SPWM "A" - SPWM "B"');xlabel('Señal');ylabel('Tiempo');

%C-A
figure (3);hold all;subplot(3,1,1); ezplot(Onda_Senoidal_C,[0 Periodo_Onda_Senoidal]); grid; xlabel('(tiempo del primer ciclo senoidal A)');ylabel('(amplitud de onda A)'); % Gráfica de la Onda A, desfasada en 0°
figure (3);hold all;subplot(3,1,2); ezplot(Onda_Senoidal_A,[0 Periodo_Onda_Senoidal]); grid; xlabel('(tiempo del primer ciclo senoidal A)');ylabel('(amplitud de onda A)'); % Gráfica de la Onda A, desfasada en 0°
figure (3);hold all;subplot(3,1,3); ezplot(Onda_Senoidal_C_PWM,[0 Periodo_Onda_Senoidal]); grid; xlabel('(tiempo del primer ciclo senoidal A)');ylabel('(amplitud de onda A)'); % Gráfica de la Onda A, desfasada en 0°
hold all;
figure (3)
ax1 = subplot(3,1,1); ax2 = subplot(3,1,2); ax3 = subplot(3,1,3);
subplot(ax1);plot(periodo_Onda_Senoidal_C_arduino,tiempos_microsegundos_Onda_Senoidal_C_arduino);title('SPWM "A"');xlabel('Señal');ylabel('Tiempo');
subplot(ax2);plot(periodo_Onda_Senoidal_A_arduino,tiempos_microsegundos_Onda_Senoidal_A_arduino);title('SPWM "C"');xlabel('Señal');ylabel('Tiempo');
subplot(ax3);plot(periodo_Onda_Senoidal_C_arduino,tiempos_microsegundos_Onda_Senoidal_C_arduino-tiempos_microsegundos_Onda_Senoidal_A_arduino);title('SPWM "C" - SPWM "A"');xlabel('Señal');ylabel('Tiempo');

%B-C
figure (4);hold all;subplot(3,1,1); ezplot(Onda_Senoidal_B,[0 Periodo_Onda_Senoidal]); grid; xlabel('(tiempo del primer ciclo senoidal A)');ylabel('(amplitud de onda A)'); % Gráfica de la Onda A, desfasada en 0°
figure (4);hold all;subplot(3,1,2); ezplot(Onda_Senoidal_C,[0 Periodo_Onda_Senoidal]); grid; xlabel('(tiempo del primer ciclo senoidal A)');ylabel('(amplitud de onda A)'); % Gráfica de la Onda A, desfasada en 0°
figure (4);hold all;subplot(3,1,3); ezplot(Onda_Senoidal_B_PWM,[0 Periodo_Onda_Senoidal]); grid; xlabel('(tiempo del primer ciclo senoidal A)');ylabel('(amplitud de onda A)'); % Gráfica de la Onda A, desfasada en 0°
hold all;
figure (4)
ax1 = subplot(3,1,1); ax2 = subplot(3,1,2); ax3 = subplot(3,1,3);
subplot(ax1);plot(periodo_Onda_Senoidal_B_arduino,tiempos_microsegundos_Onda_Senoidal_B_arduino);title('SPWM "B"');xlabel('Señal');ylabel('Tiempo');
subplot(ax2);plot(periodo_Onda_Senoidal_B_arduino,tiempos_microsegundos_Onda_Senoidal_C_arduino);title('SPWM "C"');xlabel('Señal');ylabel('Tiempo');
subplot(ax3);plot(periodo_Onda_Senoidal_B_arduino,tiempos_microsegundos_Onda_Senoidal_B_arduino-tiempos_microsegundos_Onda_Senoidal_C_arduino);title('SPWM "B" - SPWM "C"');xlabel('Señal');ylabel('Tiempo');


hold all;
figure (5);hold all;subplot(3,1,1); ezplot(Onda_Senoidal_A_PWM,[0 Periodo_Onda_Senoidal]); grid; xlabel('(tiempo del primer ciclo senoidal A)');ylabel('(amplitud de onda A)'); % Gráfica de la Onda A, desfasada en 0°
figure (5);hold all;subplot(3,1,3); ezplot(Onda_Senoidal_B_PWM,[0 Periodo_Onda_Senoidal]); grid; xlabel('(tiempo del primer ciclo senoidal B)');ylabel('(amplitud de onda B)'); % Gráfica de la Onda B, desfasada en 120°
figure (5);hold all;subplot(3,1,2); ezplot(Onda_Senoidal_C_PWM,[0 Periodo_Onda_Senoidal]); grid; xlabel('(tiempo del primer ciclo senoidal C)');ylabel('(amplitud de onda C)'); % Gráfica de la Onda C, desfasada en 240°

hold all;
figure (5)
ax1 = subplot(3,1,1); ax2 = subplot(3,1,2); ax3 = subplot(3,1,3);
subplot(ax1);plot(periodo_Onda_Senoidal_A_arduino,tiempos_microsegundos_Onda_Senoidal_A_arduino-tiempos_microsegundos_Onda_Senoidal_B_arduino,'k');title('SPWM "A" - SPWM "B"');xlabel('Señal');ylabel('Tiempo');xlim([0 Periodo_Onda_Senoidal]);ylim([-1.2 1.2]);
subplot(ax2);plot(periodo_Onda_Senoidal_B_arduino,tiempos_microsegundos_Onda_Senoidal_C_arduino-tiempos_microsegundos_Onda_Senoidal_A_arduino,'k');title('SPWM "C" - SPWM "A"');xlabel('Señal');ylabel('Tiempo');xlim([0 Periodo_Onda_Senoidal]);ylim([-1.2 1.2]);
subplot(ax3);plot(periodo_Onda_Senoidal_C_arduino,tiempos_microsegundos_Onda_Senoidal_B_arduino-tiempos_microsegundos_Onda_Senoidal_C_arduino,'k');title('SPWM "B" - SPWM "C"');xlabel('Señal');ylabel('Tiempo');xlim([0 Periodo_Onda_Senoidal]);ylim([-1.2 1.2]);

