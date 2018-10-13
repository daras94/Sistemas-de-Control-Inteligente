%Creacion de las matrices 
A1 = zeros(10,4);
A1(1,:)  = [0 2 10 7];
A1(2,:)  = [2 7 7 1];
A1(3,:)  = [1 9 0 5];
A1(4,:)  = [4 0 0 6];
A1(5,:)  = [2 8 4 1];
A1(6,:)  = [10 6 0 3];
A1(7,:)  = [2 6 4 0];
A1(8,:)  = [1 1 9 3];
A1(9,:)  = [6 4 8 2];
A1(10,:) = [0 3 0 9];
b1 = [90 ; 59 ; 15 ; 10 ; 80 ; 17 ; 93 ; 51 ; 41 ; 76];

%Segundo sistema
A2 = zeros(10,4);
A2(1,:)  = [0.110 0 1 0];
A2(2,:)  = [0 3.260 0 1];
A2(3,:)  = [0.425 0 1 0];
A2(4,:)  = [0 3.574 0 1];
A2(5,:)  = [0.739 0 1 0];
A2(6,:)  = [0 3.888 0 1];
A2(7,:)  = [1.054 0 1 0];
A2(8,:)  = [0 4.202 0 1];
A2(9,:)  = [1.368 0 1 0];
A2(10,:) = [0 4.516 0 1];
b2 = [317 ; 237 ; 319 ; 239 ; 321 ; 241 ; 323 ; 243 ; 325 ; 245];

%Apartado a
condA1 = cond(A1);
condA2 = cond(A2);

%Apartado b
pinvSolA1 = pinv(A1)*b1;
pinvSolA2 = pinv(A2)*b2;

linSolA1 = linsolve(A1,b1);
linSolA2 = linsolve(A2,b2);

%Apartado c