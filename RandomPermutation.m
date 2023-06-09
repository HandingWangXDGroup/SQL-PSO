function y=RandomPermutation(A)
 %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
 % return random permutation of matrix A
 % unlike randperm(n) that give permutation of integer 1:n only,
 % RandomPermutation rearrange member of matrix A randomly
 % This function is useful for MonteCarlo Simulation, 
 %  Bootstrap sampling, game, etc.
 % 
 % Copyright Kardi Teknomo(c) 2005
 % (http://people.revoledu.com/kardi/)
 %
 % example: A = [ 2, 1, 5, 3]
 % RandomPermutation(A) may produce [ 1, 5, 3, 2] or [ 5, 3, 2, 3]
 % 
 % example: 
 % A=magic(3)
 % RandomPermutation(A)
 %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
   [r,c]=size(A);
   b=reshape(A,r*c,1);       % convert to column vector
   x=randperm(r*c);          % make integer permutation of similar array as key
   w=[b,x'];                 % combine matrix and key
   d=sortrows(w,2);          % sort according to key
   y=reshape(d(:,1),r,c);    % return back the matrix
end