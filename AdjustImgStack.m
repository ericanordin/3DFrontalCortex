function [imgStackExtended] = AdjustImgStack(imgStack, extendLength)
%AdjustImgStack Extends whitespace to allow hemisphere mirroring.

%Input:
%imgStack contains the four fields outlined in AnatomyScript
%pivotPixel = furthest left pixel column

%Output:
%imgStackExtended is the new version of the imgStack

stackDimensions = size(imgStack);
stackDimensions(2) = stackDimensions(2) + extendLength; %New width
imgStackExtended = ones(stackDimensions);

imgStackExtended(:, extendLength+1:end, :) = imgStack;


%Extend white space


end

