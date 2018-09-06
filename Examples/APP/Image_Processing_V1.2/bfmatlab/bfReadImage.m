function [images,nameList] = bfReadImage(varargin)
% load the images, for multiple images, the output shall be a cell
% the function could accept inputs as follows:
%   beReadImage('a.nd2')
%   beReadImage({'a.nd2','b.nd2','c.nd2'})
%   beReadImage('a.nd2','b.nd2','c.nd2')
% author: Zhaozheng Hou (George)

if (nargin==1)
    if (iscell(varargin{1}))
        nameList=varargin{1};
        images=cellfun(@(name) local_read1Image(name),nameList,...
            'UniformOutput',false);
    else
        nameList=varargin{1};
        images=local_read1Image(nameList);
    end
else
    nameList=varargin;
    images=cellfun(@(name) local_read1Image(name),nameList,...
        'UniformOutput',false);
end

    function image=local_read1Image(filename)
        try
            image=imread(filename);
        catch
        [~,image]=evalc(['bfopen(''',filename,''')']);
        image=image{1}{1};
        end
    end
end