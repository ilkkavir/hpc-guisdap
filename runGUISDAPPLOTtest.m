addpath '/home/ilkkav/Packages/MATLAB/hpc-guisdap'

c = parcluster('puhti R2021a')
c.AdditionalProperties.MemUsage='15g'
c.AdditionalProperties.WallTime='2:0:0'
c.AdditionalProperties.AccountName='project_2005574'

jobsPLOT = runGUISDAPPLOTbatch('gfd_setup_200706_MPStest.m',c,{'/projappl/project_2005574/guisdap9/anal','/projappl/project_2005574/guisdap9/irbem','/projappl/project_2005574/hpc-guisdap'})

