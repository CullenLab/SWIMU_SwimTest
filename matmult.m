
% Multiply a single 3x3 matrix by an array of 3x3 matrices.

function Mout = matmult(M1, M2)

% Either matrix can be the array, but not both.
if size(M1,3) > 1
	% M1 is the array.
	N = size(M1, 3);
	Mout = zeros(size(M1));
	for i=1:N
		Mout(:,:,i) = M1(:,:,i) * M2;
	end
	
else
	% M2 is the array.
	N = size(M2, 3);
	Mout = zeros(size(M2));
	for i=1:N
		Mout(:,:,i) = M1 * M2(:,:,i);
	end
end

end