classdef midlink_count_provider 
    properties
        
        inputFolderLocation             % Folder that stores the midblock counts

    end
    
    methods ( Access = public )

        function [this]=midlink_count_provider(inputFolderLocation)
            %% This function is to obtain the midblock counts
            
            % Obtain inputs
            if nargin==0 % Default input folder
                this.inputFolderLocation=findFolder.temp;
            else
                this.inputFolderLocation=inputFolderLocation; % Get the input folder
                if(nargin>1)
                    error('Too many inputs!')
                end
            end             
        end
         
        function [data_out]=get_data_for_a_date(this,fileName, queryMeasures)
            % This function is to get data for a particular date
          
            % Load data file
            dataFile=fullfile(this.inputFolderLocation,fileName);
            
            data_out=[];
            if(exist(dataFile,'file'))
                load(dataFile); % Inside: dataAll
                dateID=datenum(sprintf('%d-%d-%d',queryMeasures.year,queryMeasures.month,queryMeasures.day));
                
                % Get data for that date
                idx=(dataAll(:,1)==dateID);
                data=dataAll(idx,:);
                
                if(~isempty(data)) % Have data
                    if(queryMeasures.timeOfDay(end)>0) % Return time of day's data
                        startTime=queryMeasures.timeOfDay(1);
                        endTime=queryMeasures.timeOfDay(2);
                        
                        idx1=(data(:,2)>=startTime);
                        idx2=(data(:,2)<endTime);
                        idx=(idx1+idx2==2);
                        
                        data_out.time=data(idx,2);
                        data_out.volume=data(idx,3);
                    end
                end
            else
                fprintf('No such a data file:%s\n',fileName);
            end
        end
        
        function [data_out]=clustering(this,fileName, queryMeasures)
            % This function is for data clustering
            
            % Load data file
            dataFile=fullfile(this.inputFolderLocation,fileName);
            
            data_out=[];
            if(exist(dataFile,'file'))
                load(dataFile); % Inside: dataAll                
                [data_out]=midlink_count_provider.cluster_data_by_query_measures(dataAll,queryMeasures);
            else
                fprintf('No such a data file:%s\n',fileName);
            end  
        end
        
    end
   
    methods(Static)
        function [data_out]=cluster_data_by_query_measures(dataFile,queryMeasures)
            % This function is to cluster the data by query measures
            
            if(~isnan(queryMeasures.year))
                byYear=quaryMeasures.year; % Get the year
            else
                byYear=0; % False
            end
            if(~isnan(queryMeasures.month))
                byMonth=queryMeasures.month; % Get the Month
            else
                byMonth=0; % False
            end
            
            if(~isnan(queryMeasures.dayOfWeek))
                dayOfWeek=queryMeasures.dayOfWeek; % Get the number of day: Sunday=1; ... Saturday=7
            else
                dayOfWeek=0; % False
            end
            
            if(~isnan(queryMeasures.timeOfDay))
                % Get the time of day interval in seconds: [beginTime, endTime]
                timeOfDay=queryMeasures.timeOfDay;
            else
                timeOfDay=0; % False
            end

            % By year?
            years=year(dataFile(:,1)); 
            if (byYear>0)
                idx=(years==byYear);
                dataFile=dataFile(idx,:);
                clear idx
            end
            
            % By month?
            months=month(dataFile(:,1));            
            if (byMonth>0)
                idx=(months==byMonth);
                dataFile=dataFile(idx,:);
                clear idx
            end
            
            % By day of week? Weekday? Weekend?
            days=weekday(dataFile(:,1));
            if (dayOfWeek>0)
                if(dayOfWeek==8) % Weekday
                    idx=(days==1 | days==7);
                    idx=(idx==0);
                elseif(dayOfWeek==9) % Weekend
                    idx=(days==1 | days==7);
                else % day of week
                    idx=(days==dayOfWeek);
                end
                dataFile=dataFile(idx,:);
                clear idx
            end

            % Using median values
            if(queryMeasures.median)
                useMedian=1;
            else
                useMedian=0;
            end
            
            if (isempty(dataFile)) % No corresponding data
                data_out=[];
            else
                data_out=midlink_count_provider.get_time_of_day_data(dataFile,timeOfDay,useMedian);
            end            
        end

        function [data_out]=get_time_of_day_data(data,timeOfDay,useMedian)
            % This function is to get the data for time of day
            % Columns: date, time, volume

            % Get unique times
            time=sort(unique(data(:,2)));
            
            data_out=[];
            if(~isempty(time))
                volume=zeros(size(time));
                for i=1:length(time)
                    idx=(data(:,2)==time(i));
                    
                    if(useMedian) % Use the median values
                        volume(i)=median(data(idx,3),1,'omitnan');
                    else
                        volume(i)=mean(data(idx,3),1,'omitnan');
                    end
                end
                
                if(timeOfDay(end)>0) % Return time of day's data
                    startTime=timeOfDay(1);
                    endTime=timeOfDay(2);
                    
                    idx=(time>=startTime & time<endTime);
                    
                    time=time(idx);
                    volume=volume(idx,:);
                    
                    if(~isempty(time))
                        data_out.time=time;
                        data_out.volume=volume;
                    end
                else
                    data_out.time=time;
                    data_out.volume=volume;
                end
            end
            
        end
    end
end
