                    // * * * * * * * * * * * * * * * * * * * * //
                    //         -- Störsprungantwort --         //
                    // * * * * * * * * * * * * * * * * * * * * //

scf(3);
clf(3);


// ## Messung ##

daten2 = fscanfMat('../Messwerte/data_gut_wind_on');
s2=daten2;


//t=s1(:,1); Zeit
//i=s1(:,2); Ankerstrom
//w=s1(:,3); Winkelgeschwindigkeit
//u=s1(:,4); Ausgangsspannung des Reglers (Führungsgröße)
// isoll
//w_soll(:,6) ; Soll-Winkelgeschwindigkeit

t1=s1(:,1);
i1=s1(:,2);
u1=s1(:,4);

T = t ;

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







