# "Modeling of Individual HRTFs Based on Spatial Principal Component Analysis", Zhang et al. 2020
# an individual HRTF modeling method using deep neural networks based on spatial principal component analysis.
# The HRTFs are represented by a small set of spatial principal components combined with frequency and individual-dependent weights.

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
        self.HRTFmag_Lnew=[]
        self.HRTFmag_Rnew=[]
        self.HRTFmag_Lnewnew=[]
        self.HRTFmag_Rnewnew=[]
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
Nbases = [1,20,50,100,150,200,300,500,1000,1250]   # number of bases to be selected from 
N = 256; # FFT length
freq=np.linspace(0, math.ceil(N/2), math.ceil(N/2)+1)*fs/N


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
    HRTFdata.HRTFmag_Lnew=np.zeros(HRTFdata.HRTF_L.shape)
    HRTFdata.HRTFmag_Rnew=np.zeros(HRTFdata.HRTF_L.shape)
    HRTFdata.HRTFmag_Lnewnew=np.zeros(HRTFdata.HRTF_L.shape)
    HRTFdata.HRTFmag_Rnewnew=np.zeros(HRTFdata.HRTF_L.shape)
    HRTFdata.meanHRTF_L=np.zeros(HRTFdata.HRTF_L.shape[2],dtype = 'complex_')
    HRTFdata.meanHRTF_R=np.zeros(HRTFdata.HRTF_L.shape[2],dtype = 'complex_')
    HRTFdata.HRTFmag_Lsynth=np.zeros(np.append(HRTFdata.HRTF_L.shape,len(Nbases)))
    HRTFdata.HRTFmag_Rsynth=np.zeros(np.append(HRTFdata.HRTF_L.shape,len(Nbases)))
    
    HRTFdata_full.append(HRTFdata) 

# compute mean HRTF magnitude over all subjects and directions 
# (it includes the direction and subject independent spectral features shared by all HRTFs)
meanHRTFmag=np.zeros(HRTFdata_full[0].HRTF_L.shape[2])
for i in range(0, len(HRTFdata_full)): # for each subject
    sum_HRTFmag=np.squeeze(np.sum(HRTFdata_full[i].HRTFmag_L,axis=(0,1)))+np.squeeze(np.sum(HRTFdata_full[i].HRTFmag_R,axis=(0,1))) #sum over all directions
    meanHRTFmag=meanHRTFmag+sum_HRTFmag #sum over all subjects
meanHRTFmag=meanHRTFmag/(len(HRTFdata_full)*2*HRTFdata_full[0].HRTF_L[:,:,0].size) #mean over all subjects and all directions
# remove the mean HRTF magnitude from all HRTFs
for i in range(0, len(HRTFdata_full)): # for each subject
    HRTFdata_full[i].HRTFmag_Lnew=HRTFdata_full[i].HRTFmag_L-meanHRTFmag
    HRTFdata_full[i].HRTFmag_Rnew=HRTFdata_full[i].HRTFmag_R-meanHRTFmag

# Compute mean spatial function over all frequencies and subjects 
sum_HRTFmagnew_L=np.zeros(HRTFdata_full[0].HRTF_L.shape[0:2])
sum_HRTFmagnew_R=np.zeros(HRTFdata_full[0].HRTF_L.shape[0:2])
meanHRTFmagnew_L=np.zeros(HRTFdata_full[0].HRTF_L.shape[0:2])
meanHRTFmagnew_R=np.zeros(HRTFdata_full[0].HRTF_L.shape[0:2])
for i in range(0, len(HRTFdata_full)): # for each subject
    sum_HRTFmagnew_L = sum_HRTFmagnew_L+np.squeeze(np.sum(HRTFdata_full[i].HRTFmag_Lnew,axis=2)) 
    sum_HRTFmagnew_R = sum_HRTFmagnew_L+np.squeeze(np.sum(HRTFdata_full[i].HRTFmag_Rnew,axis=2)) 
meanHRTFmagnew_L = sum_HRTFmagnew_L/(len(HRTFdata_full)*HRTFdata_full[0].HRTFmag_Lnew.shape[2]) 
meanHRTFmagnew_R = sum_HRTFmagnew_R/(len(HRTFdata_full)*HRTFdata_full[0].HRTFmag_Lnew.shape[2])
# remove mean spatial function
for i in range(0, len(HRTFdata_full)): # for each subject
    for j in range(0, HRTFdata_full[0].HRTFmag_Lnew.shape[2]):  # for each frequency
        HRTFdata_full[i].HRTFmag_Lnewnew[:,:,j] = np.squeeze(HRTFdata_full[i].HRTFmag_Lnew[:,:,j])-meanHRTFmagnew_L
        HRTFdata_full[i].HRTFmag_Rnewnew[:,:,j] = np.squeeze(HRTFdata_full[i].HRTFmag_Rnew[:,:,j])-meanHRTFmagnew_R
 
## Estimate spatial principal components
# 2NS x D matrix of HRTFmag_newnew 
H=np.zeros((2*len(HRTFdata_full)*HRTFdata_full[0].HRTFmag_Lnewnew.shape[2],HRTFdata_full[0].HRTFmag_Lnewnew.shape[0]*HRTFdata_full[0].HRTFmag_Lnewnew.shape[1]),dtype='complex_')
for i in range(0, len(HRTFdata_full)): 
    for j in range(0,  HRTFdata_full[0].HRTF_L.shape[2]):  # each frequency
        for k in range(0, HRTFdata_full[0].HRTF_L.shape[0]):
            for l in range(0, HRTFdata_full[0].HRTF_L.shape[1]):
                H[len(HRTFdata_full)*i+j,HRTFdata_full[0].HRTF_L.shape[0]*l+k]=HRTFdata_full[i].HRTFmag_Lnewnew[k,l,j]   # Each column of H corresponds to a spatial direction, and each row of H represents the HRTF of an individual at a discrete frequency.
                H[len(HRTFdata_full)*HRTFdata_full[0].HRTF_L.shape[2]+len(HRTFdata_full)*i+j,HRTFdata_full[0].HRTF_L.shape[0]*l+k]=HRTFdata_full[i].HRTFmag_Rnewnew[k,l,j]   # right ear
COV=np.cov(H.transpose()) # covariance matrix
pass
eigen_val, eigen_vec = LA.eig(COV)
var=np.zeros(eigen_vec.shape[1])

# Find strongest eigenvalues and decompose
PCA_full=[]  # PCA_full is a list of instances HRTFPCA
Hnew=np.zeros(np.append(H.shape,len(Nbases)))
for j in range(0,len(Nbases)):      
    eigen_vecProj = eigen_vec[:, 0:Nbases[j]].transpose()
    eigen_valProj = eigen_val[0:Nbases[j]] # build reduced covar matrix
    weights = np.matmul(H,eigen_vecProj.transpose())  # matrix multiplication
    synth = np.matmul(weights,eigen_vecProj)  
    for k in range(0, HRTFdata_full[0].HRTF_L.shape[0]): 
        for l in range(0, HRTFdata_full[0].HRTF_L.shape[1]):
            # restore removed parts
            Hnew[0:len(HRTFdata_full)*HRTFdata_full[0].HRTFmag_Lnewnew.shape[2],HRTFdata_full[0].HRTF_L.shape[0]*l+k,j] = synth[0:len(HRTFdata_full)*HRTFdata_full[0].HRTFmag_Lnewnew.shape[2],HRTFdata_full[0].HRTF_L.shape[0]*l+k] + meanHRTFmagnew_L[k,l] # add back the mean spatial function at each direction
            Hnew[len(HRTFdata_full)*HRTFdata_full[0].HRTFmag_Lnewnew.shape[2]:,HRTFdata_full[0].HRTF_L.shape[0]*l+k,j] = synth[len(HRTFdata_full)*HRTFdata_full[0].HRTFmag_Lnewnew.shape[2]:,HRTFdata_full[0].HRTF_L.shape[0]*l+k] + meanHRTFmagnew_R[k,l]
    
for i in range(0,len(eigen_val)):# calculate cumulative variance
    var[i]=np.sum(eigen_val[0:i+1])/np.sum(eigen_val)

# save reconstructed HRTF
for i in range(0, len(HRTFdata_full)):
    for j in range(0, HRTFdata_full[0].HRTF_L.shape[2]):   
        for k in range(0, HRTFdata_full[0].HRTF_L.shape[0]):
            for l in range(0, HRTFdata_full[0].HRTF_L.shape[1]):
                for b in range(0, len(Nbases)):
                    HRTFdata_full[i].HRTFmag_Lsynth[k,l,j,b] =  Hnew[len(HRTFdata_full)*i+j,HRTFdata_full[0].HRTF_L.shape[0]*l+k,b] + meanHRTFmag[j]# add back the mean of subjects and frequencies
                    HRTFdata_full[i].HRTFmag_Rsynth[k,l,j,b] =  Hnew[len(HRTFdata_full)*HRTFdata_full[0].HRTF_L.shape[2]+len(HRTFdata_full)*i+j,HRTFdata_full[0].HRTF_L.shape[0]*l+k,b] + meanHRTFmag[j]
    print(i)

pass   
## Key anthropometric parameters selection 
data_dir = pjoin('C:/Users/root/Documents/00phd/00ThirdPartyCode/ForSignalProcessing/SOFA API/SOFA API for Matlab and Octave 1.1.1/HRTFs/CIPIC_hrtf_database/anthropometry/')
mat_fname = pjoin(data_dir, 'anthro.mat')
anth_data=sio.loadmat(mat_fname)
anth=np.zeros((len(anth_data),14))
X=anth_data.get('X')
D=anth_data.get('D')
for i in range(0, len(anth_data)):
    anth[i,0]=X[i,0]
    anth[i,1]=X[i,2]
    anth[i,2]=X[i,3]
    anth[i,3]=X[i,11]
    anth[i,4]=D[i,0]
    anth[i,5]=D[i,2]
    anth[i,6]=D[i,3]
    anth[i,7]=D[i,4]
    anth[i,8]=D[i,5]
    anth[i,9]=D[i,8]
    anth[i,10]=D[i,10]
    anth[i,11]=D[i,11]
    anth[i,12]=D[i,12]
    anth[i,13]=D[i,13]

## DNN

## Map weights to anthropometric parameters