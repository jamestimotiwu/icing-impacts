      
% Original Program Name:
%         SegmentationParticlesBasicDataAtEachFrame_OptimizedVersion.m
% Name changed after modifications were made to:
%                    ParticlesBasicDataAtEachFrame_Run_71
% All unnecessary comments were removed
% It is a program for analysis of the data from the PSU Experiment
% It gives the basic data for all particles in each given frame
%
%                      Program ID: ML_005
% 
%                 November 9 of 2013 - 9:11 hrs
%                      
% 
%
%oooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooo
%-------------- 0-clear all and close all to avoid problems --------------%
clear all;
close all;

%oooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooo
%--------------------- 1-PARAMETER INICIALIZATION ------------------------%
% Basic Initialization Parameters 
% RunNumber = '112114_Run_001_5psi';
RunNumber = '010615_Run_01_5psi';
ThresholdUsed = 0.72156862745098;
connectivity = 8; 
%VideoClip = 'Movie_002-20psi_C002.avi'; % video clip to be used
res = 48.46;           % resolution from image with ruler in pixels per mm
FrameRate = 96000;     % camera frame rate in frames per second
DT = (1/FrameRate)*1000000; % time per frame given in microseconds

% Elements below an area of P pixels are deleted after threshold for 
% connectivity 4 and 8 in lines 185, 187 and 423
P = 1;

% String for the nameof the Excel File where the data is going to be send
str1 = 'Segmentation 5psi-01.xlsx';

% String label for PATH of Excel file where the data is being saved 
% line 553
str2 = 'C:\Users\Maevargas\Documents\MATLAB\BALLISTIC LAB 4th Data Set\5psi\5psi-001\Segmentation 5psi-01.xlsx';

str3 = '6-Segmentation-Histograms for Each Frame/Histogram';
str4 = '7-Segmentation-Original Movie Frames Images/frame';
str5 = '8-Segmentation-Movie Frames Thresholded Images/frame';


% Strings to be used in output text files
OutputTxtFile01 = 'Segmentation_and_Parameters_Output_01.txt'; 
OutputTxtFile02 = 'Segmentation_and_Parameters_Output_02.txt'; 

% Wedge Angle
WedgeAngle = 45;
% initialize u
u = 1;                          
% Arbitrary number for Rosin-Rammler Distribution               
R = 50;
%Particle Diameter measured on impact image
ParticleDiam = 2.4948;       % in millimeters
ParticleDensity = 917 ;       % in kg/m^3
ParticleVelocity = 42.413;   % in m/sec
ParticleY = 5.2*1000000;      % MPa*1000000=Pascals = kg/(m*sec^2)
ParticleKc = 120*1000;        % (kN/m^3/2)*1000 = Newtons/m^3/2
ParticleA = 3838;             % in m/sec

%oooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooo                
%----------------- 2-Reading the avi video clip into obj -----------------%

% obj = VideoReader(VideoClip);
I = imread('5psi_13.tif');
I = imcrop(I,[1 1 6250 4380]);
%I = imcrop(I,[900 550 5100 3490]); crop used in data set #4
%I = imadjust(I);
%J = imadjust(I,[low_in; high_in],[low_out; high_out])

I8 = uint8(I / 256);
 
imwrite(I8,'01-I8 Original_Cropped.tif','compression','none');


I = imadjust(I,[0 0.04],[]);

I2 = I;
%figure, imshow(I)
%figure, imshow(I3)
I8 = uint8(I / 256);
imwrite(I8,'02-I8 Original_Cropped_BrightnessAdj.tif','compression','none');

%I = im2double(I);
% get(obj) displays all property names and their current values    


% nfo = get(obj); % save the parameters from get(obj) in nfo  
                 % To see the contents of nfo during a run just remove the 
                 % semicolon ";" or much better approach use dis(nf).
                 % To store them inside nfo without showing them
                 % during a run leave the ";".  To just remember about why
                 % is there, comment the line with %   
% disp(nfo)

%oooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooo
%----3-Reading the last frame and Finding number of frames in the clip ---%

% lastFrame = read(obj, inf);
% imshow(lastFrame)
% numframes = obj.NumberOfFrames;
% disp(numframes)

%oooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooo
%-- 4-Read frames 1 to numberframes, for each frame: if needed cropp it,--%
%         convert to grayscale,invert it, write to a intermediate.tif,
%                read it into the array array bw(:,:,k) 

% for k = numframes:-1:1
%I=read(obj,k);     % read frame
% imshow(I)        % imshow(I) displays the image I
                   % imshow always displays an image in the current figure. 
                   % If you display two images in succession, the second
                   % image replaces the first image. To view multiple
                   % figures with imshow, use the figure command to 
                   % explicitly create a new empty figure before calling
                   % imshow for the next image. For example, to view the
                   % first three frames in an array of grayscale images I,
                   % imshow(I(:,:,:,1))
                   % figure, imshow(I(:,:,:,2))
                   % figure, imshow(I(:,:,:,3))
                   % imshow(I(:,:,:,1))
                   % figure, imshow(I(:,:,:,2))
                   % figure, imshow(I(:,:,:,3))


                   
% I=read(obj,250);
               
%I = imcrop(I,[900 550 5500 3490]);   % crop frame
%imwrite(I,'1-I Original_NoCrop_BrightnessAdj.tif','compression','none');  
%figure,imshow(I),title('1-Original Image After Double')

   
%I2 = read(obj,k);
%I2 = imcrop(I2,[1 1 639 480]);   % crop frame

%I = imcrop(I,[1 101 190 310]);   % crop frame
% disp(I)                         % disp(X) displays an array, without
                                  % printing the array name. If X 
                                  % contains a text string, the string
                                  % is displayed.
% figure, imshow(I)
% size(I)                         % returns the sizes of each dimension of
                                  % array X 
% I = rgb2gray(I);                % In the PSU data clips I don't need to 
                                  % convert frame to grayscale.
% whos                            % gives complete information about all
                                  % the arrays and variables being used
% NOTE NOTE NOTE NOTE NOTE NOTE NOTE NOTE NOTE NOTE NOTE NOTE NOTE NOTE 
% I = InvertIm(I);                % For PSU frames we don't invert here

%Background = read(obj,BackgroundFrame); % assign to Background the frame 
                                        % chosen for the background subtr.
Background = imread('5psi baseline.tif');
Background = imcrop(Background,[1 1 6250 4380]);

%Background = im2double(Background);

Background = imadjust(Background,[0 0.04],[]);

%figure,imshow(Background),title('2-Background')

Background8 = uint8(Background / 256);
imwrite(Background8,'03-Background8_Croped_BrightnessAdj.tif','compression','none'); 

% Background = imcrop(Background,[1 1 639 480]);   % crop frame                                        
%I5=I-Background;
%figure,imshow(I5),title('I-Background without Invert')
%I6=InvertIm(I5);
%figure,imshow(I6),title('I-Background without Invert')
%Pause
%I3 = InvertIm(I);
%figure,imshow(I3),title('3-Original After Double+Invert')
%I4 = InvertIm(Background);
%figure,imshow(I4),title('4-Background After Double + Invert')
%figure, imshow(I3), title('2-Original Image after Inverted');
%figure, imshow(I4), title('3-Background Image after Inverted');
%BACKGROUND ADDITION OF 15 needed if background is less bright than the
%image
% Background = imadd(Background,15); 

Background8 = uint8(Background / 256);
imwrite(Background8,'04-Background8_Croped_BrightnessAdj_Imadd.tif','compression','none');
I = imsubtract(I,Background);                 % subtract the background
%I = I3 - I4;
%I = imsubtract(I4,I3);  
%I = InvertIm(I);
%figure,imshow(I), title('I-Image After Crop-ImageAdj-NO_INVERT-Background Substraction')
%I = imsubtract(I,10);
I8 = uint8(I / 256);
imwrite(I8,'05-I8 After Crop-ImAdj-BkgndSubt.tif','compression','none'); 


%I = imcrop(I,[900 550 5300 3490]);
%figure, imshow(I), title('6-Image I after Cropping')
%I = imsubtract(I,10);
%imwrite(I,'I After Invert-BkgndSubt-Cropping.tif','compression','none'); 
%I = imcomplement(I);                    % invert image using imcomplement
I = InvertIm(I); 
%figure, imshow(I), title('7-Image I After Invert')
I8 = uint8(I / 256);
imwrite(I8,'06-I8 After Crop-ImAdj-BkgndSubt-Invert.tif','compression','none'); 


% Thresholding.  If I use the command graythresh instead of a  fixed value
% given at initiallization (ThresholdUsed) then I need to use 
% ThresholdUsed = level because in the output I print ThresholdUsed
%I2 = imread('001_20psi_ImageJProcessedCropped.tif');
%I = I2;
%I = InvertIm(I);
level = graythresh(I);
ThresholdUsed = level;
%level = ThresholdUsed;
I = im2bw(I,level);                     % convert to double, scales it and 
                                        % threshold it

%I = bwareaopen(I,P,connectivity);       % removing elements with "connecti-
                                        % vity" and < P pixels;
                                        % connectivity is 4 or 8.  It is
                                        % chosen in the initialization

%I = imcomplement(I);
%I = imfill(I,'holes'); 

imwrite(I,'07-I After Crop-ImAdj-BkgndSubt-Thresh.tif','compression','none'); 

%figure, imshow(I), title('Image BEFORE filling holes')

%figure, imshow(I), title('Image AFTER filling holes')
%figure,imshow(I), title('8-Image After All done + Removing Elements<P-imcomplement again')
%j = numframes - k + 1;
%bw(:,:,j) = I;

Ior = I2;                  % original images after croopping but before


%end


%oooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooo
%------------------5- Initialize u and "build"  Matrix d ------------------

% u = 1;                           % initialize u

%for k = Nbtrack:1:Nhit
k = 1;
%bw5 = bw(:,:,k);                  % assigning to bw5 the frame bw(:,:,k)
bw5 = InvertIm(I);
%figure, imshow(bw5)
imwrite(I,'08-bw5 Ready for Segmentation.tif','compression','none'); 
Ior5 = Ior;
%bw5 = bwareaopen(bw5,P,8);        % I remove elements < P pixels
cc = bwconncomp(bw5,connectivity);           % find objects using a connectivity = 8
r = cc.NumObjects;                % r = number of objects found
%figure,imshow(I), title('I for Segmentation')
r

%XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX

[L,N] = bwlabel(bw5,connectivity);

D = regionprops(L,'area','centroid',...
          'equivdiameter','perimeter','majoraxislength','minoraxislength');

% minimum area and the number of the element with it
particle_areas = [D.Area];
[min_area,idx] = min(particle_areas);
Nmin = idx;
particle = false(size(bw5));
particle(cc.PixelIdxList{idx}) = true;
Amin = min_area;
for j = 1:1:r
  A2 = D(j).Area;
     if A2 == Amin
     N2min = j;
     end
end

% maximum area and the number of the element with it
[max_area,idx] = max(particle_areas);
Nmax = idx;
particle = false(size(bw5));
particle(cc.PixelIdxList{idx}) = true;
Amax = max_area;
 for j = 1:1:r
  A2 = D(j).Area;
     if A2 == Amax
     N2max = j;
     end
 end

% Matrix d to be sent to the Excel Worksheet
for j =1:r
d{j,1} = RunNumber;   
d{j,2} = j;
d{j,3} = k;
d{j,4} = D(j).Area;
particle_areas = [D.Area];
[min_area,idx] = min(particle_areas);
Nmin = idx;
particle = false(size(bw5));
particle(cc.PixelIdxList{idx}) = true;
d{j,5} = Nmin;
d{j,6} = min_area;
[max_area,idx] = max(particle_areas);
Nmax = idx;
particle = false(size(bw5));
particle(cc.PixelIdxList{idx}) = true;
d{j,7} = Nmax;
d{j,8} = max_area;

w = [D.Area];
meanarea = mean(w);
d{j,9}  = meanarea;
medianarea = median(w);
d{j,10}  = medianarea;
stdarea = std(w);
d{j,11}  = stdarea;
d{j,12}  = D(j).Centroid(1);              % x-coordinate of the centroid
d{j,13}  = D(j).Centroid(2);              % y-coordinate of the centroid
d{j,14}  = D(j).EquivDiameter;

% calculation of fragment diameters, minimum diameter, maximum diameters,
% mean diameters
particle_diameters = [D.EquivDiameter];
[min_diameter,idx] = min(particle_diameters);
particle = false(size(bw5));
particle(cc.PixelIdxList{idx}) = true;
d{j,15} = min_diameter;
[max_diameter,idx] = max(particle_diameters);
particle = false(size(bw5));
particle(cc.PixelIdxList{idx}) = true;
d{j,16} = max_diameter;
w1 = [D.EquivDiameter];
meandiameter = mean(w1);
d{j,17} = meandiameter';
mediandiameter = median(w1);
d{j,18}  = mediandiameter;
d{j,19}  = D(j).Perimeter;
d{j,20}  = D(j).MajorAxisLength;
d{j,21} = D(j).MinorAxisLength;
d{j,22} = connectivity;
d{j,23} = ThresholdUsed;
d{j,24} = P; % P is the value when <P elements are removed after threshold
d{j,25} = res;
d{j,26} = FrameRate;
d{j,27} = WedgeAngle;



d{j,28} = (3.14159265359/6)*(D(j).EquivDiameter^3);% Volume based on equiv diam in pix^3
d{j,29} = ((3.14159265359/6)*(D(j).EquivDiameter^3))*((1/res)^3);% Volume in mm^3

ae = D(j).MajorAxisLength;
be = D(j).MinorAxisLength;
d{j,30} = (4/3)*3.14159265359*ae*be*(ae+be)*0.5;% Ellisoid Volume in pixels^3

d{j,31} = ((4/3)*3.14159265359*ae*be*(ae+be)*0.5)*((1/res)^3); % Ellipsoid Volume in mm^3


% Calculation of total area
AreaIntermedia = 0.0;
    for q = 1:1:r
    AreaTotal = AreaIntermedia + D(q).Area;
    AreaIntermedia = AreaTotal;
    end
d{j,32} = AreaTotal; % Total area in pixels^2
d{j,33} = AreaTotal*((1/res)^2); % Total area in mm^2
    
    % Calculation of total Volume
VolumeIntermedia = 0.0;
    for q = 1:1:r
    VolumeTotal = VolumeIntermedia + ( (3.14159265359/6)*(D(q).EquivDiameter^3));
    VolumeIntermedia = VolumeTotal;
    end
d{j,34} = VolumeTotal;% Total volume in pixels^3

d{j,35} = VolumeTotal*((1/res)^3);% Total volume in mm^3

  % Calculation of total Volume for ellipsoid
EVolumeIntermedia = 0.0;
    for q = 1:1:r
    ae = D(q).MajorAxisLength;
    be = D(q).MinorAxisLength;
    EVolumeTotal = EVolumeIntermedia + ((4/3)*3.14159265359*ae*be*(ae+be)*0.5);
    EVolumeIntermedia = EVolumeTotal;
    end


d{j,36} = EVolumeTotal;% Ellisoid Total volume in pixels^3

d{j,37} = EVolumeTotal*((1/res)^3); % Ellipsoid Total Volume in mm^3

% NOTE: Particle diameter is measured from the Photron camera high speed 
% movies.  The resolution for the side camera images is different than for 
% the image from the Prosilica.  Using the resolution for the Photron
% images the particle diameter is calculated in millimeters.
% Because we are going to compare to parameters calculated with the
% Prosilica, we are goingto use the Prosilica image resolutions "res".
% To avoid confussion with the two resolutions, the one for the Photron and
% the one for the Prosilica images, I use only the resolution for the
% Prosilica and the diameter of the particle in millimeters.

ParticleRes = res;  % temporary because the resolution for the high speed
                    % images from the side is different than for the Prosilica
d{j,38} = ParticleDiam*ParticleRes; % Particle Diameter measured on impact image, pixels
d{j,39} = ParticleDiam; % Particle Diameter in mm

d{j,40} = (3.14159265359/6)*((ParticleDiam*ParticleRes)^3); % Original particle volume in pixels
d{j,41} = (3.14159265359/6)*(ParticleDiam^3); % Original volume in mm^3

d{j,42} = ParticleVelocity; % Particle velocity in m/sec

d{j,43} = ParticleDensity; % Particle density in kg/m^3

d{j,44} = ((meandiameter/res)/ParticleDiam);% in millimeters each one

d{j,45} = ((max_diameter/res)/ParticleDiam);% in millimeters each one

d{j,46} = ParticleY/(ParticleDensity*(ParticleVelocity^2));% PI1

d{j,47} = ParticleKc/( ParticleDensity*(ParticleVelocity^2)*(( ParticleDiam*(1/1000))^0.5));% PI2

d{j,48} = ParticleA/ParticleVelocity; %PI3


end
%&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&
%&&&&&&&&&&&&&&&&&&&&&&&  Rosin-Rammler Distribution  &&&&&&&&&&&&&&&&&&&&&
%&&&&&&&&&&&&&&&&&&&&&&&                              &&&&&&&&&&&&&&&&&&&&&

particle_diameters = [D.EquivDiameter];
particle_areas = [D.Area];

% Calculation of total area
AreaIntermedia = 0.0;
    for q = 1:1:r
    AreaTotal = AreaIntermedia + D(q).Area;
    AreaIntermedia = AreaTotal;
    end

% Choose Delta Diameter, note R in the denominator is arbitrary chosen by 
% me and is part of the program initialization
% max_diameter and min_diamter are calculated  in lines 158-169
DeltaDiameter = (max_diameter - min_diameter)/R;

%--------------------------------------------------------------------------
% initialize Drossin
Drossin = min_diameter + DeltaDiameter;

% initialize counter
counter = 1;


for t = Drossin:DeltaDiameter:max_diameter 
BinInitial = 0.0;
for q = 1:1:r
    if D(q).EquivDiameter <t
       if D(q).EquivDiameter >= (t-DeltaDiameter) 
        CounterOfBin = BinInitial + 1;
        BinInitial = CounterOfBin;
        end
    end

end
DiametersPerBin(counter) = CounterOfBin;
DiametersFrequency(counter) = (DiametersPerBin(counter)/r)*100;
DDiameter(counter) = t-DeltaDiameter;
LNDDiameter(counter) = log(t-DeltaDiameter);
CounterOfBin = 0;
% NOTE: Warea, Wareafraction and Wdiam are row vectors.  To send them to
% the Excel Worksheet I need to move them to column vectors.  This is easy
% and is done for example in this way Warea = Warea'
counter = counter + 1;

end
% SENDING THE DATA FOR the Drossin-Rammler Distribution 
% TO THE EXCEL FILE worsheet u+1

s1 = {'Fragment Size','LN(Fragment Size','DiametersPerBin','DiametersFreq'};
s2 = {'pixels','Dimensionless','Dimensionles','Dimensionless'}; 
xlswrite(str1,s1,u,'BC1')
xlswrite(str1,s2,u,'BC2')
xlswrite(str1,DDiameter',u,'BC3')
xlswrite(str1,LNDDiameter',u,'BD3')
xlswrite(str1,DiametersPerBin',u,'BE3')
xlswrite(str1,DiametersFrequency',u,'BF3')
% NOTE THAT I USED Wdiam' and Wareafraction' to convert the vectors from 
% row to column.  In this way the value are in columns in the worksheet!!




%--------------------------------------------------------------------------
% initialize Drossin
Drossin = min_diameter + DeltaDiameter;

% initialize counter
counter = 1;

for t = Drossin:DeltaDiameter:max_diameter 
AreaFraction = 0.0;
for q = 1:1:r
    
    if D(q).EquivDiameter <= t
       AreaFraction = AreaFraction + D(q).Area;
    end
    
end

Warea(counter) = AreaFraction;
Wareafraction(counter) = Warea(counter)/AreaTotal;
Wdiam(counter) = t;
% NOTE: Warea, Wareafraction and Wdiam are row vectors.  To send them to
% the Excel Worksheet I need to move them to column vectors.  This is easy
% and is done for example in this way Warea = Warea'
counter = counter + 1;

end

% SENDING THE DATA FOR the Drossin-Rammler Distribution 
% TO THE EXCEL FILE worsheet u+1

s1 = {'Fragment Size','Area Fraction'};
s2 = {'pixels','Dimensionless'}; 
xlswrite(str1,s1,u,'AX1')
xlswrite(str1,s2,u,'AX2')
xlswrite(str1,Wdiam',u,'AX3')
xlswrite(str1,Wareafraction',u,'AY3')
% NOTE THAT I USED Wdiam' and Wareafraction' to convert the vectors from 
% row to column.  In this way the value are in columns in the worksheet!!
%&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&
%&&&&&&&&&&&&&&& End of Rosin-Rammler Distribution Calculation &&&&&&&&&&&&
%&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&


%ooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooo%
%---------- 6-Sending scaled and thresholded images to folder: -----------%
%                   Movie Frames Thresholded Images 
%             and then sending the images to Excel Worksheet
%              with the red label "All the Particles" inserted

bw5 = InvertIm(bw5);             % invert to show particles in black pixels
imwrite(bw5,'Frame 888.tif','compression','none');   
h = imread('Frame 888.tif');
f = figure('visible','off');imshow(h);
set(f, 'units', 'inches', 'pos', [0 0 4.93 3]);
hold on
% Send image to folder Movie Frame Images, file: "frameXXX.tif"
% where XXX is the frame number k and is written in the file name using 
% num2str(k)
saveas(f, [str5 num2str(k) '.tif']); 

%------------ Sending the Image to the Excel Worksheet -------------------%
%                  with red label"All theParticles" 
% Connect to Excel, make it visible
xl = actxserver('Excel.Application');
set(xl,'Visible',1);

% Open workbook Segmentation_and_Parameters_Output.xlsx
% First command that I used and worked to open workbook.  
% xl.Workbooks.Open ('C:\Users\Maevargas\Documents\MATLAB\PSU EXPERIMENT 
% DATA ANALYSIS - July 2013\Run 71 071113 Ice Particle Frames 333-357 After
% Impact\Segmentation_and_Parameters_Output.xlsx');
% open file (enter full pat');
% I changed for the command in Kiran Ch
% http://www.sapnaedu.in/write-to-excel-sheet-in-matlab/
% Workbook = invoke(xl.Workbooks,'Open','C:\Users\Maevargas\Documents
% \MATLAB\PSU EXPERIMENT DATA ANALYSIS - July 2013\
% Run 71 071113 Ice Particle Frames 333-357 After Impact\
% Segmentation_and_Parameters_Output.xlsx');
% It worked but I decided to use the command in 
% http://www.mathworks.com/matlabcentral/answers/2603

WB = xl.Workbooks.Open(fullfile(pwd,...
                     str1), 0, false);

% Get Worksheets object
WS = WB.Worksheets;

% Add after the last sheet
WS.Add([], WS.Item(WS.Count));

% Activate worksheet u
Sheets = xl.ActiveWorkbook.Sheets;
Sheet1 = get(Sheets, 'Item',u);
Sheet1.Activate

% Make xls equal to the active worksheet
xls = xl.ActiveSheet; 



h1 = im2uint8(h); % To change h1 form "logical' to to uint8.  If this is
                   % not done the insertion of text into the image won't
                   % work when using the function insertInImage below when
                   % obtainint hout
                   




%using function insertInImage.m to insert the title to the image

%h2 = insertInImage(h1, @()text(50,50,'All the Particles'),...
%                          {'fontweight','bold','color','r','fontsize',6});

f = figure('visible','off');imshow(h1);
set(f, 'units', 'inches', 'pos', [0 0 4.93 3]);
% set(f,'numbertitle','on','name','Particle 1') 
hold on
% Paste graphic object in the Excel Worksheet
print(f, '-dmeta'); xls.Range('BK20').PasteSpecial;

hold off
close(f)

% Closing and Saving the Workbook
% Information from web address:
% http://www.mathworks.com/matlabcentral/newsreader/view_thread/244473

xl.Workbooks.Item(str1).Save;

xl.Workbooks.Item(str1).Close;
invoke(xl,'Quit');



%ooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooo%
%------- 7-Sending to the Excel worksheet a pair of Images for each 
%           single ice particle.  One frame (on the left side) shows the
%           particle alone(in black), the other frame (on the right side)  
%            shows all the particles but the specific particle in red 
%            Labels for each frame are inserted in red color 
%




for q = Nmax

%if D(r).Area == Amax
% ---------- Frame with only the particle in black (left side) ------------

particle = false(size(bw5));
particle(cc.PixelIdxList{q})=true;
particle = InvertIm(particle);  

imwrite(particle,'Frame 333.tif','compression','none');   
h1 = imread('Frame 333.tif');
h = im2uint8(h1);  % To change h1 form "logical' to to uint8.  If this is
                   % not done the insertion of text into the image won't
                   % work when using the function insertInImage below when
                   % obtainint hout
                   
% creating an string array with titles to be inserted into images
% pnames = {'Particle 1', 'Particle 2', 'Particle 3', 'Particle 4',...
%          'Particle 5', 'Particle 6', 'Particle 7', 'Particle 8',...
%          'Particle 9', 'Particle 10', 'Particle 11', 'Particle 12',...
%          'Particle 13', 'Particle 14', 'Particle 15', 'Particle 16',...
%          'Particle 17', 'Particle 18', 'Particle 19', 'Particle 20',...
%          'Particle 21', 'Particle 22', 'Particle 23', 'Particle 24',...
%          'Particle 25', 'Particle 26', 'Particle 27', 'Particle 28',...
%          'Particle 29', 'Particle 30', 'Particle 31', 'Particle 32',...
%          'Particle 33', 'Particle 34', 'Particle 35', 'Particle 36',...
%          'Particle 37', 'Particle 38', 'Particle 39', 'Particle 40',...
%          'Particle 41', 'Particle 42', 'Particle 43', 'Particle 44',...
%          'Particle 45', 'Particle 46', 'Particle 47', 'Particle 48',...
%          'Particle 49', 'Particle 50'};

% Easier way of doing it:
for s = 1:1:r
    str11 = 'Particle';
    str12 = num2str(s);
    C = {str11,str12}; 
    str13 = strjoin(C);
    pnames(s) = {str13};
    % Note! I used C = {str11,str12} and str13 = strjoin(C)
    % Do not use strjoin(str11,str12) it will not work
    % Construct C first and then strjoin(C)
    %strjoin is used because it provides a space betweent the two strings
    % in order to for example Particle 13
end

%using function insertInImage.m to insert the title to the image
%hout = insertInImage(h, @()text(1,20,pnames{q}),...
%                          {'fontweight','bold','color','r','fontsize',20});

f = figure('visible','off');imshow(h);
set(f, 'units', 'inches', 'pos', [0 0 4.93 3]);
% set(f,'numbertitle','on','name','Particle 1') 
hold on


% Send image to folder Movie Frame Images, file: "frameXXX.tif"
% where XXX is the frame number k and is written in the file name using 
% num2str(k)
%saveas(f, ['Movie Frames Thresholded Images/frame' num2str(k) '.tif']); 


%--- Sending the frame with only the particle to the Excel Worksheet -----%

% Connect to Excel, make it visible
xl = actxserver('Excel.Application');
set(xl,'Visible',1);

% Open workbook Segmentation_and_Parameters_Output.xlsx
% First command that I used and worked to open workbook.  
% xl.Workbooks.Open ('C:\Users\Maevargas\Documents\MATLAB\
% PSU EXPERIMENT DATA ANALYSIS - July 2013
% Run 71 071113 Ice Particle Frames 333-357 After Impact\
% Segmentation_and_Parameters_Output.xlsx'); % open file (enter full pat');
% I changed for% the command in Kiran Ch
% http://www.sapnaedu.in/write-to-excel-sheet-in-matlab/
% Workbook = invoke(xl.Workbooks,'Open','C:\Users\Maevargas\
% Documents\MATLAB\PSU EXPERIMENT DATA ANALYSIS - July 2013\Run 71 071113 
% Ice Particle Frames 333-357 After Impact\
% Segmentation_and_Parameters_Output.xlsx');
% It worked but I decided to use the command in 
% http://www.mathworks.com/matlabcentral/answers/2603

WB = xl.Workbooks.Open(fullfile(pwd,...
                     str1), 0, false);

% Get Worksheets object
WS = WB.Worksheets;

% Activate worksheet u
Sheets = xl.ActiveWorkbook.Sheets;
Sheet1 = get(Sheets, 'Item',u);
Sheet1.Activate


% Make xls equal to the active worksheet
xls = xl.ActiveSheet; 
% Paste graphic object in the Excel Worksheet
%fnames = {'Q36','Q52', 'Q68','Q84', 'Q100', 'Q116','Q132','Q148',...
%          'Q164','Q180', 'Q196','Q212', 'Q228', 'Q244','Q260', 'Q276',...
%          'Q292','Q308', 'Q324','Q340', 'Q356', 'Q372','Q388', 'Q404',...
%          'Q420','Q436', 'Q452','Q468', 'Q484', 'Q500','Q516', 'Q532',...
%          'Q548','Q564', 'Q580','Q596', 'Q612', 'Q628','Q644', 'Q660',...
%          'Q676','Q692', 'Q708','Q724', 'Q740', 'Q756','Q772', 'Q788',...
%          'Q676','Q692'};

% initialize s1
s1 = 20;
% for loop to assign Y values
%for s = 1:1:r
    str11 = 'BK';
    s2 = s1+16;
    str12 = num2str(s2);
    str13 = strcat(str11,str12);
    fnames(q) = {str13};
  %s1 = s2;
    % Note! I used str13 = strcat(str11,str12) 
    % I did not used the intermedia C={str11,str12}
    % BECAUSE I have to use strcat(str11,str12) in order to have the two
    % strings joined together without any space in between and be able to 
    % for for example Y50.  With strjoin this will not be possible and you 
    % will end with Y 50 which will give an error in the print line below
    
%end
print(f, '-dmeta'); xls.Range(fnames{q}).PasteSpecial;

hold off
close(f)

% Closing and Saving the Workbook
% Information from web address:
% http://www.mathworks.com/matlabcentral/newsreader/view_thread/244473

xl.Workbooks.Item(str1).Save;

xl.Workbooks.Item(str1).Close;
invoke(xl,'Quit');  


%----Original thresholded image showing the q particle in red and all the - 
%           others in black with the red label "Particle XX".  
%                Send the image to the Excel worksheet
%            placed on the right of the image showing only the particle
labeled = labelmatrix(cc);

% let's build the cmap matrix
cmap = [ones(r,1),(1:r).'./r,(r:-1:1).'./r];

cmap(1:q-1,:)=0;
cmap(q+1:r,:)=0;
cmap(q,:)=[1, 0, 0];   % red color for element 50th

RGB_label = label2rgb(labeled,cmap);

figure, imshow(RGB_label)
title('RGB_label');

imwrite(RGB_label,'Frame 444.tif','compression','none');   
h5 = imread('Frame 444.tif');
 h6 = im2uint8(h5); % To change h1 form "logical' to to uint8.  If this is
                   % not done the insertion of text into the image won't
                   % work when using the function insertInImage below when
                   % obtainint hout


%!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!                   
% Segmented elements all in red color

  
for q = 1:1:r

cmap(q,:)=[1, 0, 0];   % red color for all                

end                    
RGB_label = label2rgb(labeled,cmap);

figure, imshow(RGB_label)
title('RGB_label');

imwrite(RGB_label,'Frame 445  All elements Red.tif','compression','none');   
%!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!

                   
               
                   
% creating an string array with titles to be inserted into images
%pnames = {'Particle 1', 'Particle 2', 'Particle 3', 'Particle 4',...
%          'Particle 5', 'Particle 6', 'Particle 7', 'Particle 8',...
%          'Particle 9', 'Particle 10', 'Particle 11', 'Particle 12',...
%          'Particle 13', 'Particle 14', 'Particle 15', 'Particle 16',...
%          'Particle 17', 'Particle 18', 'Particle 19', 'Particle 20',...
%          'Particle 21', 'Particle 22', 'Particle 23', 'Particle 24',...
%          'Particle 25', 'Particle 26', 'Particle 27', 'Particle 28',...
%          'Particle 29', 'Particle 30', 'Particle 31', 'Particle 32',...
%          'Particle 33', 'Particle 34', 'Particle 35', 'Particle 36',...
%          'Particle 37', 'Particle 38', 'Particle 39', 'Particle 40',...
%          'Particle 41', 'Particle 42', 'Particle 43', 'Particle 44',...
%          'Particle 45', 'Particle 46', 'Particle 47', 'Particle 48',...
%          'Particle 49', 'Particle 50'};

for s = 1:1:r
    str11 = 'Particle';
    str12 = num2str(s);
    C = {str11,str12};
    str13 = strjoin(C);
    pnames(s) = {str13};
    % Note! I used C = {str11,str12} and str13 = strjoin(C)
    % Do not use strjoin(str11,str12) it will not work
    % Construct C first and then strjoin(C)
    %strjoin is used because it provides a space betweent the two strings
    % in order to for example Particle 13
    
end

%using function insertInImage.m to insert the title to the image
%hout = insertInImage(h6, @()text(1,20,pnames{q}),...
%                          {'fontweight','bold','color','r','fontsize',20});

f6 = figure('visible','off');imshow(h6);
set(f6, 'units', 'inches', 'pos', [0 0 4.93 3]);
% set(f,'numbertitle','on','name','Particle 1') 
hold on


% Send image to folder Movie Frame Images, file: "frameXXX.tif"
% where XXX is the frame number k and is written in the file name using 
% num2str(k)
%saveas(f, ['Movie Frames Thresholded Images/frame' num2str(k) '.tif']); 

%------------ Sending the Image to the Excel Worksheet -------------------%

% Connect to Excel, make it visible
xl = actxserver('Excel.Application');
set(xl,'Visible',1);

% Open workbook Segmentation_and_Parameters_Output.xlsx
% First command that I used and worked to open workbook.  
% xl.Workbooks.Open ('C:\Users\Maevargas\Documents\MATLAB\
% PSU EXPERIMENT DATA ANALYSIS - July 2013\Run 71 071113 Ice Particle 
% Frames 333-357 After Impact\Segmentation_and_Parameters_Output.xlsx');
 % open file (enter full pat');
% I changed for% the command in Kiran Ch
% http://www.sapnaedu.in/write-to-excel-sheet-in-matlab/
% Workbook = invoke(xl.Workbooks,'Open','C:\Users\Maevargas\Documents
% \MATLAB\PSU EXPERIMENT DATA ANALYSIS - July 2013\Run 71 071113 Ice 
% Particle Frames 333-357 After Impact\
% Segmentation_and_Parameters_Output.xlsx');
% It worked but I decided to use the command in 
% http://www.mathworks.com/matlabcentral/answers/2603

WB = xl.Workbooks.Open(fullfile(pwd, ...
                     str1), 0, false);

% Get Worksheets object
WS = WB.Worksheets;

% Add after the last sheet
%WS.Add([], WS.Item(WS.Count));

% Activate worksheet u
Sheets = xl.ActiveWorkbook.Sheets;
Sheet1 = get(Sheets, 'Item',u);
Sheet1.Activate

% Make xls equal to the active worksheet
xls = xl.ActiveSheet; 
% Paste graphic object in the Excel Worksheet
%fnames = {'Y36','Y52', 'Y68','Y84', 'Y100', 'Y116','Y132', 'Y148',...
%          'Y164','Y180', 'Y196','Y212', 'Y228', 'Y244','Y260', 'Y276',...
%          'Y292','Y308', 'Y324','Y340', 'Y356', 'Y372','Y388', 'Y404',...
%          'Y420','Y436', 'Y452','Y468', 'Y484', 'Y500','Y516', 'Y532',...
%          'Y548','Y564', 'Y580','Y596', 'Y612', 'Y628','Y644', 'Y660',...
%          'Y676','Y692', 'Y708','Y724', 'Y740', 'Y756','Y772', 'Y788',...
%          'Y676','Y692'};

% initialize s1
s1 = 20;
% for loop to assign Y values
%for s = 1:1:r
    str11 = 'BK';
    s2 = s1+16;
    str12 = num2str(s2);
    str13 = strcat(str11,str12);
    fnames(q) = {str13};
    %s1 = s2;
    % Note! I used C = {str11,str12} and str13 = strjoin(C)
    % Do not use strjoin(str11,str12) it will not work
    % Construct C first and then strjoin(C)
    %strjoin is used because it provides a space betweent the two strings
    % in order to for example Particle 13
%end
print(f6, '-dmeta'); xls.Range(fnames{q}).PasteSpecial;

hold off
close(f6)

% Closing and Saving the Workbook
% Information from web address:
% http://www.mathworks.com/matlabcentral/newsreader/view_thread/244473

xl.Workbooks.Item(str1).Save;

xl.Workbooks.Item(str1).Close;
invoke(xl,'Quit');  


close all;
% end for if r==Nmax loop
%end
end

%ooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooo%
%----------- 8-Sending the Original Movie Images to the folder -----------%
%                       Original Movie Frames Images
%                      and then to the Excel Worksheet

imwrite(Ior5,'Frame 555.tif','compression','none');   
h5 = imread('Frame 555.tif');
f5 = figure('visible','off');imshow(h5);
set(f5, 'units', 'inches', 'pos', [0 0 4.93 3]);
hold on
% Send image to folder Movie Frame Images, file: "frameXXX.tif"
% where XXX is the frame number k and is written in the file name using 
% num2str(k)
saveas(f5, [str4 num2str(k) '.tif']); 

%------------ Sending the Image to the Excel Worksheet -------------------%

% Connect to Excel, make it visible
xl = actxserver('Excel.Application');
set(xl,'Visible',1);

% Open workbook Segmentation_and_Parameters_Output.xlsx
WB = xl.Workbooks.Open(fullfile(pwd, ...
                     str1), 0, false);

% Get Worksheets object
WS = WB.Worksheets;

% Activate worksheet u
Sheets = xl.ActiveWorkbook.Sheets;
Sheet1 = get(Sheets, 'Item',u);
Sheet1.Activate

% Make xls equal to the active worksheet
xls = xl.ActiveSheet; 

% Paste graphic object in the Excel Worksheet
print(f5, '-dmeta'); xls.Range('BK1').PasteSpecial;

hold off
close(f5)

% Closing and Saving the Workbook

xl.Workbooks.Item(str1).Save;

xl.Workbooks.Item(str1).Close;
invoke(xl,'Quit');

%ooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooo%
%------------ 9-Sending the Histograms to the Folder --------------------%
%                    Histograms for Each Frame
%                   and then to the Excel Worksheet
w = [D.Area];
figure
nbins = 20;
hist(w,nbins);
h2 = 'figure1.png';
print('-dpng',h2);
h2 = imread('figure1.png');
imwrite(h2,'Frame 999.tif','compression','none');   
f1 = imread('Frame 999.tif');
f2 = figure('visible','off');imshow(f1);

set(f2, 'units', 'inches', 'pos', [0 0 8 6]);

hold on
saveas(f2, [str3 num2str(k) '.tif']); 

% Connect to Excel, make it visible and add a worksheet
xl = actxserver('Excel.Application');
set(xl,'Visible',1);
% xl.Workbooks.Add(1);

% Open workbook
WB = xl.Workbooks.Open(fullfile(pwd, ...
                     str1), 0, false);


% Activate worksheet u
Sheets = xl.ActiveWorkbook.Sheets;
Sheet1 = get(Sheets, 'Item',u);
Sheet1.Activate


% Make xls equal to the active worksheet
xls = xl.ActiveSheet; 

% Paste graphic object in the MATLAB figures
print(f2, '-dmeta'); xls.Range('BS1').PasteSpecial;

hold off
close(f2)

% Closing and Saving the Workbook
% Information from web address:
% http://www.mathworks.com/matlabcentral/newsreader/view_thread/244473

xl.Workbooks.Item(str1).Save;

xl.Workbooks.Item(str1).Close;
invoke(xl,'Quit');

close all;
%oooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooo
%-------------- 10-Invert back to drop being white pixels -----------------
bw5 = InvertIm(bw5);             

%oooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooo
% 11------ SENDING THE DATA FOR EACH FOUND ICE PIECE IN A FRAME -----------
%                      TO THE EXCEL FILE
 
  s1 = {'Run Number','Particle Number','Frame Number','Area','Nmin','Minimum Area',...
                      'Nmax','Maximum Area','Mean Area','Median Area','Standard Dev',...
      'x-Centroid','y-Centroid','Equivalent Diameter','Minimum Diameter',...
      'Maximum Diameter','Mean Diameter','Median Diameter','Perimeter',...
    'MajorAxis Length','MinorAxis Length','Connectivity','ThresholdUsed',...
    'P','Resolution','FrameRate','Target Angle'...
    'Volume on EquivDiam','Volume on EquivDiam','Ellipsoid Volume','Ellipsoid Volume',...
    'Total Area','Total Area','Total Volume','Total Volume',...
    'Ellipsoid Total Volume','Ellipsoid Total Volume',...
    'Particle Diameter','Particle Diameter',...
    'Particle Volume','Particle Volume',...
    'Particle Velocity','Particle Density',...
    'MeanDiam/ParticleDiam','MaxDiam/ParticleDiam',...
    'PI1','PI2','PI3'};
  
s2 = {'Dimensionless','Dimensionless','Dimensionless','pixels','Dimensionless','pixels','Dimensionless','pixels',...
      'pixels','pixels','pixels','pixels','pixels','pixels','pixels','pixels',...
      'pixels','pixels','pixels','pixels',...
      'pixels','Dimensionless','Dimensionless','pixels','pixels per mm',...
      'fps','degrees',...
      'pixel^3','mm^3','pixels^3','mm^3',...
      'pixels','mm^2',...
      'pixel^3','mm^3','pixel^3','mm^3',...
      'pixels','mm',...
      'pixel^3','mm^3',...
      'm/sec','kg/m^3',...
      'dimensionless','dimensionless',...
      'dimensionless','dimensionless','dimensionless'}; 
     
  
xlswrite(str1,s1,u,'A1')
xlswrite(str1,s2,u,'A2')

xlswrite(str1,d,u,'A3')
%++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
% 12------ SENDING THE FRAGMENT AREA, SIZE AND VOLUME TO THE EXCEL
%             CORRESPONDING SHEETS together with the mean and
%                         median values
 
s1 = {'Fragments Area'};
s2 = {'pixels'}; 
s3 = {'Mean Area'};
s4 = {'Median Area'};
xlswrite(str1,s1,'Fragment Area','A1')
xlswrite(str1,s2,'Fragment Area','A2')
w5 = particle_areas;
w5 = w5(:);
xlswrite(str1,w5,'Fragment Area','A3')

xlswrite(str1,s3,'Fragment Area','B1')
xlswrite(str1,s2,'Fragment Area','B2')
w5a = meanarea ;
xlswrite(str1,w5a,'Fragment Area','B3')

xlswrite(str1,s4,'Fragment Area','C1')
xlswrite(str1,s2,'Fragment Area','C2')
w5b = medianarea ;
xlswrite(str1,w5b,'Fragment Area','C3')



s1 = {'Fragments Equivalent Diameter'};
s2 = {'pixels'}; 
s3 = {'Mean Equivalent Diameter'};
s4 = {'Median Equivalent Diameter'}; 
xlswrite(str1,s1,'Fragment Equiv Diameter','A1')
xlswrite(str1,s2,'Fragment Equiv Diameter','A2')
w6 = particle_diameters;
w6 = w6(:);
xlswrite(str1,w6,'Fragment Equiv Diameter','A3')

xlswrite(str1,s3,'Fragment Equiv Diameter','B1')
xlswrite(str1,s2,'Fragment Equiv Diameter','B2')
w6a = meandiameter;
xlswrite(str1,w6a,'Fragment Equiv Diameter','B3')

xlswrite(str1,s4,'Fragment Equiv Diameter','C1')
xlswrite(str1,s2,'Fragment Equiv Diameter','C2')
w6b = mediandiameter;
xlswrite(str1,w6b,'Fragment Equiv Diameter','C3')



s1 = {'Fragment Volume'};
s2 = {'pixels^3'}; 
s3 = {'Mean Fragment Volume'};
s4 = {'Median Fragment Volume'}; 
xlswrite(str1,s1,'Fragment Volume','A1')
xlswrite(str1,s2,'Fragment Volume','A2')
[w7]=( (3.14159265359/6)*(w6.^3));
xlswrite(str1,w7,'Fragment Volume','A3')


xlswrite(str1,s3,'Fragment Volume','B1')
xlswrite(str1,s2,'Fragment Volume','B2')
[w7]=( (3.14159265359/6)*(w6.^3));
w7a = mean(w7);
xlswrite(str1,w7a,'Fragment Volume','B3')

xlswrite(str1,s4,'Fragment Volume','C1')
xlswrite(str1,s2,'Fragment Volume','C2')
[w7]=( (3.14159265359/6)*(w6.^3));
w7b = median(w7);
xlswrite(str1,w7b,'Fragment Volume','C3')



%++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
%oooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooo
%----- 13-Advance the value of u and Reset the Matrix to zero Value  ------
%                  for next pass of the loop
u = u+1;
d(:,:) = []; % Reseting the matrix d to zero values

%end

%oooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooo


% End of Program
