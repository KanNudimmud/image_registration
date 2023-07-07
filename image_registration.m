%% Image Registration
% Sources:
% National Eye Institute
% National Institute on Aging
%% Geometric Transformations
% Load the data
early    = imread('earlyAMD.jpg');
advanced = imread('advancedAMD.jpg');

% Display them
figure(1)
imshowpair(advanced,early,'montage')
title('Original Images')

% Rotate advanced AMD (Age-related macular degeneration)
rotatedAdv = imrotate(advanced,90);

% Resize rotated advanced AMD to 10% larger
resizedAdv = imresize(rotatedAdv,1.1);

% Translate resized advanced AMD
shiftedAdv = imtranslate(resizedAdv,[5 10]);

% Display the last version with early AMD
figure(2)
imshowpair(shiftedAdv,early)
title('Geometrically Transformed Images')

%% Automating Registration
% Estimate the similarity transformation, advanced as moving, eary as fixed image
transAMD = imregcorr(advanced,early);

% Extract the transformation matrix
Tmat = transAMD.T;

% Apply the transformation
advTrans = imwarp(advanced,transAMD);

% Display auto-transformed advanced AMD
figure(3)
imshowpair(advTrans,early)
title('Auto-Transformed Advanced AMD')

%% Translation with Spatial Reference
% Extract size of images (moving and fixed)
movSize = size(advTrans);
fixSize = size(early);

% Create a spatial referencing object
spFixed = imref2d(fixSize);

% Transformation with spatial reference
advtransp = imwarp(advanced,transAMD,'OutputView',spFixed);

% Display spatially transformed advanced AMD
figure(4)
imshowpair(advtransp,early)
title('Spatially Transformed Advanced AMD')

%% What about more complex tranformations ?
%% Register Brain Scans with Control Points
% Load images
normal    = imread('normalBrain.png');
alzheimer = imread('alzheimerBrain.png');

% Display them
figure(5)
imshowpair(alzheimer,normal,'montage')
title('Alzheimer vs Normal Brain Scans')

% Define control points
normalP    = [173.375 377.375; 223.125 375.375; 81.875 126.125; 311.625 87.375];
alzheimerP = [155.375 357.375; 207.625 360.875; 71.375 134.625; 293.925 121.575];

% Adjust control points for the moving image
alzheimerP = cpcorr(alzheimerP,normalP,alzheimer,normal);

% Create a geometric transformation
Tform = fitgeotrans(alzheimerP,normalP,'affine');

% Create a spatial reference
spFixed = imref2d(size(normal));

% Apply transformation
alzheimerTrans = imwarp(alzheimer,Tform,'OutputView',spFixed);

% Visualize transformation
figure(6)
imshowpair(normal,alzheimerTrans)
title('Purple Areas are brighter in Alzheimer')

%% end