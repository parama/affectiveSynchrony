function [ viableSegments, subsets ] = findRegions(subjectNumber,varargin)
%This function finds and plots viable periods of data.
% 
%   function takes in optional arguments specifying threshold, and minimum
%   time window in minutes. 
%   Criteria is as follows: 
%     - readings must be continuously present in one column for a minimum of 5 minutes
%     - readings must be of valid level (above .45)
%     - readings must go on for at least 5 minutes, or 600 points since
%     readings are taken every half second

thresh = .45;
minWin = 600;

if nargin==2
    thresh = varargin(1);
end
if nargin==3
    thresh = varargin(1);
    minWin = varargin(2)*120; %measurements were taken at half second intervals
end
    
lookup = 'ABCDFGHIJKLMNOPQRSTUVX';
subID = subjectNumber-1
%load subject's file
load(sprintf('%s0.xls.mat',lookup(subjectNumber)));

cf1 = eval(sprintf('Child_EDA_Foot_1_%d',subID));
cf2 = eval(sprintf('Child_EDA_Foot_2_%d',subID));
of1 = eval(sprintf('OT_EDA_Foot_1_%d',subID));
of2 = eval(sprintf('OT_EDA_Foot_2_%d',subID));
ses = eval(sprintf('Session_%d',subID));

%0)split by session number

%find indices where we switch to a new session and store them
numSessions = max(ses)+1;
sesIndices = ones(numSessions,2);
sesIndices(numSessions,2)=length(ses);
for i=2:length(ses)
    if ses(i)>ses(i-1)
        sesIndices(ses(i)+1,1)=i;
        sesIndices(ses(i-1)+1,2)=i-1;
    end
end

%1)filter out any cells with readings below the correct level: we change
%these to boolean matrices with 1's for cells that contain a valid value

tcf1 = cf1>thresh;
tcf2 = cf2>thresh;
tof1 = of1>thresh;
tof2 = of2>thresh;

tmat = cat(2,tcf1,tcf2,tof1,tof2);

%2)loop through and find subarray first and last indices of segments of
%appropriate length, filtering through by session

intervals = {}; %first by column number, then session number, then list of stored pairs;
for i=1:4
    intervals{i}={};
    temp = {};
    for j=1:numSessions
        seslen = sesIndices(j,2)-sesIndices(j,1)+1;
        sesOffset = sesIndices(j,1)-1;
        sesB=sesIndices(j,1);
        sesE=sesIndices(j,2);
        count = 0;
        curPair = [1,1];
        temp{j}=[];
        for k=1:seslen-1
            if tmat(k+sesOffset,i)==1
                if count==0
                    curPair(1,1)=k+sesOffset;
                end
                count = count+1;
            else
                if count>(minWin-1)
                    curPair(1,2)=k+sesOffset;
                    temp{j}=cat(1,temp{j},curPair);
                    curPair = [1,1];
                end
                count =0;
            end
        end
    end
    intervals{i}=temp;
end
            
         
viableSegments = intervals;                   
            
        

%3)compare to other arrays to find intersecting intervals of interest

shorter = []; longer = [];
subsets = {};
for i=1:2 %for each foot on the child
    subsets{i}= {};
    for p=3:4
        subsets{i}{p-2}=[];
        temp = [];
        for j=1:numSessions
            %check whether there were any viable options at all for o1
%             numViableCsess = length(intervals{i}{j})
%             numViableOsess = length(intervals{p}{j})
            if((length(intervals{i}{j})>0)&&(length(intervals{p}{j})>0))
%                 conditionWasFlagged = 1
%                 cranges = intervals{i}{j}
%                 otranges = intervals{p}{j}
                %figure out which one is shorter
                if(length(intervals{i}{j})>length(intervals{p}{j}))
                    shorter = intervals{p}{j};
                    longer = intervals{i}{j};
                else
                    longer = intervals{p}{j};
                    shorter = intervals{i}{j};
                end
                
                for k=1:size(longer,1)
                    %we check whether this interval contains, or is contained
                    %in the interval we're iterating on
                    for q=1:size(shorter,1)
                        if ((longer(k,1)<shorter(q,1))&&((longer(k,2)>shorter(q,2))))
                            temp = cat(1,temp,longer(k,:));
                        end
                        if ((longer(k,1)>shorter(q,1))&&((longer(k,2)<shorter(q,2))))
                            temp = cat(1,temp,shorter(q,:));
                        end
                    end
                end
            end
        end
        subsets{i}{p-2} = temp;
    end
end
        
                


%4)store the foot of the child or ot, the start and end indices
%5)plot the subsegments for inspection






end

