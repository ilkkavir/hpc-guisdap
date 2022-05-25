function success = runSMOOTHERremote(gfd_str,dirname,radar,gup_ID)
%
% success = runSMOOTHERremote(gfdstr,dirname,radar)
%
% A simple function for running BAFIM smoother if it failed on the GUISDAP run
%
% NOTICE: this file does not need to be manually copied to to the workers. It is automatically copied by the batch command.
%
% INPUT:
%   gfd_str   a string array that contains the contents of the gfd file to be used to start the analysi
%   dirname   name of the directory where the gdf file will be written
%
% OUTPUT:
%   success   0: successful analysis
%             1: failed to creae the gfd file
%             2: failed to run start_GUP
%             3: failed to run bafim_smoother 
%
% This function is run on the worker, there is another function that generates the calls in the local machine. 
%
% IV 2022
%

    global result_path name_expr name_site data_path
    
    success = 0;
    
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

        globals
        nat_const
        run(char(fname))
        sites='KSTVLLLL';
        name_site = sites(siteid);
        for iver = expver:-1:1
            initfile = fullfile(path_exps,name_expr,[name_expr name_site '_' num2str(iver) 'init']);
            if exist(initfile,'file')
                load(initfile)
                break
            end
        end
        if ~exist(initfile,'file')
            initfile = fullfile(path_exps,name_expr,[name_expr name_site 'init']);
            load(initfile)
        end
        constants
    catch
        success = 2;
        return
    end

    % run bafim_smoother
    try
        %        bafim_smoother(mergefile)
        bafim_smoother(result_path,true,true)
    catch
        success = 3;
        return
    end

    % this would require about 11 GB of memory, while the GUISDAP part runs with less than 2 GB.
    % should we call ELSPEC separately?
    % % run ELSPEC
    % try
    %     % cd to a directory where we can write for sure
    %     cd(fileparts(result_path))
    %     % run ELSPEC
    %     ElSpec('fitdir',result_path,'experiment',name_expr,'radar',radar,'recombmodel','SheehanGrFlipchem');
    % catch
    %     success = 4;
    %     return
    % end
    
end


