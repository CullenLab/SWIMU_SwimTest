
% Compute a rotation matrix from a rotation about the X axis.

%  Address the R(,) matrix with 'component' and 'mouse vector'.
%  For instance, R(1,3) R(2,3) R(3,3) are X, Y, and Z component
%  of the mouse Z (up out of top of head) vector.

% i.e., each "column" is a vector. The rows contain the X,Y,Z components of
% that vector.

function MR = matrot_x(deg)
MR = [1          0   0;
	  0  cosd(deg)   -sind(deg);
	  0  sind(deg)   cosd(deg)];
end
