# -*- coding: utf-8 -*-

import pandas as pd
from systole.detection import ppg_peaks
from systole.plots import (plot_raw)
from systole.hrv import (time_domain)
from systole.correction import correct_rr 
from systole.utils import (input_conversion)
from bokeh.plotting import show
import os as os
from os import listdir
from os.path import isfile, join

#change directory to where the files are stored
os.chdir('PATH')

##list all files in folder
files = [f for f in listdir('PATH') if isfile(join('PATH', f))]


## can input range(len(files)) to do the whole dataset
## but to visually inspect each timeseries I tend to run 
## in batches of 10
for l in range(x,x): 
    
    ##read in the data
    signal = pd.read_csv(files[l], index_col=(0))['ppg']
        
    ## here I plot each timeseries and visually inspect the peak placement
    ## comment out these lines if you don't want to do this              
    show(
        plot_raw(signal, sfreq = 75, backend = 'bokeh')
        )
    
    
    ##get the peak data 
    ppg_pk, peaks = ppg_peaks(signal, sfreq = 75, clipping = False)
    
    ##changing the peak data into milliseconds
    rr_ms = input_conversion(peaks, input_type = 'peaks', output_type='rr_ms')
    
    ##apply auto corrections in systole for missed beats etc.
    corrected_rr, _ = correct_rr(rr_ms)
        
    ## create time domain analyses 
    time_df = time_domain(rr = corrected_rr, input_type = 'rr_ms')
    
    ##put into a wide format
    time_wide = pd.pivot_table(time_df, values = 'Values', columns = 'Metric')
    time_wide['p_id'] = files[l]
    
    ##write to csv 
    time_wide.to_csv(f"PATH\{files[l]}")

    
