%
% a simple test script...
%
%

global result_path name_expr name_site name_ant name_strategy

% put the correct file here...
gfdfile = '/home/ilkkav/results/2022-GUISDAP-commandline/laptoptest/batchtest/gfd_setup_1.m';

run(gfdfile)


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
    t2new = dateshift(t1new+hours(23),'end','day') + minutes(overlap_minutes);
    dirname = fullfile(result_path,[ datestr(t1new+diff([t1new,t2new])/2 ,'yyyy-mm-dd') '_' name_expr '_' num2str(intper) '@' sitestr ])





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

    runGUISDAPpuhti(gfd_str,dirname)
    
    
    
