#!/usr/bin/python
#
# Poll and log data collected from one or more MCC118 ADC boards
# See also the `daqhats_read_eeproms` and `daqhats_list_boards` command line
# tools

# pull in python standard library functions
import os
import sys
import numpy as np
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


    def log(self, testVal):
        '''
        In a loop (until interrupted) scan the inputs of all detected boards
        and output data to a tab delimited text file with a single header row
        '''

        # get desired number of lines of voltage data
        num_samples = 5
        testVal = np.zeros((num_samples, 64))
        # intialize counter, index, and running boolean
        idx = 0
        tmpCounter = 0
        self.running = True
        while self.running:
            # Read and display every channel
            #for entry in self.boards:
            for board in self.boardsEntry:
                for channel in range(board.info().NUM_AI_CHANNELS):
                    testVal[0,idx] = "%.4f" % board.a_in_read(channel)
                    idx += 1
        
            sleep(0.5)
            tmpCounter += 1
            # break condition
            if tmpCounter == 1:
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
    testVal = []

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
    alpha = np.zeros((7,m))
    beta = np.zeros((7,m))
    charlie = np.zeros((7,m))
    delta = np.zeros((7,m))
    echo = np.zeros((7,m))
    foxtrot = np.zeros((7,m))
    golf = np.zeros((7,m))
    hotel = np.zeros((7,m))

    # add voltages to each row
    for i in range(alpha.shape[0]):
        alpha[i] = val[:,volt_ord[7-i]]-val[:,volt_ord[6-i]]
        beta[i] = val[:,volt_ord[7-i]+8]-val[:,volt_ord[6-i]+8]
        charlie[i] = val[:,volt_ord[7-i]+16]-val[:,volt_ord[6-i]+16]
        delta[i] = val[:,volt_ord[7-i]+24]-val[:,volt_ord[6-i]+24]
        echo[i] = val[:,volt_ord[7-i]+32]-val[:,volt_ord[6-i]+32]
        foxtrot[i] = val[:,volt_ord[7-i]+40]-val[:,volt_ord[6-i]+40]
        golf[i] = val[:,volt_ord[7-i]+48]-val[:,volt_ord[6-i]+48]
        hotel[i] = val[:,volt_ord[7-i]+56]-val[:,volt_ord[6-i]+56]

        # make the current (I) row
        if i == 6:
            alpha[i] = (val[:,volt_ord[7-i]]-val[:,volt_ord[6-i]]) / 0.1
            beta[i] = (val[:,volt_ord[7-i]+8]-val[:,volt_ord[6-i]+8]) / 0.1
            charlie[i] = (val[:,volt_ord[7-i]+16]-val[:,volt_ord[6-i]+16]) / 0.1
            delta[i] = (val[:,volt_ord[7-i]+24]-val[:,volt_ord[6-i]+24]) / 0.1
            echo[i] = (val[:,volt_ord[7-i]+32]-val[:,volt_ord[6-i]+32]) / 0.1
            foxtrot[i] = (val[:,volt_ord[7-i]+40]-val[:,volt_ord[6-i]+40]) / 0.1
            golf[i] = (val[:,volt_ord[7-i]+48]-val[:,volt_ord[6-i]+48]) / 0.1
            hotel[i] = (val[:,volt_ord[7-i]+56]-val[:,volt_ord[6-i]+56]) / 0.1


    # Convolving the sample for every battery to apply the average running filter
    # Also truncating the convolved series to match the battery series
    for i in range(alpha.shape[0]):
        alpha[i] = np.convolve(alpha[i],IR)[:m]
        beta[i] = np.convolve(beta[i],IR)[:m]
        charlie[i] = np.convolve(charlie[i],IR)[:m]
        delta[i] = np.convolve(delta[i],IR)[:m]
        echo[i] = np.convolve(echo[i],IR)[:m]
        foxtrot[i] = np.convolve(foxtrot[i],IR)[:m]
        golf[i] = np.convolve(golf[i],IR)[:m]
        hotel[i] = np.convolve(hotel[i],IR)[:m]


    # sample for 20 - 30 seconds
    # then take the average of those samples for each battery

    # make one array for all average voltages
    battery_volt = np.concatenate((alpha[:,0], beta[:,0], charlie[:,0], delta[:,0], \
        echo[:,0], foxtrot[:,0], golf[:,0], hotel[:,0]), axis=None)

    # ================= #
    # DEAD BATTERY TEST #
    # ================= #

    # ===================== #
    # Reversed Battery Test #
    # ===================== #

    # find the mean of the battery voltages
    mean = np.mean(battery_volt)

    # find the standard deviation of the battery voltages
    std = np.std(battery_volt,dtype=np.float64)

    # ========================= #
    # Battery Out of Range Test #
    # ========================= #


    # Battery out of range
    for i in range(7):
        # redefine based on average values
        for j in range(1):
            if alpha[i,j] not in range(mean - 3 * std, mean + 3 * std):
                print("alpha", i + 1, "out of range")
                alpha_clear = False
            if beta[i,j] <= 0.1:
                print("beta", i + 1, "battery low")
                beta_clear = False
            if charlie[i,j] <= 0.1:
                print("charlie", i + 1, "battery low")
                charlie_clear = False
            if delta[i,j] <= 0.1:
                print("delta", i + 1, "battery low")
                delta_clear = False
            if echo[i,j] <= 0.1:
                print("echo", i + 1, "battery low")
                echo_clear = False
            if foxtrot[i,j] <= 0.1:
                print("foxtrot", i + 1, "battery low")
                foxtrot_clear = False
            if golf[i,j] <= 0.1:
                print("golf", i + 1, "battery low")
                golf_clear = False
            if hotel[i,j] <= 0.1:
                print("hotel", i + 1, "battery low")
                hotel_clear = False
