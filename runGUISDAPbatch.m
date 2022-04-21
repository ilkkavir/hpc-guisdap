function jobs = runGUISDAPbatch(gfdfile,cluster,clusterpaths)
%
% run GUISDAP as batch jobs in a cluster
%
% IV 2022
%
    
    

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

        % read the gfd file as a string array
        gfd_str = readlines(gfdfile);    
        iline = 1;
        while iline <= length(gfd_str)
            teststr = char(strtrim(gfd_str(iline)));
            % the new start and end times
            if length(teststr)>=2
                if teststr(1:2)=='t1'
                    gfd_str(iline) = string(['t1=[',datestr(t1new,'yyyy mm dd HH MM SS'),']']);
                end
                if teststr(1:2)=='t2'
                    gfd_str(iline) = string(['t2=[',datestr(t2new,'yyyy mm dd HH MM SS'),']']);
                end
            end
            % own output directory for each day
            if length(teststr)>=11
                if teststr(1:11)=='result_path'
                    gfd_str(iline) = string(['result_path=','''',dirname,'''']);
                end
            end
            iline = iline + 1;
        end
        
        
        jobs(ijob) = batch(cluster,@runGUISDAPpuhti,1,{gfd_str,dirname},'AdditionalPaths',clusterpaths,'AutoAddClientPath',false,'AutoAttachFiles',false);
        runGUISDAPpuhti(gfd_str,dirname)

        % increment the job counter
        ijob = ijob + 1;

        % end time of the next day
        t1new = t1new + days(1);
    end
    
end

