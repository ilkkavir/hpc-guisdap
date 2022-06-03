addpath '/home/ilkkav/Packages/MATLAB/hpc-guisdap'

c = parcluster('puhti R2021a');
c.AdditionalProperties.MemUsage='10g';
c.AdditionalProperties.WallTime='24:0:0';
c.AdditionalProperties.AccountName='project_2005574'
%c=parcluster('local');
c

jobsSMOOTHER = runSMOOTHERbatch('gfd_setup_2007_0928_1009_MPS.m',c,{'/projappl/project_2005574/guisdap9/anal','/projappl/project_2005574/guisdap9/irbem','/projappl/project_2005574/BAFIM'},'IPY_Magic_const_complete.dat',true)
%jobsSMOOTHER = runSMOOTHERbatch('gfd_setup_200706_MPStest.m',c,{'/projappl/project_2005574/guisdap9/anal','/projappl/project_2005574/guisdap9/irbem','/projappl/project_2005574/BAFIM'},'IPY_Magic_const_complete.dat',true)
%jobsSMOOTHER = runSMOOTHERbatch('gfd_setup_200706_MPStest.m',c,{'/usr/local/guisdap9/anal','/usr/local/guisdap9/irbem','/home/ilkkav/Packages/MATLAB/BAFIM'},'IPY_Magic_const_complete.dat',true)
%jobsGUISDAP = runGUISDAPbatch('gfd_setup_200706_MPStest.m',c,{'/projappl/project_2005574/guisdap9/anal','/projappl/project_2005574/guisdap9/irbem','/projappl/project_2005574/BAFIM'},[],true)

