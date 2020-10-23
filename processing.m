
# conversion of processing code written by Peter S Kaladius 
# to python by Brandon Peek

# import libraries
import numpy as np
import matplotlib.pyplot as plt

file = 'd4jul20F.txt'
# Importing data from a text file and processing them
with open(file) as f:
    #determining number of columns from the first line of text
    cols = len(f.readline().split())
val = np.loadtxt(file,skiprows=1,usecols=np.arange(2, cols+1))
m = val.shape[0]


# Impulse response of the filter
IR = np.ones((5,)) / 5


# ORDER: V4 V3 V5 V1 V6 V0 V7 V2; therefore, we use the following
# assignments to simplify things
V0 = 5; V1 = 3; V2 = 7; V3 = 1; V4 = 0; V5 = 2; V6 = 4; V7 = 6

# Voltages for 1st arm read (1st arm being Alpha)
a1 = val[:,V7]-val[:,V6] # A1's voltage is: V7-V6
a2 = val[:,V6]-val[:,V5] # A2's voltage is: V6-V5
a3 = val[:,V5]-val[:,V4] # A3's voltage is: V5-V4
a4 = val[:,V4]-val[:,V3] # A4's voltage is: V4-V3
a5 = val[:,V3]-val[:,V2] # A5's voltage is: V3-V2
a6 = val[:,V2]-val[:,V1] # A6's voltage is: V2-V1
a_I = (val[:,V1]-val[:,V0])/ 0.1 # (i.e; V = ir so i = V/R) where the shunt resistor = 0.1 Ohm
# Convolving the sample for every battery to apply the average running filter
# Also truncating the convolved series to match the battery series
a1 = np.convolve(a1,IR)[:m]
a2 = np.convolve(a2,IR)[:m]
a3 = np.convolve(a3,IR)[:m]
a4 = np.convolve(a4,IR)[:m]
a5 = np.convolve(a5,IR)[:m]
a6 = np.convolve(a6,IR)[:m]
a_I = np.convolve(a_I,IR)[:m]

# Voltages for 2nd arm being Bravo Arm
b1 = val[:,V7+8]-val[:,V6+8]
b2 = val[:,V6+8]-val[:,V5+8]
b3 = val[:,V5+8]-val[:,V4+8]
b4 = val[:,V4+8]-val[:,V3+8]
b5 = val[:,V3+8]-val[:,V2+8]
b6 = val[:,V2+8]-val[:,V1+8]
b_I = (val[:,V1+8]-val[:,V0+8])/ 0.1
# Conolving and Truncating
b1 = np.convolve(b1,IR)[:m]
b2 = np.convolve(b2,IR)[:m]
b3 = np.convolve(b3,IR)[:m]
b4 = np.convolve(b4,IR)[:m]
b5 = np.convolve(b5,IR)[:m]
b6 = np.convolve(b6,IR)[:m]
b_I = np.convolve(b_I,IR)[:m]

# Voltages for 3rd arm being Charlie Arm
c1 = val[:,V7+16]-val[:,V6+16]
c2 = val[:,V6+16]-val[:,V5+16]
c3 = val[:,V5+16]-val[:,V4+16]
c4 = val[:,V4+16]-val[:,V3+16]
c5 = val[:,V3+16]-val[:,V2+16]
c6 = val[:,V2+16]-val[:,V1+16]
c_I = (val[:,V1+16]-val[:,V0+16])/ 0.1
# Conolving and Truncating
c1 = np.convolve(c1,IR)[:m]
c2 = np.convolve(c2,IR)[:m]
c3 = np.convolve(c3,IR)[:m]
c4 = np.convolve(c4,IR)[:m]
c5 = np.convolve(c5,IR)[:m]
c6 = np.convolve(c6,IR)[:m]
c_I = np.convolve(c_I,IR)[:m]

# Voltages for 4th arm being Delta Arm
d1 = val[:,V7+24]-val[:,V6+24]
d2 = val[:,V6+24]-val[:,V5+24]
d3 = val[:,V5+24]-val[:,V4+24]
d4 = val[:,V4+24]-val[:,V3+24]
d5 = val[:,V3+24]-val[:,V2+24]
d6 = val[:,V2+24]-val[:,V1+24]
d_I = (val[:,V1+24]-val[:,V0+24])/ 0.1
# Conolving and Truncating
d1 = np.convolve(d1,IR)[:m]
d2 = np.convolve(d2,IR)[:m]
d3 = np.convolve(d3,IR)[:m]
d4 = np.convolve(d4,IR)[:m]
d5 = np.convolve(d5,IR)[:m]
d6 = np.convolve(d6,IR)[:m]
d_I = np.convolve(d_I,IR)[:m]

# Voltages for 5th arm being Echo Arm
e1 = val[:,V7+32]-val[:,V6+32]
e2 = val[:,V6+32]-val[:,V5+32]
e3 = val[:,V5+32]-val[:,V4+32]
e4 = val[:,V4+32]-val[:,V3+32]
e5 = val[:,V3+32]-val[:,V2+32]
e6 = val[:,V2+32]-val[:,V1+32]
e_I = (val[:,V1+32]-val[:,V0+32])/ 0.1
# Conolving and Truncating
e1 = np.convolve(e1,IR)[:m]
e2 = np.convolve(e2,IR)[:m]
e3 = np.convolve(e3,IR)[:m]
e4 = np.convolve(e4,IR)[:m]
e5 = np.convolve(e5,IR)[:m]
e6 = np.convolve(e6,IR)[:m]
e_I = np.convolve(e_I,IR)[:m]

# Voltages for 6th arm being Foxtrot Arm
f1 = val[:,V7+40]-val[:,V6+40]
f2 = val[:,V6+40]-val[:,V5+40]
f3 = val[:,V5+40]-val[:,V4+40]
f4 = val[:,V4+40]-val[:,V3+40]
f5 = val[:,V3+40]-val[:,V2+40]
f6 = val[:,V2+40]-val[:,V1+40]
f_I = (val[:,V1+40]-val[:,V0+40])/ 0.1
# Conolving and Truncating
f1 = np.convolve(f1,IR)[:m]
f2 = np.convolve(f2,IR)[:m]
f3 = np.convolve(f3,IR)[:m]
f4 = np.convolve(f4,IR)[:m]
f5 = np.convolve(f5,IR)[:m]
f6 = np.convolve(f6,IR)[:m]
f_I = np.convolve(f_I,IR)[:m]

# Voltages for 6th arm being Golf Arm
g1 = val[:,V7+48]-val[:,V6+48]
g2 = val[:,V6+48]-val[:,V5+48]
g3 = val[:,V5+48]-val[:,V4+48]
g4 = val[:,V4+48]-val[:,V3+48]
g5 = val[:,V3+48]-val[:,V2+48]
g6 = val[:,V2+48]-val[:,V1+48]
g_I = (val[:,V1+48]-val[:,V0+48])/ 0.1
# Conolving and Truncating
g1 = np.convolve(g1,IR)[:m]
g2 = np.convolve(g2,IR)[:m]
g3 = np.convolve(g3,IR)[:m]
g4 = np.convolve(g4,IR)[:m]
g5 = np.convolve(g5,IR)[:m]
g6 = np.convolve(g6,IR)[:m]
g_I = np.convolve(g_I,IR)[:m]

# Voltages for 6th arm being Hotel Arm
h1 = val[:,V7+56]-val[:,V6+56]
h2 = val[:,V6+56]-val[:,V5+56]
h3 = val[:,V5+56]-val[:,V4+56]
h4 = val[:,V4+56]-val[:,V3+56]
h5 = val[:,V3+56]-val[:,V2+56]
h6 = val[:,V2+56]-val[:,V1+56]
h_I = (val[:,V1+56]-val[:,V0+56])/ 0.1
# Conolving and Truncating
h1 = np.convolve(h1,IR)[:m]
h2 = np.convolve(h2,IR)[:m]
h3 = np.convolve(h3,IR)[:m]
h4 = np.convolve(h4,IR)[:m]
h5 = np.convolve(h5,IR)[:m]
h6 = np.convolve(h6,IR)[:m]
h_I = np.convolve(h_I,IR)[:m]

# create time array
t = np.arange(0.5,(m/2)+0.5,0.5)


# plot all of the battery voltages against time
# create a figure and an axis
fig = plt.figure(1); ax = plt.subplot(111)
# plot the Alpha voltages against time
ax.plot(t,a1,label='A1 Batt',linewidth=0.5)
ax.plot(t,a2, label='A2 Batt',linewidth=0.5)
ax.plot(t,a3, label='A3 Batt',linewidth=0.5)
ax.plot(t,a4, label='A4 Batt',linewidth=0.5)
ax.plot(t,a5, label='A5 Batt',linewidth=0.5)
ax.plot(t,a6, label='A6 Batt',linewidth=0.5)
# define the limits on the shown data range
ax.autoscale_view()
# switch on grid lines
ax.grid(True)
# create a legend
ax.legend(loc='upper right',framealpha=1)
# label the axis
ax.set_title('Real-time battery voltages for Alpha Arm')
ax.set_xlabel('Time (s)')
ax.set_ylabel('Voltage (V)')

# create a figure and an axis
fig = plt.figure(2); ax = plt.subplot(111)
# plot the Bravo voltages against time
ax.plot(t,b1,label='B1 Batt',linewidth=0.5)
ax.plot(t,b2, label='B2 Batt',linewidth=0.5)
ax.plot(t,b3, label='B3 Batt',linewidth=0.5)
ax.plot(t,b4, label='B4 Batt',linewidth=0.5)
ax.plot(t,b5, label='B5 Batt',linewidth=0.5)
ax.plot(t,b6, label='B6 Batt',linewidth=0.5)
# define the limits on the shown data range
ax.autoscale_view()
# switch on grid lines
ax.grid(True)
# create a legend
ax.legend(loc='upper right',framealpha=1)
# label the axis
ax.set_title('Real-time battery voltages for Bravo Arm')
ax.set_xlabel('Time (s)')
ax.set_ylabel('Voltage (V)')

# create a figure and an axis
fig = plt.figure(3); ax = plt.subplot(111)
# plot the Charlie voltages against time
ax.plot(t,c1,label='C1 Batt',linewidth=0.5)
ax.plot(t,c2, label='C2 Batt',linewidth=0.5)
ax.plot(t,c3, label='C3 Batt',linewidth=0.5)
ax.plot(t,c4, label='C4 Batt',linewidth=0.5)
ax.plot(t,c5, label='C5 Batt',linewidth=0.5)
ax.plot(t,c6, label='C6 Batt',linewidth=0.5)
# define the limits on the shown data range
ax.autoscale_view()
# switch on grid lines
ax.grid(True)
# create a legend
ax.legend(loc='upper right',framealpha=1)
# label the axis
ax.set_title('Real-time battery voltages for Charlie Arm')
ax.set_xlabel('Time (s)')
ax.set_ylabel('Voltage (V)')

# create a figure and an axis
fig = plt.figure(4); ax = plt.subplot(111)
# plot the Delta voltages against time
ax.plot(t,d1,label='D1 Batt',linewidth=0.5)
ax.plot(t,d2, label='D2 Batt',linewidth=0.5)
ax.plot(t,d3, label='D3 Batt',linewidth=0.5)
ax.plot(t,d4, label='D4 Batt',linewidth=0.5)
ax.plot(t,d5, label='D5 Batt',linewidth=0.5)
ax.plot(t,d6, label='D6 Batt',linewidth=0.5)
# define the limits on the shown data range
ax.autoscale_view()
# switch on grid lines
ax.grid(True)
# create a legend
ax.legend(loc='upper right',framealpha=1)
# label the axis
ax.set_title('Real-time battery voltages for Delta Arm')
ax.set_xlabel('Time (s)')
ax.set_ylabel('Voltage (V)')

# create a figure and an axis
fig = plt.figure(5); ax = plt.subplot(111)
# plot the Echo voltages against time
ax.plot(t,e1,label='E1 Batt',linewidth=0.5)
ax.plot(t,e2, label='E2 Batt',linewidth=0.5)
ax.plot(t,e3, label='E3 Batt',linewidth=0.5)
ax.plot(t,e4, label='E4 Batt',linewidth=0.5)
ax.plot(t,e5, label='E5 Batt',linewidth=0.5)
ax.plot(t,e6, label='E6 Batt',linewidth=0.5)
# define the limits on the shown data range
ax.autoscale_view()
# switch on grid lines
ax.grid(True)
# create a legend
ax.legend(loc='upper right',framealpha=1)
# label the axis
ax.set_title('Real-time battery voltages for Echo Arm')
ax.set_xlabel('Time (s)')
ax.set_ylabel('Voltage (V)')

# create a figure and an axis
fig = plt.figure(6); ax = plt.subplot(111)
# plot the Foxtrot voltages against time
ax.plot(t,f1,label='F1 Batt',linewidth=0.5)
ax.plot(t,f2, label='F2 Batt',linewidth=0.5)
ax.plot(t,f3, label='F3 Batt',linewidth=0.5)
ax.plot(t,f4, label='F4 Batt',linewidth=0.5)
ax.plot(t,f5, label='F5 Batt',linewidth=0.5)
ax.plot(t,f6, label='F6 Batt',linewidth=0.5)
# define the limits on the shown data range
ax.autoscale_view()
# switch on grid lines
ax.grid(True)
# create a legend
ax.legend(loc='upper right',framealpha=1)
# label the axis
ax.set_title('Real-time battery voltages for Foxtrot Arm')
ax.set_xlabel('Time (s)')
ax.set_ylabel('Voltage (V)')

# create a figure and an axis
fig = plt.figure(7); ax = plt.subplot(111)
# plot the Golf voltages against time
ax.plot(t,g1,label='G1 Batt',linewidth=0.5)
ax.plot(t,g2, label='G2 Batt',linewidth=0.5)
ax.plot(t,g3, label='G3 Batt',linewidth=0.5)
ax.plot(t,g4, label='G4 Batt',linewidth=0.5)
ax.plot(t,g5, label='G5 Batt',linewidth=0.5)
ax.plot(t,g6, label='G6 Batt',linewidth=0.5)
# define the limits on the shown data range
ax.autoscale_view()
# switch on grid lines
ax.grid(True)
# create a legend
ax.legend(loc='upper right',framealpha=1)
# label the axis
ax.set_title('Real-time battery voltages for Golf Arm')
ax.set_xlabel('Time (s)')
ax.set_ylabel('Voltage (V)')

# create a figure and an axis
fig = plt.figure(8); ax = plt.subplot(111)
# plot the Hotel voltages against time
ax.plot(t,h1,label='H1 Batt',linewidth=0.5)
ax.plot(t,h2, label='H2 Batt',linewidth=0.5)
ax.plot(t,h3, label='H3 Batt',linewidth=0.5)
ax.plot(t,h4, label='H4 Batt',linewidth=0.5)
ax.plot(t,h5, label='H5 Batt',linewidth=0.5)
ax.plot(t,h6, label='H6 Batt',linewidth=0.5)
# define the limits on the shown data range
ax.autoscale_view()
# switch on grid lines
ax.grid(True)
# create a legend
ax.legend(loc='upper right',framealpha=1)
# label the axis
ax.set_title('Real-time battery voltages for Hotel Arm')
ax.set_xlabel('Time (s)')
ax.set_ylabel('Voltage (V)')

# create a figure and an axis
fig = plt.figure(9); ax = plt.subplot(111)
# plot the alpha voltages against time
ax.plot(t,a_I,label='A',linewidth=0.5)
ax.plot(t,b_I, label='B',linewidth=0.5)
ax.plot(t,c_I, label='C',linewidth=0.5)
ax.plot(t,d_I, label='D',linewidth=0.5)
ax.plot(t,e_I, label='E',linewidth=0.5)
ax.plot(t,f_I, label='F',linewidth=0.5)
ax.plot(t,g_I, label='G',linewidth=0.5)
ax.plot(t,h_I, label='H',linewidth=0.5)
# define the limits on the shown data range
ax.autoscale_view()
# switch on grid lines
ax.grid(True)
# create a legend
ax.legend(loc='upper right',framealpha=1)
# label the axis
ax.set_title('Real-time current intensity for all 8 arms')
ax.set_xlabel('Time (s)')
ax.set_ylabel('Current Intensity (A)')

# display the graphics
plt.show()

