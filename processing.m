% Importing data from a text file and processing them
% Created by Peter S Kaladius as of May 2020

data = importdata("d4jul20A.txt"); % Import the file "output.txt"
% Import data as a matrix and eliminate the first row, which does not have data
val = data.data(2:end,:);
% Measure the size of the data and determine how many measurements
M = size(val);
m = M(1); % no. of measurements


% ORDER: V4 V3 V5 V1 V6 V0 V7 V2; therefore, we use the following
% assignments to simplify things
V0 = 6; V1 = 4; V2 = 8; V3 = 2; V4 = 1; V5 = 3; V6 = 5; V7 = 7;
% Therefore, these are the voltages for 1st arm read (1st arm being Alpha)
a1 = val(:,V7)-val(:,V6); % A1's voltage is: V7-V6
a2 = val(:,V6)-val(:,V5); % A2's voltage is: V6-V5
a3 = val(:,V5)-val(:,V4); % A3's voltage is: V5-V4
a4 = val(:,V4)-val(:,V3); % A4's voltage is: V4-V3
a5 = val(:,V3)-val(:,V2); % A5's voltage is: V3-V2
a6 = val(:,V2)-val(:,V1); % A6's voltage is: V2-V1
a_I = (val(:,V1)-val(:,V0))/ 0.1 ; % (i.e; V = ir so i = V/R) where
% the shunt resistor = 0.1 Ohm
% The voltages for 2nd arm being Bravo Arm
b1 = val(:,V7+8)-val(:,V6+8); 
b2 = val(:,V6+8)-val(:,V5+8); 
b3 = val(:,V5+8)-val(:,V4+8); 
b4 = val(:,V4+8)-val(:,V3+8); 
b5 = val(:,V3+8)-val(:,V2+8); 
b6 = val(:,V2+8)-val(:,V1+8); 
b_I = (val(:,V1+8)-val(:,V0+8))/ 0.1 ;
% The voltages for 3rd arm being Charlie Arm
c1 = val(:,V7+16)-val(:,V6+16); 
c2 = val(:,V6+16)-val(:,V5+16); 
c3 = val(:,V5+16)-val(:,V4+16); 
c4 = val(:,V4+16)-val(:,V3+16); 
c5 = val(:,V3+16)-val(:,V2+16); 
c6 = val(:,V2+16)-val(:,V1+16); 
c_I = (val(:,V1+16)-val(:,V0+16))/ 0.1 ;
% The voltages for 4th arm being Delta Arm
d1 = val(:,V7+24)-val(:,V6+24); 
d2 = val(:,V6+24)-val(:,V5+24); 
d3 = val(:,V5+24)-val(:,V4+24); 
d4 = val(:,V4+24)-val(:,V3+24); 
d5 = val(:,V3+24)-val(:,V2+24); 
d6 = val(:,V2+24)-val(:,V1+24); 
d_I = (val(:,V1+24)-val(:,V0+24))/ 0.1 ;
% The voltages for 5th arm being Echo Arm
e1 = val(:,V7+32)-val(:,V6+32); 
e2 = val(:,V6+32)-val(:,V5+32); 
e3 = val(:,V5+32)-val(:,V4+32); 
e4 = val(:,V4+32)-val(:,V3+32); 
e5 = val(:,V3+32)-val(:,V2+32); 
e6 = val(:,V2+32)-val(:,V1+32); 
e_I = (val(:,V1+32)-val(:,V0+32))/ 0.1 ;
% The voltages for 6th arm being Foxtrot Arm
f1 = val(:,V7+40)-val(:,V6+40); 
f2 = val(:,V6+40)-val(:,V5+40); 
f3 = val(:,V5+40)-val(:,V4+40); 
f4 = val(:,V4+40)-val(:,V3+40); 
f5 = val(:,V3+40)-val(:,V2+40); 
f6 = val(:,V2+40)-val(:,V1+40); 
f_I = (val(:,V1+40)-val(:,V0+40))/ 0.1 ;
% The voltages for 7th arm being Golf Arm
g1 = val(:,V7+48)-val(:,V6+48); 
g2 = val(:,V6+48)-val(:,V5+48); 
g3 = val(:,V5+48)-val(:,V4+48); 
g4 = val(:,V4+48)-val(:,V3+48); 
g5 = val(:,V3+48)-val(:,V2+48); 
g6 = val(:,V2+48)-val(:,V1+48); 
g_I = (val(:,V1+48)-val(:,V0+48))/ 0.1 ;
% The voltages for 8th arm being Hotel Arm
h1 = val(:,V7+56)-val(:,V6+56); 
h2 = val(:,V6+56)-val(:,V5+56); 
h3 = val(:,V5+56)-val(:,V4+56); 
h4 = val(:,V4+56)-val(:,V3+56); 
h5 = val(:,V3+56)-val(:,V2+56); 
h6 = val(:,V2+56)-val(:,V1+56); 
h_I = (val(:,V1+56)-val(:,V0+56))/ 0.1 ;

x = 1:m; % creating an array with the length of the measurements
x = 0.5 *x; % Coverting that length to time (s) as there are 2
% measurements / second

figure(1) % Plotting voltages for Alpha Arm
plot(x,a1,x,a2,x,a3,x,a4,x,a5,x,a6)
title("Real-time battery voltages for Alpha Arm")
legend("A1 Batt","A2 Batt","A3 Batt","A4 Batt","A5 Batt","A6 Batt")
xlabel("Time (s)")
ylabel("Voltage (V)")
figure(2) % Plotting voltages for Bravo Arm
plot(x,b1,x,b2,x,b3,x,b4,x,b5,x,b6)
title("Real-time battery voltages for Bravo Arm")
legend("B1 Batt","B2 Batt","B3 Batt","B4 Batt","B5 Batt","B6 Batt")
xlabel("Time (s)")
ylabel("Voltage (V)")
figure(3) % Plotting voltages for Bravo Arm
plot(x,c1,x,c2,x,c3,x,c4,x,c5,x,c6)
title("Real-time battery voltages for Charlie Arm")
legend("C1 Batt","C2 Batt","C3 Batt","C4 Batt","C5 Batt","C6 Batt")
xlabel("Time (s)")
ylabel("Voltage (V)")
figure(4) % Plotting voltages for Delta Arm
plot(x,d1,x,d2,x,d3,x,d4,x,d5,x,d6)
title("Real-time battery voltages for Delta Arm")
legend("D1 Batt","D2 Batt","D3 Batt","D4 Batt","D5 Batt","D6 Batt")
xlabel("Time (s)")
ylabel("Voltage (V)")
figure(5) % Plotting voltages for Echo Arm
plot(x,e1,x,e2,x,e3,x,e4,x,e5,x,e6)
title("Real-time battery voltages for Echo Arm")
legend("E1 Batt","E2 Batt","E3 Batt","E4 Batt","E5 Batt","E6 Batt")
xlabel("Time (s)")
ylabel("Voltage (V)")
figure(6) % Plotting voltages for Foxtrot Arm
plot(x,f1,x,f2,x,f3,x,f4,x,f5,x,f6)
title("Real-time battery voltages for Foxtrot Arm")
legend("F1 Batt","F2 Batt","F3 Batt","F4 Batt","F5 Batt","F6 Batt")
xlabel("Time (s)")
ylabel("Voltage (V)")
figure(7) % Plotting voltages for Golf Arm
plot(x,g1,x,g2,x,g3,x,g4,x,g5,x,g6)
title("Real-time battery voltages for Golf Arm")
legend("G1 Batt","G2 Batt","G3 Batt","G4 Batt","G5 Batt","G6 Batt")
xlabel("Time (s)")
ylabel("Voltage (V)")
figure(8) % Plotting voltages for Hotel Arm
plot(x,h1,x,h2,x,h3,x,h4,x,h5,x,h6)
title("Real-time battery voltages for Hotel Arm")
legend("H1 Batt","H2 Batt","H3 Batt","H4 Batt","H5 Batt","H6 Batt")
xlabel("Time (s)")
ylabel("Voltage (V)")
figure(9) % Plotting currents all the 8 arms
plot(x,a_I,x,b_I,x,c_I,x,d_I,x,e_I,x,f_I,x,g_I,x,h_I)
title("Real-time current intensity for all 8 arms")
legend("A","B","C","D","E","F","G","H")
xlabel("Time (s)")
ylabel("Current Intensity (A)")

