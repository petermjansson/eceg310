#!/usr/bin/python
#
# Poll and log data collected from one or more MCC118 ADC boards
# See also the `daqhats_read_eeproms` and `daqhats_list_boards` command line
# tools

# pull in python standard library functions
import os
import sys
import numpy as np
# import matplotlib.pyplot as plt
from time import gmtime, sleep, strftime, time

# pull in the daqhat library
from daqhats import hat_list, HatIDs, mcc118


class ShortSampleDataLogger:
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
        num_samples = 40
        testVal = np.zeros((num_samples, 64))
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
            if tmpCounter == num_samples:
                self.running = False
        # print(testVal)
        return testVal

# Main program starts here. Use `python3 log2.py` to run
# check prevents running of program if loading (import) as a module
if __name__ == "__main__":
    # Pull in python standard libraries only used when running as program
    import signal

    # Create Data Logger
    logger = ShortSampleDataLogger()

    # Add signal handler so systemd can shutdown service
    signal.signal(signal.SIGINT, logger.handle_interupt)
    signal.signal(signal.SIGTERM, logger.handle_interupt)

    # extract voltages
    val = logger.log()
    # get shape of voltages
    m = val.shape[0]

    # Impulse response of the filter
    IR = np.ones((5,)) / 5

    # voltage order vector
    volt_ord = [5,3,7,1,0,2,4,6]

    # Voltages for 1st arm read (1st arm being Alpha) in matrix form
    # initialize matricies for each arm
    alpha = np.zeros((6,m))
    beta = np.zeros((6,m))
    charlie = np.zeros((6,m))
    delta = np.zeros((6,m))
    echo = np.zeros((6,m))
    foxtrot = np.zeros((6,m))
    golf = np.zeros((6,m))
    hotel = np.zeros((6,m))

    # add voltages to each row
    for i in range(alpha.shape[0]):
        alpha[i] = val[:,volt_ord[7-i]]-val[:,volt_ord[6-i]]
        bravo[i] = val[:,volt_ord[7-i]+8]-val[:,volt_ord[6-i]+8]
        charlie[i] = val[:,volt_ord[7-i]+16]-val[:,volt_ord[6-i]+16]
        delta[i] = val[:,volt_ord[7-i]+24]-val[:,volt_ord[6-i]+24]
        echo[i] = val[:,volt_ord[7-i]+32]-val[:,volt_ord[6-i]+32]
        foxtrot[i] = val[:,volt_ord[7-i]+40]-val[:,volt_ord[6-i]+40]
        golf[i] = val[:,volt_ord[7-i]+48]-val[:,volt_ord[6-i]+48]
        hotel[i] = val[:,volt_ord[7-i]+56]-val[:,volt_ord[6-i]+56]

    # Convolving the sample for every battery to apply the average running filter
    # Also truncating the convolved series to match the battery series
    for i in range(alpha.shape[0]):
        alpha[i] = np.convolve(alpha[i],IR)[:m]
        bravo[i] = np.convolve(bravo[i],IR)[:m]
        charlie[i] = np.convolve(charlie[i],IR)[:m]
        delta[i] = np.convolve(delta[i],IR)[:m]
        echo[i] = np.convolve(echo[i],IR)[:m]
        foxtrot[i] = np.convolve(foxtrot[i],IR)[:m]
        golf[i] = np.convolve(golf[i],IR)[:m]
        hotel[i] = np.convolve(hotel[i],IR)[:m]


    # Get average voltages for each battery
    # intialize empty average voltage matrix
    avg_volts = np.zeros((8,6))
    
    # make a voltage sample list
    volt_smpls = [alpha, bravo, charlie, delta, echo, foxtrot, golf, hotel]
    
    # make an index for arm names
    arm_names = ['Alpha', 'Bravo', 'Charlie', 'Delta', 'Echo', 'Foxtrot', 'Golf', 'Hotel']
    
    # take the mean of the voltage for each battery
    for i in range(8):
        avg_volts[i] = np.mean(volt_smpls[i], axis = 1)
        
    # find the mean of the battery voltages
    mean = np.mean(avg_volts)

    # find the standard deviation of the battery voltages
    std = np.std(avg_volts,dtype=np.float64)


    # ================= #
    # LOW BATTERY TEST #
    # ================= #

    for i in range(avg_volts.shape[0]):
        for j in range(avg_volts.shape[1]):
            if avg_volts[i,j] <= 1.3:
                print(arm_names[i], j + 1, "needs to be charged")


    # ===================== #
    # Reversed Battery Test #
    # ===================== #

    for i in range(avg_volts.shape[0]):
        for j in range(avg_volts.shape[1]):
            if avg_volts[i,j] < 0:
                print(arm_names[i], j + 1, "is reversed")


    # ========================= #
    # Battery Out of Range Test #
    # ========================= #

    for i in range(avg_volts.shape[0]):
        for j in range(avg_volts.shape[1]):
            if mean - 3 * std >= avg_volts[i,j] >= mean + 3 * std:
                print(arm_names[i], j + 1, "out of range")
                    
