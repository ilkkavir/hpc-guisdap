name_expr= 'ipy';
expver= 2;
siteid= 5;
data_path= '/scratch/project_2005574/EISCATdata/IPY_2007-2008/ipy_fixed42p_2.0l_IPY@42m';
result_path= '/scratch/project_2005574/EISCATresults/IPY_2007-2008/';
t1=[ 2007 06 13 0 0 0];
t2=[ 2007 06 15 24 0 0];
overlap_minutes=20;
maxjobs=5;
rt= 0;
intper= 6;
path_exps= '/projappl/project_2005574/guisdap9/exps';
figs=[ 0 0 0 0 0];
extra=[ 'iono_model=''bafim_flipchem''                                                                              '
        'a_satch.do=0                                                                                             '
        'a_phasepush=0                                                                                            '
        '%analysis_control(1)=0.5                                                                                 '
        'fit_altitude(1:6,1:4)=[0 Inf .1 2.5e11;80 Inf .4 30;103 Inf .4 .05;0 0 0 0;80 Inf .2 2.5;150 400 .2 .01] '];
