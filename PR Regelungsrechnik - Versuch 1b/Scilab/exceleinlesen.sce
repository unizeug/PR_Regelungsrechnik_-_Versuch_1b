// ############################################################################

// Boris: cd "/Users/borishenckell/Documents/eclipse workspace/PR_Regelungsrtechnik_-_Versuch_1a/PR Regelungsrechnik - Versuch 1a"
// Dirk: cd "/media/daten/workspace/PR_Regelungsrechnik_-_Versuch_1b/PR Regelungsrechnik - Versuch 1b/Scilab/"

// Kann nach dem ersten mal ausführen auskommentiert werden
//exec("Motor.sce", -1);





                    // * * * * * * * * * * * * * * * * * * * * //
                    //          -- Sprungantwort  --           //
                    // * * * * * * * * * * * * * * * * * * * * //
scf(1);
clf(1);


// ## Messung ##

// Ausgeschnittener Datensatz, nur die Werte ab Start des Sprungs
daten = fscanfMat('../Messwerte/data_gut_sprung');
s1=daten;

//t=s1(:,1); Zeit
//i=s1(:,2); Ankerstrom
//w=s1(:,3); Winkelgeschwindigkeit
//u=s1(:,4); Ausgangsspannung des Reglers (Führungsgröße)
//ri=s1(:,5) i-soll (Asugang des ersten Reglers)
//rw=s1(:,6) ; Soll-Winkelgeschwindigkeit (0 oder 150)


// gemessener Stellstrom
ri=s1(:,5);

// gemessene Winkelgeschwindigkeit
w = s1(:,3);


//  W soll
w_soll = s1(:,6); 


// Interessanten bereich ausschneiden
[val max_ind_w_soll] = max(w_soll);
spr_anfang = max_ind_w_soll;
spr_ende = 4500;


I1 = i(spr_anfang:spr_ende);
W1 = w(spr_anfang:spr_ende);



// Zeit seit Messbeginn
t1=s1(:,1);

T_1 = t1(spr_anfang:spr_ende)


// Anfang des Zeitvektors auf Null setzen (Start des Anstieges nach null verschieben)
// Zeit seit Anfang des Ausschnittes
T1 = T_1 - T_1(1);


plot2d(T1,W1,3)



// ## Simulation ##

// um einen Sprung (Step) auf 0.3 zu bekommen wird noch mit 0.3 multipliziert,
// da csim mit dem argument 'step' auf 1 Springt
h=csim('step',T1,GKgeschlossen)*150;

// in die gleiche figure plotten wie die aufgenommene Sprungantwort (d.h.: kein clf)
scf(1);

// Die simulierte Sprungantwort über den gleichen Zeitvektor plotten wie die Gemessene
T1 = T1
plot2d(T1,h,5);
xgrid();
xtitle("Sprungantwort","Zeit [s]","Winkelgeschwindigkeit [rad/s]")
legend("gemessen","simuliert",4);



scf(2);
clf(2);

Ri = ri(spr_anfang-20:spr_ende-435);
T_1_ri = t1(spr_anfang-20:spr_ende-435);
T1_ri = T_1_ri - T_1_ri(1);

// nu endlich den Stellstrom über die Zeit seit Beginn des Sprungs in [s] plotten
plot2d(T1_ri,Ri,2)
xgrid();
xtitle("Sprungantwort","Zeit [s]","Strom [A]")
legend("gemessen","simuliert",1);



                    // * * * * * * * * * * * * * * * * * * * * //
                    //         -- Störsprungantwort --         //
                    // * * * * * * * * * * * * * * * * * * * * //

scf(3);
clf(3);


// ## Messung ##

daten2 = fscanfMat('../Messwerte/data_gut_stoer');
s2=daten2;

T = t ;
t2=s2(:,1);
w2=s2(:,3);
w2_soll = s2(:,6);

// Interessanten bereich ausschneiden
[val min_ind_w2] = min(w2);
stoe_anfang = min_ind_w2-24;
stoe_ende = stoe_anfang+ 600;




// Richtig drehen
W_2 = -w2 +150;


// interessantes Stück ausschneiden
W2 = W_2(stoe_anfang:stoe_ende);



// Anfang auf null setzen
T_2 = t2 - t2(stoe_anfang);

// in Sekunden wandeln
T2 = T_2;

// interessantes Stück ausschneiden
T2 = T2(stoe_anfang:stoe_ende);

// Messung Plotten
plot2d(T2,W2,2)




// ## Simulation ##

h1=csim('step',T2,Gmw);
h1 = h1*(max(W2)/max(h1));

plot2d(T2,h1+MatrizenscheissvonGmw(5),5);
xgrid();
xtitle("Störsprungantwort","Zeit [s]","Winkelgeschwindigkeit [rad/s]");
legend("gemessen","simuliert",1);



