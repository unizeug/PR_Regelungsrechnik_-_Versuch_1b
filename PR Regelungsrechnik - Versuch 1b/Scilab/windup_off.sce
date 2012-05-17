                    // * * * * * * * * * * * * * * * * * * * * //
                    //         -- Störsprungantwort --         //
                    // * * * * * * * * * * * * * * * * * * * * //

// Boris: cd "/Users/borishenckell/Documents/eclipse workspace/PR_Regelungsrtechnik_-_Versuch_1b/PR Regelungsrechnik - Versuch 1b"
// Dirk: cd "/media/daten/workspace/PR_Regelungsrechnik_-_Versuch_1b/PR Regelungsrechnik - Versuch 1b/Scilab/"

// Funktionen einbinden
//exec("bode_w_farbe.sci", -1);
//exec("bode_w.sci", -1);
exec("globalPlot.sci", -1);


// Legend error unterdrücken
errcatch(10000,'continue','nomessage');


PROCESS_PLOTS = 1;


//t=s1(:,1); Zeit
//i=s1(:,2); Ankerstrom
//w=s1(:,3); Winkelgeschwindigkeit
//u=s1(:,4); Ausgangsspannung des Reglers (Führungsgröße)
// isoll
//w_soll(:,6) ; Soll-Winkelgeschwindigkeit





s3 = fscanfMat('../Messwerte/data_2_wind_off');

t3=s3(:,1);
i_soll3=s3(:,5);
i3=s3(:,2);
w3=s3(:,3);
u3=s3(:,4);


s4 = fscanfMat('../Messwerte/data_gut_wind_on');

t4=s4(:,1);
i_soll4=s4(:,5);
i4=s4(:,2);
w4=s4(:,3);
u4=s4(:,4);





// Interessanten bereich ausschneiden
//[val min_ind] = min(w3);
//stoe_anfang_3 = 200;
//stoe_ende_3 = stoe_anfang_3+ length(t3) -202;

stoe_anfang_3 = 1000;
stoe_ende_3 = 4162;


// Interessanten bereich ausschneiden
//[val min_ind4] = min(w4);
//stoe_anfang_4 = min_ind4-120;
//stoe_ende_4 = stoe_anfang_4+ 1000;


stoe_anfang_4 = 838;
stoe_ende_4 = 4000;




                        //    --  Zeit  --   //

// Anfang auf null setzen
T_3 = t3 - t3(stoe_anfang_3);
// interessantes Stück ausschneiden
T3 = T_3(stoe_anfang_3:stoe_ende_3);





                        //    --  Sollstrom  --   //
scf(5);
clf(5);

I_soll3 = i_soll3(stoe_anfang_3:stoe_ende_3);
I_soll4 = i_soll4(stoe_anfang_4:stoe_ende_4);

globalPlot(T3,I_soll3,2)
globalPlot(T3,I_soll4,3)
xtitle("Störsprungantwort des Sollstroms","Zeit [s]","Strom [A]");
legend("ohne anti-Windup","mit anti-Windup",1);





                        //    --  Strom  --   //
scf(6);
clf(6);

I3 = i3(stoe_anfang_3:stoe_ende_3);
I4 = i4(stoe_anfang_4:stoe_ende_4);

globalPlot(T3,I3,2)
globalPlot(T3,I4,3)
xtitle("Störsprungantwort des Stroms","Zeit [s]","Strom [A]");
legend("ohne anti-Windup","mit anti-Windup",1);





                        //    --  Geschwindigkeit  --   //
scf(8);
clf(8);

// Richtig drehen
W_3 = w3;
W_4 = w4;


// interessantes Stück ausschneiden
W3 = W_3(stoe_anfang_3:stoe_ende_3);
W4 = W_4(stoe_anfang_4:stoe_ende_4);

globalPlot(T3,W3,2,1)
globalPlot(T3,W4,3,1)
xtitle("Störsprungantwort der Geschwindigkeit","Zeit [s]","Winkelgeschwindigkeit [rad/s]");
legend("ohne anti-Windup","mit anti-Windup",4);




                        //    --  Spannung  --   //
scf(9);
clf(9);

U3 = u3(stoe_anfang_3:stoe_ende_3);
U4 = u4(stoe_anfang_4:stoe_ende_4);

globalPlot(T3,U3,2)
globalPlot(T3,U4,3)
xtitle("Störsprungantwort der Spannung","Zeit [s]","Spannung [V]");
legend("ohne anti-Windup","mit anti-Windup",4);





// ## Simulation ##
scf(10);
clf(10);


h1=csim('step',T3,Gmw);
h1 = (h1/max(h1))*(min(w3)+70)+150;

globalPlot(T3,h1,10);
xgrid();
xtitle("Störsprungantwort","Zeit [s]","Winkelgeschwindigkeit [rad/s]");
legend("gemessen","simuliert",1);







