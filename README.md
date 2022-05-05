# hpc-guisdap
Routines for running GUISDAP and ELSPEC on a super computer using the MATLAB MPS

(C) Ilkka Virtanen, University of Oulu, 2022
ilkka.i.virtanen@oulu.fi

This package contains routines for running GUISDAP on a supercomputer using normal batch jobs or jobs submitted from local MATLAB session using MATLAB MPS. 

Requirements:
1. guisdap must be installed on the remote worker. 
2. With MPS: comment out the line starting with clear all etc in beginning of start_GUP.m
3. With "normal" batch jobs: add the -p option and add the hpc-guisdap package to matlab search path at the remotes. (see the guisdap script in this repo).

An example about starting parallel GUISDAP processes using MPS is found from runGUISDAPtest.m 
An exmaple about starting parallel ELSPEC processes using MPS is in runELSPECtest.m 
Notice that you must properly define the cluster in your own matlab to be able to use the MPS.

An example batch job scirpt that starts several GUISDAP processes as "normal" batch jobs directly in the super computer is given in runGUISDAPslurm.bash
