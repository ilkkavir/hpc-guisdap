function go_on_parallel(gfdfile)


% these are now given in the gfd file
%    overlap_minutes = 15;
    %   maxjobs = 5;
global result_path name_expr name_site name_ant name_strategy
    
    run(gfdfile);

    sites='KSTVLLPQ'; name_site=sites(siteid);

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

    
    t1datetime = datetime(t1);
    t2datetime = datetime(t2);

    t1new = dateshift(t1datetime,'start','day')-minutes(overlap_minutes);

    ijob = 1;
    
    while t1new < t2datetime
        t2new = dateshift(t1new+hours(23),'end','day') + minutes(overlap_minutes);
        disp([t1new t2new])
        dirname = fullfile(result_path,[ datestr(t1new+diff([t1new,t2new])/2 ,'yyyy-mm-dd') '_' name_expr '_' num2str(intper) '@' sitestr ])
        [jobs(ijob) fnames(ijob)] = start_job(gfdfile,t1new,t2new,dirname);
        ijob = next_ijob(jobs,maxjobs,fnames);
        t1new = t1new + days(1);
        if t1new < t2datetime
            while ijob < 0
                pause(1)
                ijob = next_ijob(jobs,maxjobs,fnames);
            end
        end
    end


    for ii=1:length(jobs)
        try
            wait(jobs(ii));
            delete(fnames(ii));
            diary(jobs(ii))
            delete(jobs(ii))
        catch
            ;
        end
    end
    quit
end

function ijob = next_ijob(jobs,maxjobs,fname)

    ijob = -1;
    njobs = length(jobs);
    if njobs<maxjobs
        ijob = njobs + 1;
        return
    end

    for ii = 1:maxjobs
        if strcmp(jobs(ii).State,'finished')
            diary(jobs(ii))
            delete(jobs(ii));
            delete(fname(ii));
            ijob = ii;
            break
        end
    end

end


function [job,fname] = start_job(gfdfile,t1new,t2new,dirname)
    
    gfd_str = readlines(gfdfile);    
    iline = 1;
    while iline <= length(gfd_str)
        teststr = char(strtrim(gfd_str(iline)));
        if length(teststr)>=2
            if teststr(1:2)=='t1'
                gfd_str(iline) = string(['t1=[',datestr(t1new,'yyyy mm dd HH MM SS'),']']);
            end
            if teststr(1:2)=='t2'
                gfd_str(iline) = string(['t2=[',datestr(t2new,'yyyy mm dd HH MM SS'),']']);
            end
        end
        if length(teststr)>=11
            if teststr(1:11)=='result_path'
                gfd_str(iline) = string(['result_path=','''',dirname,'''']);
            end
        end
        iline = iline + 1;
    end
    if ~exist(dirname,'dir')
        mkdir(dirname);
    end
    fname = string([tempname(dirname),'.m']);
    fid = fopen(fname,'w');
    for iline = 1:length(gfd_str)
        fprintf(fid,"%s\n",gfd_str(iline));
    end
    fclose(fid);
    job = batch(@go_on,0,{char(fname)});

end