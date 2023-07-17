% https://dsp.stackexchange.com/questions/76154/find-coefficients-of-optimal-wiener-filter-of-length-2

L = 1000; % number of samples
d = randn(1, L); % desired signal
x = filter(1, [1, -0.6], d); % input signal

N = 2;  % filter length
p = zeros(N, 1); % cross-correlation vector
R = zeros(N, N); % autocorrelation matrix

for n = N:L
    xx = x(n:-1:n-N+1).'; % input vector
    p = p + xx * d(n);
    R = R + xx * xx.';
end
p = p / L;
R = R / L;
w = R \ p;