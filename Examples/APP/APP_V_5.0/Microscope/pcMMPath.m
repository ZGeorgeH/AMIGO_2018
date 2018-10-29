[~,hostname]= system('hostname');
if length(hostname)>14
    hostname=hostname(1:end-1);
end
if any(strfind(hostname,'SCE-BIO-C02471'))
    javaaddpath('C:\Program Files\Micro-Manager-1.4.16/ij.jar');
    %Add all jars in the plugins directory
    a=dir (fullfile('C:\Program Files\Micro-Manager-1.4.16/plugins/Micro-Manager'));
    for n=3:length(a)
        if strcmp(a(n).name(end-3:end),'.jar')
            %['C:\Program Files\Micro-Manager-1.4.21/plugins/Micro-Manager/' a(n).name]
            javaaddpath(['C:\Program Files\Micro-Manager-1.4.16/plugins/Micro-Manager/' a(n).name]);
        end
    end
else
    if any(strfind(hostname,'W5489'))
        mmFolder='C:\Program Files\Micro-Manager-1.4';
    else
        mmFolder='C:\Program Files\Micro-Manager-1.4.21';
    end
    javaaddpath(fullfile(mmFolder,'ij.jar'));
    %Add all jars in the plugins directory
    a=dir (fullfile(mmFolder, 'plugins/Micro-Manager'));
    for n=3:length(a)
        if strcmp(a(n).name(end-3:end),'.jar')
            %['C:\Program Files\Micro-Manager-1.4.21/plugins/Micro-Manager/' a(n).name]
            javaaddpath(fullfile(mmFolder,'plugins/Micro-Manager/',a(n).name));
        end
    end
end




