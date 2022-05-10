addpath '/home/ilkkav/Packages/MATLAB/hpc-guisdap'

c = parcluster('puhti R2021a');
c.AdditionalProperties.MemUsage='2g';
c.AdditionalProperties.WallTime='48:0:0';
c

jobsGUISDAP = runGUISDAPbatch('gfd_setup_200706_MPStest.m',c,{'/projappl/project_2005574/guisdap9/anal','/projappl/project_2005574/guisdap9/irbem','/projappl/project_2005574/BAFIM'},'IPY_Magic_const_complete.dat',true)
%jobsGUISDAP = runGUISDAPbatch('gfd_setup_200706_MPStest.m',c,{'/projappl/project_2005574/guisdap9/anal','/projappl/project_2005574/guisdap9/irbem','/projappl/project_2005574/BAFIM'},[],true)

