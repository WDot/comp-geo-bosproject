%Bosphorous has a simple but non-standard file format. The dataset provides
%a function for parsing that data, but we want to put it into a convenient
%format that CGAL will be able to handle. In this case, ASCII XYZ
%coordinates.  Also, Bosphorous provides both 3D coordinates and a set of
%2D projections. We only care about the 3D coordinates.
%Inputs: The Bosphorous DB path, a proposed output path
%Output: An ASCII file containing the properly formatted data.
function bosphorous_bnt2xyz(rootpath,outputPath)
    OUTLIER = 999;
    if ~exist(outputPath,'dir')
        mkdir(outputPath)
    end
    subdirs = dir(rootpath);
    %Remove . and .. as subdirs
    subdirs = subdirs(3:end);
    %subDirIndices = subdirs(:).isdir;
    %subdirs = subdirs(subDirIndices).name;
    for subdirIndex=1:length(subdirs)
        if subdirs(subdirIndex).isdir == 1
            currentSubdir = [rootpath '/' subdirs(subdirIndex).name];
            fileListing = dir([currentSubdir '/*.bnt']);
            for fileIndex=1:length(fileListing)
                [~,filename,~] = fileparts(fileListing(fileIndex).name);
                filename = [outputPath '/' filename '.xyz'];
                if exist(filename, 'file') ~= 2
                    currentFile = [currentSubdir '/' fileListing(fileIndex).name];
                    [data, ~, ~, ~, ~] = read_bntfile(currentFile);
                    data = data(abs(data(:,1)) <= OUTLIER & abs(data(:,2)) <= OUTLIER & abs(data(:,3)) <= OUTLIER,1:3);
                    dlmwrite(filename,data(:,1:3),'delimiter',' ','precision','%.3f');
                end
            end
        end
    end
end