                    // * * * * * * * * * * * * * * * * * * * * //
                    //         -- Störsprungantwort --         //
                    // * * * * * * * * * * * * * * * * * * * * //

// Boris: cd "/Users/borishenckell/Documents/eclipse workspace/PR_Regelungsrtechnik_-_Versuch_1b/PR Regelungsrechnik - Versuch 1b"
// Dirk: cd "/media/daten/workspace/PR_Regelungsrechnik_-_Versuch_1b/PR Regelungsrechnik - Versuch 1b/Scilab/"



daten4 = fscanfMat('../Messwerte/data_gut_wind_on');
s4=daten4;


//t=s1(:,1); Zeit
//i=s1(:,2); Ankerstrom
//w=s1(:,3); Winkelgeschwindigkeit
//u=s1(:,4); Ausgangsspannung des Reglers (Führungsgröße)
// isoll
//w_soll(:,6) ; Soll-Winkelgeschwindigkeit

t4=s4(:,1);
i_soll4=s4(:,5);
i4=s4(:,2);
w_soll4=s4(:,6);
w4=s4(:,3);
u4=s4(:,4);




// Interessanten bereich ausschneiden
[val min_ind] = min(w4);
stoe_anfang = min_ind-120;
stoe_ende = stoe_anfang+ 1000;



// Anfang auf null setzen
T_4 = t4 - t4(stoe_anfang);

// in Sekunden wandeln
T4 = T_4;

// interessantes Stück ausschneiden
T4 = T4(stoe_anfang:stoe_ende);


scf(5);
clf(5);

I_soll4 = i_soll4(stoe_anfang:stoe_ende);

plot(T4,I_soll4)




scf(6);
clf(6);

I4 = i4(stoe_anfang:stoe_ende);

plot(T4,I4)



scf(7);
clf(7);

W_soll4 = w_soll4(stoe_anfang:stoe_ende);

plot(T4,W_soll4)


scf(8);
clf(8);

// Richtig drehen
W_4 = w4;

// interessantes Stück ausschneiden
W4 = W_4(stoe_anfang:stoe_ende);


plot(T4,W4)




scf(9);
//clf(11);

U4 = u4(stoe_anfang:stoe_ende);

plot(T4,U4)




//// ## Simulation ##
//scf(10);
//clf(10);
//
//
//h1=csim('step',T2,Gmw);
//h1 = h1*(max(W2)/max(h1));
//
//plot2d(T2,h1+MatrizenscheissvonGmw(5),5);
//xgrid();
//xtitle("Störsprungantwort","Zeit [s]","Winkelgeschwindigkeit [rad/s]");
//legend("gemessen","simuliert",1);







