x = zeros(10,1);
y = x;
x(1) = 1;
y(2) = 1;
X = fft(x);
Y = fft(y);
figure(1);
plot(real(X));
figure(2);
plot(real(Y));

