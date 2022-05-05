addpath '/home/ilkkav/Packages/MATLAB/hpc-guisdap'

c = parcluster('puhti R2021a')
c.AdditionalProperties.MemUsage='15g'
c.AdditionalProperties.WallTime='1:0:0'

jobsELSPEC = runELSPECbatch('gfd_setup_200706_batchtest.m',c,{'/projappl/project_2005574/guisdap9/anal','/projappl/project_2005574/guisdap9/irbem','/projappl/project_2005574/BAFIM','/projappl/project_2005574/ELSPEC'})
