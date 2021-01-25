function mpc = case3ph205
       sc = 5;
       Feeder = LoadFeeder('FEEDER IEEE37_SINREGULADOR.xlsx');
       [Lines,Loads,Voltages,YY,ref_bus] = dataformation(Feeder);
       VABASE = Feeder.MVA*1e6;
       mpc.Feeder = Feeder;
       mpc.Nbus = Feeder.NumN.*(1+sc)-sc;
       mpc.ref_bus = mpc.Nbus+1;
       mpc.Lines = Lines(1:34, :);
       mpc.Loads = Loads;
       mpc.Voltages = Voltages;
       for i = 1:sc
           mpc.Lines = [mpc.Lines;[Lines(1:34,1:3)+34*i,Lines(1:34,4:end)]];
           mpc.Loads = [mpc.Loads;[Loads(2:end,1)+34*i,Loads(2:end,2:end)]];
           mpc.Voltages = [mpc.Voltages;Voltages(2:end,:)];
       end
       mpc.Lines = [mpc.Lines;[mpc.Nbus,1,mpc.Nbus,Lines(35,4:end)]];
       mpc.YY = zeros(1,3*mpc.Nbus);
       %% Intial Voltage Vector
       a  = 1;
       mpc.V0 = zeros(3*mpc.Nbus,1);
       for n = 1:3:3*mpc.Nbus
           mpc.V0(n)   = mpc.Voltages(a,1);
           mpc.V0(n+1) = mpc.Voltages(a,2);
           mpc.V0(n+2) = mpc.Voltages(a,3);
           a = a+1;
       end
       %%  type of bus
       t = [mpc.Loads(:,2) mpc.Loads(:,2) mpc.Loads(:,2)]';
       type(1:3*mpc.Nbus,1) = t(1:3*mpc.Nbus);
       mpc.pv = find(type == 1);
       mpc.pq = find(type == 2);
       mpc.npv = length(mpc.pv);
       mpc.npq = length(mpc.pq);
       %% load pgen and qgen in every bus and phase
       mpc.Pg = zeros(3*mpc.Nbus,1);
       mpc.Qg = zeros(3*mpc.Nbus,1);
       a = 1;
       for n = 1:3:3*mpc.Nbus
           mpc.Pg(n) = mpc.Loads(a,3)./VABASE;
           mpc.Pg(n+1) = mpc.Loads(a,5)./VABASE;
           mpc.Pg(n+2) = mpc.Loads(a,7)./VABASE;
           mpc.Qg(n) = mpc.Loads(a,4)./VABASE;
           mpc.Qg(n+1) = mpc.Loads(a,6)./VABASE;
           mpc.Qg(n+2) = mpc.Loads(a,8)./VABASE;
           a = a+1;
       end
       %% load pl and ql at every bus and phase
       mpc.Pl = zeros(3*mpc.Nbus,1);
       mpc.Ql = zeros(3*mpc.Nbus,1);
       a = 1;
       for n = 1:3:3*mpc.Nbus
           mpc.Pl(n) = mpc.Loads(a,9)./VABASE;
           mpc.Pl(n+1) = mpc.Loads(a,11)./VABASE;
           mpc.Pl(n+2) = mpc.Loads(a,13)./VABASE;
           mpc.Ql(n) = mpc.Loads(a,10)./VABASE;
           mpc.Ql(n+1) = mpc.Loads(a,12)./VABASE;
           mpc.Ql(n+2) = mpc.Loads(a,14)./VABASE;
           a = a+1;
       end
       %% droop busses
       mpc.nDG = 5*(sc+1);
       mpc.DGs = [3,7,11,21,34];
       mpc.mp  = [0.005,0.01,0.05,0.005,0.01];
       mpc.nq  = [0.05,0.01,0.001,0.01,0.05];
       for i = 1:sc
           mpc.DGs = [mpc.DGs,[3,7,11,21,34]+34*i];
           mpc.mp = [mpc.mp,[0.005,0.01,0.05,0.005,0.01]];
           mpc.nq = [mpc.nq,[0.05,0.01,0.001,0.01,0.05]];
       end
       mpc.w0   = 1;
end