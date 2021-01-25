function [ Y ] = ybus_Matrix( ref_bus,Lines,w)
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here
%%  Bus Incidence Matrix
 Lines(:,4:19) = real(Lines(:,4:19))+1j*imag(Lines(:,4:19))*w;
 Lines(:,20:35) = real(Lines(:,20:35))+1j*imag(Lines(:,20:35))*w;
 Nbranch = size(Lines,1);
 Nbus = max(max(Lines(:,2:3)))-1;
 A = zeros(4*Nbranch, 4*Nbus);
 for n = 1:Nbranch
     a = Lines(n,2);
     b = Lines(n,3);
     A((4*n-3):4*n,(4*a-3):4*a)=1.*eye(4);
     if b == ref_bus
     else
     A((4*n-3):4*n,(4*b-3):4*b)=-1.*eye(4);
     end
     
 end
%  size(A)
%% Primittive Admittance Matrix
z = zeros(4*Nbranch)+1j*zeros(4*Nbranch);
b=1;
for n = 1:4:4*Nbranch
        temp_z1 = [Lines(b,4:7); Lines(b,8:11); Lines(b,12:15); Lines(b,16:19)];
%         disp(temp_z1);
        temp_z2 = [Lines(b,20:23); Lines(b,24:27); Lines(b,28:31);Lines(b,32:35)]; 
%         disp(temp_z2);
        z(n:n+3,n:n+3) = temp_z1(1:4,1:4);
        if Lines(b,36)==1
            a = Lines(b,37);
            z(n:n+3,4*a-3:4*a) = temp_z2;
            z(4*a-3:4*a,n:n+3) = temp_z2';
        end
        b = b+1;
end
y = inv(z);
% disp(y);
%% Bus Admittance Matrix
Y = A'*y*A;

end

