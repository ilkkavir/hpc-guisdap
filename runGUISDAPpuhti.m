function success = runGUISDAPpuhti(gfd_str,dirname)
%
% success = runGUISDAPpuhti(gfdstr,dirname)
%
% A simple function for starting a guisdap instance in puhti.csc.fi
%
% INPUT:
%   gfd_str   a string array that contains the contents of the gfd file to be used to start the analysi
%   dirname   name of the directory where the gdf file will be written
%
% OUTPUT:
%   success   0: successful analysis
%             1: failed to creae the gfd file
%             2: failed to run start_GUP
%             3: failed to run go_on (the actual analysis)
%
% This function is run on puhti, there is another function that generates the calls in the local machine. 
%
% IV 2022
%

    success = 0;
    
    % create the output directory and writet the gfd file there
    try
        if ~exist(dirname,'dir')
            mkdir(dirname);
        end
        fname = string([tempname(dirname),'.m']);
        fid = fopen(fname,'w');
        for iline = 1:length(gfd_str)
            fprintf(fid,"%s\n",gfd_str(iline));
        end
        fclose(fid);
    catch
        success = 1;
        return
    end

    % % path settings (temporary, hard-coded test version)
    % addpath('/usr/local/guisdap9/anal')
    % addpath('/usr/local/guisdap9/irbem')
    % addpath('/home/ilkkav/Packages/MATLAB/BAFIM')

    try
        % this should be a modified version of start_GUP with clear all commented out from the beginning.
        start_GUP
    catch
        success = 2;
        return
    end

    % start the analysis
    try
        go_on(char(fname));
    catch
        success = 3;
        return
    end

end