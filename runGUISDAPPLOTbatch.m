function jobs = runGUISDAPPLOTbatch(gfdfile,cluster,clusterpaths)
%
% jobs = runGUISDAPPLOTbatch(gfdfile,cluster,clusterpaths,MagicConstFile,hdf5)
%
% generate png files of guisdap plot results
%
% INPUT:
%  gfdfile        a gfd file with an extra line overlap_minutes, which gives the overlap of analysis runs for subsequent days
%  cluster        a cluster definition
%  clusterpaths   extra paths to be added to the matlab search path of the workers
%
%
% IV 2022
%

% there are lots of unnecessary stuff in this function... 

    % run the gdffile
    run(gfdfile)
    
    % EISCAT sites
    sites='KSTVLLPQ'; name_site=sites(siteid);

    % convert into site strings
    switch name_site
      case 'K'
        sitestr = 'kir';
      case 'S'
        sitestr = 'sod';
      case 'T'
        sitestr = 'uhf';
      case 'V'
        sitestr = 'vhf';
      case 'L'
        sitestr = 'esr';
      otherwise
        error('unsuppoerted site');
        return
    end
    

    % start and end times as matlab datetime
    t1datetime = datetime(t1);
    t2datetime = datetime(t2);

    % We start a bit early if possible to give the filter a burn-in period
    t1new = dateshift(t1datetime,'start','day')-minutes(overlap_minutes);

    % run analysis in 24 hour pieces
    ijob = 1;
    while t1new < t2datetime
        % End of day + burnin (also in the end for quality control)
        t2new = dateshift(t1new+hours(23),'end','day') + minutes(overlap_minutes);
        disp([t1new t2new])
        
        % output directory name
        dirname = fullfile(result_path,[ datestr(t1new+diff([t1new,t2new])/2 ,'yyyy-mm-dd') '_' name_expr '_' num2str(intper) '@' sitestr ])
        %        fname = fullfile(result_path,dirname,[dirname '_merged.mat'] );

        % start a batch job for the plotting
        %        jobs(ijob) = batch(cluster,@vizu_hpc,1,{fname,' '},'AdditionalPaths',clusterpaths,'AutoAddClientPath',false,'AutoAttachFiles',false);
        jobs(ijob) = batch(cluster,@vizu_hpc,1,{dirname,' ',ijob},'AdditionalPaths',clusterpaths,'AutoAddClientPath',false,'AutoAttachFiles',false);

        % increment the job counter
        ijob = ijob + 1;

        % end time of the next day
        t1new = t1new + days(1);
    end
    
end

