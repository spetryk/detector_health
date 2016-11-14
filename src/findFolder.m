classdef findFolder
    
    methods(Static)
                
        function [x] = root()
            here = fileparts(mfilename('fullpath'));
            x = fileparts(here);
        end
        
        function [x] = source()
            x = fullfile(findFolder.root,'src');
        end
        
        function [x] = reports()
            x = fullfile(findFolder.root,'reports');
        end
        
        function [x] = data()
            x = fullfile(findFolder.root,'data\detector');
        end
        
        function [x] = midlink_count()
            x = fullfile(findFolder.root,'data\midlink_count');
        end
        
        function [x] = turning_count()
            x = fullfile(findFolder.root,'data\turning_count');
        end
        
        function [x] = bluetooth_travel_time()
            x = fullfile(findFolder.root,'data\bluetooth');
        end
        
        function [x] = simVehicle_data()
            x = fullfile(findFolder.root,'data\simVehData');
        end
        
        function [x] = config()
            x = fullfile(findFolder.root,'config');
        end
        
        function [x] = tests()
            x = fullfile(findFolder.source,'tests');
        end
        
        function [x] = temp()
            x = fullfile(findFolder.root,'temp');
        end
        
        function [x] = objects()
            x = fullfile(findFolder.root,'obj');
        end
        
        function [x] = outputs()
            x = fullfile(findFolder.root,'output');
        end
        
    end
    
end

