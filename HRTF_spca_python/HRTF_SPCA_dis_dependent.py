# "Distance-dependent modelling of HRTFs", Zhang et al. 2019
# a method for modeling distance dependent head-related transfer functions
# The HRTFs are first decomposed by spatial principal component analysis. 
# Using deep neural networks, we model the spatial principal component weights of different distances.
# Then we realize the prediction of HRTFs in arbitrary spatial distances.
import numpy as np
from numpy import linalg as LA
import scipy
import scipy.io as sio
import os
import pandas as pd
import math
import matplotlib.pyplot as plt
from pylab import *
from collections import namedtuple
from os.path import dirname, join as pjoin
import sofa
import inspect

import sys
sys.path.append(r'C:\Users\root\Documents\00phd\00Code\ForSignalProcessing\spaudiopy\spaudiopy') 
# import spaudiopy

class HRTFdataclass:
    def __init__(self):
        self.fs=[]
        self.HRIR_L=[]
        self.HRIR_R=[]
        self.HRTF_L=[]
        self.HRTF_R=[]
        self.HRTFmag_L=[]
        self.HRTFmag_R=[]
        self.sid=[]
        self.ITD=[]
        self.DTF_L=[]
        self.DTF_R=[]
        self.DTF2_L=[]
        self.DTF2_R=[]
        self.meanHRTF_L=[]
        self.meanHRTF_R=[]
class HRTFSPCA:
    def __init__(self):
        self.weights_L=[]
        self.weights_R=[]
        self.nBases=[]
        self.DTF2synth_L=[]
        self.DTF2synth_R=[]
        self.HRTF2_L=[]
        self.HRTF2_R=[]
        self.MSE_L=[]
        self.MSE_R=[]
        self.L2_L=[]
        self.L2_R=[]

## Load HRTF data
HRTFdata=HRTFdataclass()
HRTFdata_full=[]

# Define parameters
fs = 44100
Nbases = [1,5,10,20,30,50,75,100,129]   # number of bases to be selected from 
N = 256; # FFT length

# load data
names=os.listdir('C:/Users/root/Documents/00phd/00ThirdPartyCode/ForSignalProcessing/SOFA API/SOFA API for Matlab and Octave 1.1.1/HRTFs/CIPIC_hrtf_database/standard_hrir_database/')
# print(names)
# column_names=['id','elevation','azimuth','hrtf']
# input=pd.DataFrame(columns=column_names)
# input.id=names[1:]
# print(input)

for i in range(1, len(names)):  
    data_dir = pjoin('C:/Users/root/Documents/00phd/00ThirdPartyCode/ForSignalProcessing/SOFA API/SOFA API for Matlab and Octave 1.1.1/HRTFs/CIPIC_hrtf_database/standard_hrir_database/', names[i])
    mat_fname = pjoin(data_dir, 'hrir_final.mat')
    data=sio.loadmat(mat_fname)

    HRTFdata=HRTFdataclass()
    HRTFdata.fs=fs
    HRTFdata.sid=names[i] 
    HRTFdata.HRIR_L=data.get('hrir_l')
    HRTFdata.HRIR_R=data.get('hrir_r')
    HRTFdata.HRTF_L=scipy.fft.rfft(HRTFdata.HRIR_L,N,axis=-1)
    HRTFdata.HRTF_R=scipy.fft.rfft(HRTFdata.HRIR_R,N,axis=-1)
    HRTFdata.HRTFmag_L=20*np.log10(np.abs(HRTFdata.HRTF_L))
    HRTFdata.HRTFmag_R=20*np.log10(np.abs(HRTFdata.HRTF_R))
    HRTFdata.ITD=data.get('ITD')
    HRTFdata_HRTF_Lnew=np.zeros(HRTFdata.HRTF_L.shape,dtype = 'complex_')
    HRTFdata.HRTF_Rnew=np.zeros(HRTFdata.HRTF_L.shape,dtype = 'complex_')
    HRTFdata.DTF_L=np.zeros(HRTFdata.HRTF_L.shape,dtype = 'complex_')
    HRTFdata.DTF_R=np.zeros(HRTFdata.HRTF_L.shape,dtype = 'complex_')
    HRTFdata.DTF2_L=np.zeros(HRTFdata.HRTF_L.shape,dtype = 'complex_')
    HRTFdata.DTF2_R=np.zeros(HRTFdata.HRTF_L.shape,dtype = 'complex_')
    HRTFdata.meanHRTF_L=np.zeros(HRTFdata.HRTF_L.shape[2],dtype = 'complex_')
    HRTFdata.meanHRTF_R=np.zeros(HRTFdata.HRTF_L.shape[2],dtype = 'complex_')
    
    HRTFdata_full.append(HRTFdata) 

# compute mean HRTF magnitude over all subjects and directions 
# (it includes the direction and subject independent spectral features shared by all HRTFs)
meanHRTFmag=np.zeros(HRTFdata_full[0].HRTF_L.shape[2],dtype = 'complex_')
for i in range(0, len(HRTFdata_full)): # for each subject
    sum_HRTFmag=np.squeeze(np.sum(HRTFdata_full[i].HRTFmag_L,axis=(0,1)))+np.squeeze(np.sum(HRTFdata_full[i].HRTFmag_R,axis=(0,1))) #sum over all directions
    meanHRTFmag=meanHRTFmag+sum_HRTFmag #sum over all subjects
meanHRTFmag=meanHRTFmag/(len(HRTFdata_full)*2*HRTFdata_full[0].HRTF_L[:,:,0].size) #mean over all subjects and all directions
# remove the mean HRTF magnitude from all HRTFs
for i in range(0, len(HRTFdata_full)): # for each subject
    HRTFdata_full[i].HRTFmag_Lnew=HRTFdata_full[i].HRTFmag_L-meanHRTFmag
    HRTFdata_full[i].HRTFmag_Rnew=HRTFdata_full[i].HRTFmag_R-meanHRTFmag

# Compute mean spatial function over all frequencies and subjects 
sum_HRTFmagnew_L=np.zeros(HRTFdata_full[0].HRTF_L.shape[0:2],dtype = 'complex_')
sum_HRTFmagnew_R=np.zeros(HRTFdata_full[0].HRTF_L.shape[0:2],dtype = 'complex_')
meanHRTFmagnew_L=np.zeros(HRTFdata_full[0].HRTF_L.shape[0:2],dtype = 'complex_')
meanHRTFmagnew_R=np.zeros(HRTFdata_full[0].HRTF_L.shape[0:2],dtype = 'complex_')
for i in range(0, len(HRTFdata_full)): # for each subject
    sum_HRTFmagnew_L=sum_HRTFmagnew+np.squeeze(np.sum(HRTFdata_full[i].HRTFmag_Lnew,axis=[0,1])) #sum over all directions
    sum_HRTFmagnew_R=sum_HRTFmagnew_L+np.squeeze(np.sum(HRTFdata_full[i].HRTFmag_Rnew,axis=[0,1])) #sum over all directions
meanHRTFmagnew_L=sum_HRTFmagnew_L/(len(HRTFdata_full)*HRTFdata_full[0].HRTFmag_Lnew.shape[2]) 
meanHRTFmagnew_R=sum_HRTFmagnew_R/(len(HRTFdata_full)*HRTFdata_full[0].HRTFmag_Lnew.shape[2])
 