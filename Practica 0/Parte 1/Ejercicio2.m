clear
dim = input('Introduce la dimnesion de la matriz: ');
M   = randn(dim);
disp(' -  La matriz generada es:');
disp('==========================================');
disp(M);
disp(' -  La matriz de columnas impares:');
disp('==========================================');
A    = zeros(dim, uint16(dim/2));
cont = 1;
for x = 1:2:dim
    A(:,cont) = M(:,x);
    cont = cont + 1;
end
disp(A);
disp(' -  Valore de la diagonal de la matriz:');
disp('==========================================');
disp(diag(diag(M)));
figure(1);
hold on;
for x = 1:dim   
    scatter(x, min(M(x,:)), 'o', 'r');
    scatter(x, mean(M(x,:)),'x', 'k');
    scatter(x, var(M(x,:)), 'v', 'g');
    scatter(x, max(M(x,:)), 'o', 'b');
end 
axis([0 dim -inf inf]);
hold off;