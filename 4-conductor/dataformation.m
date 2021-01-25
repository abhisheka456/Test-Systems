function [Lines,Loads,Voltages,YY,ref_bus] = dataformation(Feeder)
Topology = Feeder.Topology;
%% switches
ref = 1;
NumL = Feeder.NumL;
NumN = Feeder.NumN;
Lines = zeros(NumL,37);
Zlin = Feeder.ZLIN;
%%formation lines
Lines(:,1) = 1:NumL;
Lines(:,2) = Topology(:,1);
Lines(:,3) = Topology(:,2);
for i = 1:NumL
    Lines(i,4:7) = Zlin(1,:,Topology(i,4)).*Topology(i,3);
    Lines(i,8:11) = Zlin(2,:,Topology(i,4)).*Topology(i,3);
    Lines(i,12:15) = Zlin(3,:,Topology(i,4)).*Topology(i,3);
    Lines(i,16:19) = Zlin(4,:,Topology(i,4)).*Topology(i,3);
end
Lines(i+1,1:19) = [NumL+1,ref,NumN+1,999999999,0,0,0,0,999999999,0,0,0,0,999999999,0,0,0,0,999999999];
ref_bus = NumN+1;
Lines(:,4:end) = Lines(:,4:end)*Feeder.MVA./Feeder.Vnom.^2;
%% Voltage Intialization
Vnorm = Feeder.Vnom;
V1 = Feeder.Vpu_slack_phase;
b=exp(1i*4*pi/3);
c=exp(1i*2*pi/3);
Vnorm1 = [1,b,c,0.1];
Voltages = Vnorm1(ones(NumN,1),:); %Voltages(1,4) = 0;
% Voltages(ref,:) = V1;
%% load intialization
load = Feeder.Loads;
Loads  = zeros(NumN,14);
Loads(:,1) = 1:NumN;
Loads(2:end,2) = 2; %type;
Loads(load(:,1),9:14) = load(:,4:end);
%% YY formation
BLIN = Feeder.BLIN;
YY = zeros(1,4*NumN);
for i = 1:NumL
    YY(4*(Lines(i,2)-1)+1:4*Lines(i,2)) = YY(4*(Lines(i,2)-1)+1:4*Lines(i,2))+0.5*[BLIN(1,1,Topology(i,4)),BLIN(2,2,Topology(i,4)),BLIN(3,3,Topology(i,4)),BLIN(4,4,Topology(i,4))].*Topology(i,3);
    YY(4*(Lines(i,3)-1)+1:4*Lines(i,3)) = YY(4*(Lines(i,3)-1)+1:4*Lines(i,3))+0.5*[BLIN(1,1,Topology(i,4)),BLIN(2,2,Topology(i,4)),BLIN(3,3,Topology(i,4)),BLIN(4,4,Topology(i,4))].*Topology(i,3);
end
%% 
end