#!/usr/bin/python
#
# Poll and log data collected from one or more MCC118 ADC boards
# See also the `daqhats_read_eeproms` and `daqhats_list_boards` command line
# tools

# pull in python standard library functions
import os
import sys
import numpy as np
import matplotlib.pyplot as plt
from time import gmtime, sleep, strftime, time

# pull in the daqhat library
from daqhats import hat_list, HatIDs, mcc118


class PretestDataLogger:
    '''
    Scan the inputs on one or more MCC 118 boards and log data to a file
    in a loop (unitl interrupted) using the log method.
    '''

    def __init__(self):
        '''
        Detect boards and get ready to be interrupted
        '''
        self.running = False

        # get hat list of MCC daqhat boards
        self.boards = hat_list(filter_by_id = HatIDs.MCC_118)
        self.boardsEntry = []
        for entry in self.boards:
            self.boardsEntry.append( mcc118(entry.address) )
        if not self.boards:
            sys.stderr.write("No boards found\n")
            sys.exit()


    def handle_interupt(self, signum, frame):
        '''
        Signal handler that ends a call to log
        '''
        self.running = False


    def log(self):
        '''
        In a loop (until interrupted) scan the inputs of all detected boards
        and output data to a tab delimited text file with a single header row
        '''

        # get desired number of lines of voltage data
        num_lines = 5
        testVal = np.zeros((num_lines, 64))
        # intialize counter, index, and running boolean
        idx = 0
        tmpCounter = 0
        self.running = True
        while self.running:
            # Read and display every channel
            # for entry in self.boards:
            for board in self.boardsEntry:
                for channel in range(board.info().NUM_AI_CHANNELS):
                    testVal[tmpCounter,idx] = "%.4f" % board.a_in_read(channel)
                    idx += 1
        
            sleep(0.5)
            # iterate counter
            tmpCounter += 1
            # reset index
            idx = 0
            # break condition based on number of lines
            if tmpCounter == num_lines:
                self.running = False
        return testVal

# Main program starts here. Use `python3 log2.py` to run
# check prevents running of program if loading (import) as a module
if __name__ == "__main__":
    # Pull in python standard libraries only used when running as program
    import signal

   # Create Data Logger
    logger = PretestDataLogger()
    
    

    # empty input matrix
    # testVal = []

    # Add signal handler so systemd can shutdown service
    signal.signal(signal.SIGINT, logger.handle_interupt)
    signal.signal(signal.SIGTERM, logger.handle_interupt)

    val = logger.log()
    
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

    # Voltages for 2nd arm being Bravo Arm
    b1 = val[:,V7+8]-val[:,V6+8]
    b2 = val[:,V6+8]-val[:,V5+8]
    b3 = val[:,V5+8]-val[:,V4+8]
    b4 = val[:,V4+8]-val[:,V3+8]
    b5 = val[:,V3+8]-val[:,V2+8]
    b6 = val[:,V2+8]-val[:,V1+8]
    b_I = (val[:,V1+8]-val[:,V0+8])/ 0.1

    # Voltages for 3rd arm being Charlie Arm
    c1 = val[:,V7+16]-val[:,V6+16]
    c2 = val[:,V6+16]-val[:,V5+16]
    c3 = val[:,V5+16]-val[:,V4+16]
    c4 = val[:,V4+16]-val[:,V3+16]
    c5 = val[:,V3+16]-val[:,V2+16]
    c6 = val[:,V2+16]-val[:,V1+16]
    c_I = (val[:,V1+16]-val[:,V0+16])/ 0.1

    # Voltages for 4th arm being Delta Arm
    d1 = val[:,V7+24]-val[:,V6+24]
    d2 = val[:,V6+24]-val[:,V5+24]
    d3 = val[:,V5+24]-val[:,V4+24]
    d4 = val[:,V4+24]-val[:,V3+24]
    d5 = val[:,V3+24]-val[:,V2+24]
    d6 = val[:,V2+24]-val[:,V1+24]
    d_I = (val[:,V1+24]-val[:,V0+24])/ 0.1

    # Voltages for 5th arm being Echo Arm
    e1 = val[:,V7+32]-val[:,V6+32]
    e2 = val[:,V6+32]-val[:,V5+32]
    e3 = val[:,V5+32]-val[:,V4+32]
    e4 = val[:,V4+32]-val[:,V3+32]
    e5 = val[:,V3+32]-val[:,V2+32]
    e6 = val[:,V2+32]-val[:,V1+32]
    e_I = (val[:,V1+32]-val[:,V0+32])/ 0.1

    # Voltages for 6th arm being Foxtrot Arm
    f1 = val[:,V7+40]-val[:,V6+40]
    f2 = val[:,V6+40]-val[:,V5+40]
    f3 = val[:,V5+40]-val[:,V4+40]
    f4 = val[:,V4+40]-val[:,V3+40]
    f5 = val[:,V3+40]-val[:,V2+40]
    f6 = val[:,V2+40]-val[:,V1+40]
    f_I = (val[:,V1+40]-val[:,V0+40])/ 0.1

    # Voltages for 6th arm being Golf Arm
    g1 = val[:,V7+48]-val[:,V6+48]
    g2 = val[:,V6+48]-val[:,V5+48]
    g3 = val[:,V5+48]-val[:,V4+48]
    g4 = val[:,V4+48]-val[:,V3+48]
    g5 = val[:,V3+48]-val[:,V2+48]
    g6 = val[:,V2+48]-val[:,V1+48]
    g_I = (val[:,V1+48]-val[:,V0+48])/ 0.1

    # Voltages for 6th arm being Hotel Arm
    h1 = val[:,V7+56]-val[:,V6+56]
    h2 = val[:,V6+56]-val[:,V5+56]
    h3 = val[:,V5+56]-val[:,V4+56]
    h4 = val[:,V4+56]-val[:,V3+56]
    h5 = val[:,V3+56]-val[:,V2+56]
    h6 = val[:,V2+56]-val[:,V1+56]
    h_I = (val[:,V1+56]-val[:,V0+56])/ 0.1

    # get avg voltage values
    a1_avg = np.average(a1)
    
    if a1_avg >= 1:
        print("alpha 1 battery high")
    
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
    
    #display the graphics
    plt.show()
