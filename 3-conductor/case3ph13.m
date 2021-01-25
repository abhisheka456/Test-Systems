function mpc = case3ph13
       Feeder = LoadFeeder('FEEDER IEEE13_SINREGULADOR.xlsx');
       [Lines,Loads,Voltages,YY,ref_bus] = dataformation(Feeder);
       VABASE = Feeder.MVA*1e6;
       mpc.Feeder = Feeder;
       mpc.Lines = Lines;
       mpc.Loads = Loads;
       mpc.Voltages = Voltages;
       mpc.Nbus = Feeder.NumN;
       mpc.YY = YY;
       mpc.ref_bus = ref_bus;
       %% Intial Voltage Vector
       a  = 1;
       mpc.V0 = zeros(3*mpc.Nbus,1);
       for n = 1:3:3*mpc.Nbus
           mpc.V0(n)   = Voltages(a,1);
           mpc.V0(n+1) = Voltages(a,2);
           mpc.V0(n+2) = Voltages(a,3);
           a = a+1;
       end
       %%  type of bus
       t = [Loads(:,2) Loads(:,2) Loads(:,2)]';
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
           mpc.Pg(n) = Loads(a,3)./VABASE;
           mpc.Pg(n+1) = Loads(a,5)./VABASE;
           mpc.Pg(n+2) = Loads(a,7)./VABASE;
           mpc.Qg(n) = Loads(a,4)./VABASE;
           mpc.Qg(n+1) = Loads(a,6)./VABASE;
           mpc.Qg(n+2) = Loads(a,8)./VABASE;
           a = a+1;
       end
       %% load pl and ql at every bus and phase
       mpc.Pl = zeros(3*mpc.Nbus,1);
       mpc.Ql = zeros(3*mpc.Nbus,1);
       a = 1;
       for n = 1:3:3*mpc.Nbus
           mpc.Pl(n) = Loads(a,9)./VABASE;
           mpc.Pl(n+1) = Loads(a,11)./VABASE;
           mpc.Pl(n+2) = Loads(a,13)./VABASE;
           mpc.Ql(n) = Loads(a,10)./VABASE;
           mpc.Ql(n+1) = Loads(a,12)./VABASE;
           mpc.Ql(n+2) = Loads(a,14)./VABASE;
           a = a+1;
       end
       %% droop busses
       mpc.nDG = 2;
       mpc.DGs = [1,10];
       mpc.mp  = [0.005,0.01];
       mpc.nq  = [0.05,0.01];
       mpc.w0   = 1;
end