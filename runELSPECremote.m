function success = runELSPECremote(gfd_str,dirname,radar)
%
% success = runELSPECremote(gfdstr,dirname,radar)
%
% A simple function for starting an ELSPEC instance on a remote worker. 
% It is assumed that one has first called runGUISDAPremote with the same arguments.
% These two are not merged, as the ELSPEC analysis requires much more memory than guisdap, and
% the reserved memory would be unnecessarily reserved during the GUISDAP run. 
%
% NOTICE: this file does not be manually copied to the workers. It is automatically copied by the batch command.
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
% This function is run on the workers, there is another function that generates the calls in the local machine. 
%
% IV 2022
%

    global result_path name_expr name_site
    
    success = 0;

    % only the ELSPEC part would be strictly necessary, but this way we can make sure
    % that everything is in correct place
    
    % create the output directory and write the gfd file there
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

    try
        % this should be a modified version of start_GUP with clear all commented out from the beginning.
        start_GUP
    catch
        success = 2;
        return
    end


    % run ELSPEC
    try
        run(char(fname));
        % cd to a directory where we can write for sure
        cd(fileparts(result_path))
        % run ELSPEC
        ElSpec('fitdir',result_path,'experiment',name_expr,'radar',radar,'recombmodel','SheehanGrFlipchem','plotres',0);
    catch
        success = 4;
        return
    end
    
end

