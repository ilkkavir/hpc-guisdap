%
% Read the GUISDAP magic constants from EISCAT hdf5 files and write them in a file
%
% If the magic constant is not stored in the hdf5 file, write a NaN to be replaced manually...
%
% IV 2022
%

h5files = dir('*.hdf5');
magic_conts = NaN(length(h5files),1);
time = NaT(length(h5files),1);
for k=1:length(h5files)
    par0d = h5read(h5files(k).name,'/data/par0d');
    mpar0d = h5read(h5files(k).name,'/metadata/par0d');
    utime = h5read(h5files(k).name,'/data/utime');
    if strcmp(strtrim(mpar0d{1}),'Magic_const')
        magic_const(k) = par0d(1);
    end
    time(k) = datetime(mean(mean(utime,'omitnan'),'omitnan'),'convertfrom','posixtime');
end

fid = fopen('IPY_Magic_const.dat','w')
for k=1:length(h5files)
    fprintf(fid,'%s %5.2f\n',datestr(time(k),'yyyy-mm-dd'),magic_const(k));
end
fclose(fid)