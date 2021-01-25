function mpc = case3ph32_1_island
       Feeder = LoadFeeder('FEEDER32_four_1_islands.xlsx');
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
       mpc.V0 = zeros(4*mpc.Nbus,1);
       for n = 1:4:4*mpc.Nbus
           mpc.V0(n)   = Voltages(a,1);
           mpc.V0(n+1) = Voltages(a,2);
           mpc.V0(n+2) = Voltages(a,3);
           mpc.V0(n+3) = Voltages(a,4);
           a = a+1;
       end
       %%  type of bus
       t = [Loads(:,2) Loads(:,2) Loads(:,2) Loads(:,2)]';
       type(1:4*mpc.Nbus,1) = t(1:4*mpc.Nbus);
       mpc.pv = find(type == 1);
       mpc.pq = find(type == 2);
       mpc.npv = length(mpc.pv);
       mpc.npq = length(mpc.pq);
       %% load pgen and qgen in every bus and phase
       mpc.Pg = zeros(4*mpc.Nbus,1);
       mpc.Qg = zeros(4*mpc.Nbus,1);
       a = 1;
       for n = 1:4:4*mpc.Nbus
           mpc.Pg(n) = Loads(a,3)./VABASE;
           mpc.Pg(n+1) = Loads(a,5)./VABASE;
           mpc.Pg(n+2) = Loads(a,7)./VABASE;
           mpc.Qg(n) = Loads(a,4)./VABASE;
           mpc.Qg(n+1) = Loads(a,6)./VABASE;
           mpc.Qg(n+2) = Loads(a,8)./VABASE;
           a = a+1;
       end
       %% load pl and ql at every bus and phase
       mpc.Pl = zeros(4*mpc.Nbus,1);
       mpc.Ql = zeros(4*mpc.Nbus,1);
       a = 1;
       for n = 1:4:4*mpc.Nbus
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
       mpc.DGs = [2,3];
       mpc.mp  = [0.005,0.005];
       mpc.nq  = [0.05,0.05];
       mpc.w0   = 1;
       mpc.Pdg  = 5*ones(1,2)*1e-2;
       mpc.Qdg  = 3*ones(1,2)*1e-2;
       mpc.Z    = 10;
       mpc.Pref = mpc.Pdg/2;
       mpc.Qref = mpc.Qdg/2;
       mpc.Pmax = 2*mpc.Pdg;
       mpc.Pmin = 0;
       mpc.Qmax = 2*mpc.Qdg;
       mpc.Qmin = -0.5*mpc.Qdg;
end