sets

i 'generators'    / type-1, type-2, type-3 /
t ' hydro generators'    / type-A, type-B /
k 'periods'       / 12pm-6am, 6am-9am, 9am-3pm, 3pm-6pm, 6pm-12pm /
a 'number of 12 generators from type 1'       / 1*12 /
b 'number of 10 generators from type 2'       / 1*10 /
c 'number of 5 generators from type 3'        / 1*5 /;

parameters
CMax(i) Maximum Production level of generator i / type-1 2000 ,type-2 1750 ,type-3 4000 /
Cmin(i) Minimum Production level of generator i / type-1 850 ,type-2 1250 ,type-3 1500 /
h(k) Duration of period k / 12pm-6am 6 ,6am-9am 3 ,9am-3pm 6 ,3pm-6pm 6 ,6pm-12pm 6 /
W(i) Cost per hour at minimum production level for generator i / type-1 1000 , type-2 2600 ,type-3 3000 /
F(i) Initial cost of generator i / type-1 2000 , type-2 1000 ,type-3 500/
V(i) Cost per MW at maximum production level for generator i /type-1 2 , type-2 1.3 ,type-3 3 /
D(k) Demand in period k / 12pm-6am 15000 ,6am-9am 30000 ,9am-3pm 25000 ,3pm-6pm 40000 ,6pm-12pm 27000 /
U(t) The reduction rate of tank depth per hour for hydro generator t / type-A 0.31, type-B 0.47 /
P(t) Operational level of hydro generator t / type-A 900, type-B 1400 /
CP(t) Cost per hour for hydro generator t / type-A 90, type-B 150 /
M(t) Initial cost of hydro generator t / type-A 1500, type-B 1200 /

Variable
Z          'total operating cost'

positive variable
X1(a, k) 
X2(b, k)
X3(c, k)
H1(a, k)
H2(b, k)
H3(c, k)
E1(a, k)
E2(b, k)
E3(c, k)
R1(a, k)
R2(b, k)
R3(c, k)
S1(a, k)
S2(b, k)
S3(c, k)
G(k)

binary variables
Y1(a, k)
Y2(b, k)
Y3(c, k)
O1(a, k)
O2(b, k)
O3(c, k)
L1(a, k)
L2(b, k)
L3(c, k)
Q(t, k)
QP(t, k)
QN(t, k)
N(t, k);

equations

total_cost       'objective'
constraint1
constraint2
constraint3
constraint4
constraint5
constraint6
constraint7
constraint8
constraint9
constraint10
constraint11
constraint12
constraint13
constraint14
constraint15
constraint16
constraint17
constraint18
constraint19
constraint20
constraint21
constraint22
constraint23
constraint24
constraint25
;

total_cost .. z =e= sum((a,k), O1(a,k) * F('type-1'))
                 + sum((b,k), O2(b,k) * F('type-2'))
                 + sum((c,k), O3(c,k) * F('type-3'))
                 + sum((a,k), H1(a,k) * V('type-1'))
                 + sum((b,k), H2(b,k) * V('type-2'))
                 + sum((c,k), H3(c,k) * V('type-3'))
                 + sum((a,k), h(k) * W('type-1') * Y1(a,k))
                 + sum((b,k), h(k) * W('type-2') * Y2(b,k))
                 + sum((c,k), h(k) * W('type-3') * Y3(c,k))
                 + sum((t,k), CP(t) * h(k) * QP(t,k))
                 + sum((t,k), M(t) * N(t,k));

constraint1(k) .. sum(a, S1(a,k)) + sum(b, S2(b,k)) + sum(c, S3(c,k)) + sum(t, P(t) * Q(t, k)) =g= D(k);
constraint2(a, k) .. X1(a, k) =l= CMax('type-1') * Y1(a, k);
constraint3(b, k) .. X2(b, k) =l= CMax('type-2') * Y2(b, k);
constraint4(c, k) .. X3(c, k) =l= CMax('type-3') * Y3(c, k);
constraint5(a, k) .. CMin('type-1') * Y1(a, k) =l= X1(a, k);
constraint6(b, k) .. CMin('type-2') * Y2(b, k) =l= X2(b, k);
constraint7(c, k) .. CMin('type-3') * Y3(c, k) =l= X3(c, k);
constraint8(a, k) .. Y1(a, k) =l= Y1(a--1, k);
constraint9(b, k) .. Y2(b, k) =l= Y2(b--1, k);
constraint10(c, k) .. Y3(c, k) =l= Y3(c--1, k);
constraint11(a, k) .. H1(a, k) - E1(a, k) =e= X1(a, k) - Cmin('type-1');
constraint12(b, k) .. H2(b, k) - E2(b, k) =e= X2(b, k) - Cmin('type-2');
constraint13(c, k) .. H3(c, k) - E3(c, k) =e= X3(c, k) - Cmin('type-3');
constraint14(a, k) .. O1(a, k) - L1(a, k) =e= Y1(a, k) - Y1(a, k--1);
constraint15(b, k) .. O2(b, k) - L2(b, k) =e= Y2(b, k) - Y2(b, k--1);
constraint16(c, k) .. O3(c, k) - L3(c, k) =e= Y3(c, k) - Y3(c, k--1);
constraint17(k) .. G(k) =g= 15;
constraint18(k) .. G(k) =l= 20;
constraint19(k) .. G(k) =e= G(k--1) - sum(t, Q(t, k)* U(t)*h(k)) + ((sum(a, R1(a, k))+ sum(b, R2(b, k))+sum(c, R3(c, k))/3000) * h(k));
constraint20(k) .. G('12pm-6am') =e= 16;
constraint21(a, k) .. X1(a, k) =e= R1(a, k) + S1(a, k);
constraint22(b, k) .. X2(b, k) =e= R2(b, k) + S2(b, k);
constraint23(c, k) .. X3(c, k) =e= R3(c, k) + S3(c, k);
constraint24(t, k) .. QP(t ,k) - QN(t, k) =e= Q(t, k) - Q(t, k--1);
constraint25(k) .. sum(a, Y1(a,k) * CMax('type-1')) + sum(b, Y2(b,k) * CMax('type-2')) + sum(c, Y3(c,k) * CMax('type-3')) + sum(t, P(t)) =g= 1.15 * D(k);


Model Power_Geneneration / all /;
Power_Geneneration.optCr = 0;

* Now we do the Sensitivity Analysis: (the result of this step is available in the "Solution Report" provided by GAMS)

$onecho > cplex.opt
objrng all
rhsrng all
$offecho
Power_Geneneration.optfile = 1;

* and at last to solve the model we have:

solve Power_Geneneration minimizing Z using mip;
display X1.l, X2.l, X3.l,
        Y1.l, Y2.l, Y3.l,
        Q.l, G.l,
        Z.l;