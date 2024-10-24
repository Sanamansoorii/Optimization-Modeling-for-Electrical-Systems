sets

i 'generators'    / type-1, type-2, type-3 /
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
D(k) Demand in period k / 12pm-6am 15000 ,6am-9am 30000 ,9am-3pm 25000 ,3pm-6pm 40000 ,6pm-12pm 27000 /;

Variable
Z          'total operating cost'

positive variable
X1(a, k) 'generator type-1 output'
X2(b, k) 'generator type-2 output'
X3(c, k) 'generator type-3 output'
H1(a, k) 'The amount of difference is greater than the minimum level'
H2(b, k) 'The amount of difference is greater than the minimum level'
H3(c, k) 'The amount of difference is greater than the minimum level'
E1(a, k) 'The amount of difference is less than the minimum level'
E2(b, k) 'The amount of difference is less than the minimum level'
E3(c, k) 'The amount of difference is less than the minimum level'

binary variables
Y1(a, k) 'generator type-1 is used in period k or not'
Y2(b, k) 'generator type-2 is used in period k or not'
Y3(c, k) 'generator type-3 is used in period k or not'
O1(a, k) 'The status of the generator type-1 compared to the previous period'
O2(b, k) 'The status of the generator type-2 compared to the previous period'
O3(c, k) 'The status of the generator type-3 compared to the previous period'
L1(a, k) 'The status of the generator type-1 compared to the previous period'
L2(b, k) 'The status of the generator type-2 compared to the previous period'
L3(c, k) 'The status of the generator type-3 compared to the previous period';



equations

total_cost       'objective'
constraint1      'Fulfil demands in each period constraint'
constraint2      'Maximum production level'
constraint3      'Maximum production level'
constraint4      'Maximum production level'
constraint5      'Minimum production level'
constraint6      'Minimum production level'
constraint7      'Minimum production level'
constraint8      'The generators should be turned on in order'
constraint9      'The generators should be turned on in order'
constraint10     'The generators should be turned on in order'
constraint11     'Usage above the minimum level'
constraint12     'Usage above the minimum level'
constraint13     'Usage above the minimum level'
constraint14     'The status of the generator compared to the previous period'
constraint15     'The status of the generator compared to the previous period'
constraint16     'The status of the generator compared to the previous period'
constraint17     '15% additional demands of electricity constraint'
;

total_cost .. z =e= sum((a,k), O1(a,k) * F('type-1'))
                 + sum((b,k), O2(b,k) * F('type-2'))
                 + sum((c,k), O3(c,k) * F('type-3'))
                 + sum((a,k), H1(a,k) * V('type-1'))
                 + sum((b,k), H2(b,k) * V('type-2'))
                 + sum((c,k), H3(c,k) * V('type-3'))
                 + sum((a,k), h(k) * W('type-1') * Y1(a,k))
                 + sum((b,k), h(k) * W('type-2') * Y2(b,k))
                 + sum((c,k), h(k) * W('type-3') * Y3(c,k));

constraint1(k) .. sum(a, X1(a,k)) + sum(b, X2(b,k)) + sum(c, X3(c,k)) =g= D(k);
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
constraint17(k) .. sum(a, Y1(a,k) * CMax('type-1')) + sum(b, Y2(b,k) * CMax('type-2')) + sum(c, Y3(c,k) * CMax('type-3')) =g= 1.15 * D(k);





model powerhouse /all/;
option optca = 0, optcr = 0;

file opt cplex option file / cplex.opt/;
put opt;
put 'objrng all'/

    'rhsrng all'/;
putclose opt;
powerhouse.optfile=1;
powerhouse.dictfile=4;

solve powerhouse using RMIP minimizing Z;
display X1.l, X2.l, X3.l,
        Y1.l, Y2.l, Y3.l,
        Z.l;