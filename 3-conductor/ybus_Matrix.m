function [ Y ] = ybus_Matrix( ref_bus,Lines,w)
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here
%%  Bus Incidence Matrix
 Lines(:,4:12) = real(Lines(:,4:12))+1j*imag(Lines(:,4:12))*w;
 Lines(:,17:25) = real(Lines(:,17:25))+1j*imag(Lines(:,17:25))*w;
 No_of_branch = size(Lines);
 Size_of_matrix = 3.*No_of_branch(1);
 A = zeros(Size_of_matrix);
 for n = 1:Lines(No_of_branch(1),1)
     a = Lines(n,2);
     b = Lines(n,3);
     A((3*n-2):3*n,(3*a-2):3*a)=1.*eye(3);
     if b == ref_bus
     else
     A((3*n-2):3*n,(3*b-2):3*b)=-1.*eye(3);
     end
     
 end
%  size(A)
%% Primittive Admittance Matrix
z = zeros(Size_of_matrix)+1j*zeros(Size_of_matrix);
b=1;
for n = 1:3:3.*Lines(No_of_branch(1),1)
        temp_z1 = [Lines(b,4) Lines(b,5) Lines(b,6);Lines(b,7) Lines(b,8) Lines(b,9);Lines(b,10) Lines(b,11) Lines(b,12)];
%         disp(temp_z1);
        temp_z2 = [Lines(b,17) Lines(b,18) Lines(b,19);Lines(b,20) Lines(b,21) Lines(b,22);Lines(b,23) Lines(b,24) Lines(b,25)];
%         disp(temp_z2);
        z(n:n+2,n:n+2) = temp_z1(1:3,1:3);
        if Lines(b,13)==1
            a = Lines(b,14);
            z(n:n+2,3*a-2:3*a) = temp_z2;
            z(3*a-2:3*a,n:n+2) = temp_z2';
        end
        b = b+1;
end
y = inv(z);
% disp(y);
%% Bus Admittance Matrix
Y = A'*y*A;

end

