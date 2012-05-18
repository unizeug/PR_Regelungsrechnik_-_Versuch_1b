

// Boris: cd "/Users/borishenckell/Documents/eclipse workspace/PR_Regelungsrtechnik_-_Versuch_1b/PR Regelungsrechnik - Versuch 1b"
// Dirk: cd "/media/daten/workspace/PR_Regelungsrechnik_-_Versuch_1b/PR Regelungsrechnik - Versuch 1b/Scilab/"

// Funktionen einbinden
//exec("bode_w_farbe.sci", -1);
//exec("bode_w.sci", -1);
exec("globalPlot.sci", -1);


// Legend error (#10000) unterdrücken
errcatch(10000,'continue','nomessage');


PROCESS_PLOTS = 1;


//t=s1(:,1); Zeit
//i=s1(:,2); Ankerstrom
//w=s1(:,3); Winkelgeschwindigkeit
//u=s1(:,4); Ausgangsspannung des Reglers (Führungsgröße)
// isoll
//w_soll(:,6) ; Soll-Winkelgeschwindigkeit



                    // * * * * * * * * * * * * * * * * * * * * //
                    //           -- Sprungantwort --           //
                    // * * * * * * * * * * * * * * * * * * * * //

s5 = fscanfMat('../Messwerte/data_gut_sprung');

t5=s5(:,1);
w5=s5(:,3);
i5=s5(:,5);




// Interessanten bereich ausschneiden
[val min_ind] = max(i5);
stoe_anfang = min_ind-4;
stoe_ende = stoe_anfang+ 499;


// Anfang auf null setzen
T_5 = t5 - t5(stoe_anfang);
// interessantes Stück ausschneiden
T5 = T_5(stoe_anfang:stoe_ende);


                        //    --  Geschwindigkeit  --   //
                        
// ## Messung ##
W5 = w5(stoe_anfang:stoe_ende);


// ## Simulation ##
h=csim('step',T5,GKgeschlossen)*150;



scf(10);
clf(10);
globalPlot(T5,W5,3)
globalPlot(T5,h,2)
xtitle("Sprungantwort","Zeit [s]","Winkelgeschwindigkeit [rad/s]");
legend("gemessen","simuliert",4);
xgrid();

// Grenzen
p20 = 1.20.*ones(T5)*150;
p02 = 1.02.*ones(T5)*150;
p98 = 0.98.*ones(T5)*150;
//t6=[0.6,0.60001];
//p6=[0,180];
plot2d(T5,p02,5);
plot2d(T5,p98,5);
plot2d(T5,p20,5);
//plot2d(t6,p6,5);




                        //    --  Strom  --   //

// ## Messung ##
I5 = i5(stoe_anfang:stoe_ende-300);
T5_i = T_5(stoe_anfang:stoe_ende-300);

scf(11);
clf(11);
globalPlot(T5_i,I5,1)
xtitle("Sprungantwort des Stroms","Zeit [s]","Ankerstrom [A]");
xgrid();




                    // * * * * * * * * * * * * * * * * * * * * //
                    //         -- Störsprungantwort --         //
                    // * * * * * * * * * * * * * * * * * * * * //
PROCESS_PLOTS = 1;



s6 = fscanfMat('../Messwerte/data_gut_stoer');

t6=s6(:,1);
w6=s6(:,3);
i6=s6(:,5);


// Interessanten bereich ausschneiden
[val min_ind] = min(w6);
stoe_anfang = min_ind-23;
stoe_ende = stoe_anfang+ 499;


// Anfang auf null setzen
T_6 = t6 - t6(stoe_anfang);
// interessantes Stück ausschneiden
T6 = T_6(stoe_anfang:stoe_ende);


                        //    --  Geschwindigkeit  --   //
                        
// ## Messung ##
W6 = w6(stoe_anfang:stoe_ende);



// ## Simulation ##
h1=csim('step',T6,Gmw);
h1 = (h1/max(h1))*(min(w6)-150)+150;


scf(12);
clf(12);
globalPlot(T6,W6,3)
globalPlot(T6,h1,2);            
xgrid();
xtitle("Störsprungantwort","Zeit [s]","Winkelgeschwindigkeit [rad/s]");
legend("gemessen","simuliert",4);




                        //    --  Strom  --   //

// ## Messung ##
I6 = i6(stoe_anfang:stoe_ende-300);
T6_i = T_6(stoe_anfang:stoe_ende-300);

scf(13);
clf(13);
globalPlot(T6_i,I6,1)
xtitle("Störsprungantwort des Stroms","Zeit [s]","Ankerstrom [A]");
xgrid();























