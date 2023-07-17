function w_opt=WienerFilter(x,d,N)
% This function search for the Wiener Filter coefficients (optimum
% coefficients) based on the input signal x and desired signal d.
% N: filter length
L=length(x);

p = zeros(N, 1); % cross-correlation vector
R = zeros(N, N); % autocorrelation matrix

if size(x,2)>1
    x=x.';
end

for n = N:L
    xx = x(n:-1:n-N+1); % input vector
    p = p + xx * d(n);
    R = R + xx * xx.';
end
p = p / L;
R = R / L;
w_opt = R \ p;