function jobs = runGUISDAPbatch(gfdfile,cluster,clusterpaths,MagicConstFile,hdf5)
%
% jobs = runGUISDAPbatch(gfdfile,cluster,clusterpaths,MagicConstFile,hdf5)
%
% run GUISDAP as batch jobs in a cluster
%
% INPUT:
%  gfdfile        a gfd file with an extra line overlap_minutes, which gives the overlap of analysis runs for subsequent days
%  cluster        a cluster definition
%  clusterpaths   extra paths to be added to the matlab search path of the workers
%  MagicConstFile either a file that contains magic constants in the format date, value (one pair per line), a numerical value to be used, or an empty array to use the guisdap default
%  hdf5           logical, true if the input data are in hdf5 format
%
% NB! The Magic constant settings take effect only if some (any) value is given for the magic constant in the 'extra' array of the gfd file Otherwise the defaults are always used.
%
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

        % input directory name for hdf5 files
        if hdf5
            hdf5ddir = [fullfile(data_path,datestr(t1new+diff([t1new,t2new])/2 ,'yyyymmdd')) filesep];
        end

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
            % hdf5 input data are in daily directories (with sufficient overlap)
            if hdf5
                if length(teststr)>=9
                    if teststr(1:9)=='data_path'
                        gfd_str(iline) = string(['data_path=','''',hdf5ddir,'''']);
                    end
                end
            end
            iline = iline + 1;
        end
        % the magic constant is in the extra box and needs a separete treatmen
        % First read the correct magic constant for this day from file
        MagicConst = NaN;
        if ~isempty(MagicConstFile)
            if isnumeric(MagicConstFile)
                MagicConst = MagicConstFile;
            else
                mclines = readlines(MagicConstFile);
                mctimeprev = datetime(1970,1,1);
                for k=1:length(mclines)
                    mcline = strsplit(mclines(k));
                    mctime = datetime(mcline(1));
                    if mctime <= dateshift(t1new,'end','day')
                        if mctime > mctimeprev
                            mctimeprv = mctime;
                            MagicConst = str2num(mcline(2));
                        end
                    end
                end
            end
        end
        % if a magic constant was found it must be put to the extra box,
        % otherwise make sure that Magi_cont is not given (to use the default)
        %
        % NB: the magic constant from file is not used if magic constant was not
        %      set to some value in the original extra box!
        %
        if exist('extra','var')
            dimextra = size(extra);
            for iline = 1 : length(gfd_str)
                teststr = char(strtrim(gfd_str(iline)))
                if length(teststr)>=5
                    if teststr(1:5)=='extra'
                        extraline = iline
                        break
                    end
                end
            end
            mcwritten=false;
            for k = extraline:(extraline+dimextra(1)-1)
                if ~isempty(strfind(gfd_str(k),'Magic_const'))
                    rmline = extractBetween(gfd_str(k),"'","'");
                    nrm = length(char(rmline));
                    gfd_str(k) = replaceBetween(gfd_str(k),"'","'",repmat(' ',1,nrm));
                    if ~isnan(MagicConst)
                        gfd_str(k) = replaceBetween(gfd_str(k),"'","'",[sprintf('Magic_const=%3.2f',MagicConst) repmat(' ',1,nrm-16)]);
                        mcwritten=true;
                    end
                end
            end
        end

        jobs(ijob) = batch(cluster,@runGUISDAPremote,1,{gfd_str,dirname,sitestr},'AdditionalPaths',clusterpaths,'AutoAddClientPath',false,'AutoAttachFiles',false);

        % increment the job counter
        ijob = ijob + 1;

        % end time of the next day
        t1new = t1new + days(1);
    end
    
end

