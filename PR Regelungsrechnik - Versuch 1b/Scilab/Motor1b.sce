// ############################################################################
// Scilab Script zum 1 Praktikum
//
// Reglerentwurf einer Motorregelung mit Wurzelortskurve,
// Frequenzkennlinienverfahren und Simulation
// ############################################################################

// Boris: cd "/Users/borishenckell/Documents/eclipse workspace/PR_Regelungsrtechnik_-_Versuch_1a/PR Regelungsrechnik - Versuch 1a"
// Dirk: cd "/media/daten/workspace/PR_Regelungsrechnik_-_Versuch_1a/PR Regelungsrechnik - Versuch 1a/Scilab/"



// Fehlermeldung bei neudefinition vermeiden
funcprot(0);

// Funktion "bode_w" einbinden
exec("bode_w_farbe.sci", -1);
exec("bode_w.sci", -1);



//Konstaten
u=1

//Gleichstrommotor
RA=10.6;        //[ohm]Ankerwiderstand
LA=0.82E-3;     //[Henry] Ankerinduktivität
km=0.0527;      //[NmA^-1] Motorkonstante
JM=1.16E-6;     //[KGm^2] Ankerträgheitsmoment
cmu=0.4E-6;    //[Nms] Reibungskonstante

//Massescheibe
Ms= 0.068;      //[Kg] Masse
rs= 0.025;      //[m] Radius
Js= 0.5*Ms*rs^2 //[KGm^2] Massescheibeträgheitsmoment

//Leistungsverstärker
Tv=0.2E^-3;    //[s] Zeitkonstante
V = 3;          //[]Verstärkung

//Störungsgröße
mL=0;

// Definiert ein Polynom s mit Nullstelle = 0
s = poly(0, 's');

// Lineares system

A = [-(cmu)/(Js+JM)];

B = [(km)/(Js+JM)];

C = [1];

D = [0];

// Übertragungsfunktion

//Erstellen eines linear kontinuerliche Systems
Gss = syslin('c',A,B,C);

//Erstellen der Übertragungsfunktion
G2 =  clean(ss2tf(Gss))

// Nullstellen der Übertragungsfunktion
nul_G2=roots(G2.num)
// Polstellen der Übertragungsfunktion
pol_G2=roots(G2.den)

//komplimentäre Übertragungsfunktion von der Stromregelung
Ti = syslin('c', 202.22547, 202.22547 + s);
//Erstellen der Übertragungsfunktion G'(w)
Gstrich = Ti*G2;
// Nullstellen der Übertragungsfunktion
nul_Gstrich=roots(Gstrich.num)
// Polstellen der Übertragungsfunktion
pol_Gstrich=roots(Gstrich.den)
//imaginärteile weglöschen
Gstrich = syslin('c',real(Gstrich.num),real(Gstrich.den));


// Erstellen der normierten Faktorisierung der Übertragungsfunktion Gmotor


//Quorient der beiden Koeffizienten des Zählers und des Nenners ohne s
//k=coeff(Gmotor.num,0)/coeff(Gmotor.den,0);

// Normiert faktorisierte Übertragungsfunktion Gmotor
//Gmotor_norm=k*(-nul_Gmotor(1)^(-1)*s+1)/(((-pol_Gmotor(1))^(-1)*s+1)*((-pol_Gmotor(2))^(-1)*s+1))

//kneu=k/pol_Gmotor(1)+0.0004314;

// normiert faktorisierte Ü-Fkt. ohne die schnellste Polstelle
//Gp=kneu*(-nul_Gmotor(1)^(-1)*s+1)/(((-pol_Gmotor(2))^(-1)*s+1))
//
//// Kontrolle, ob die beiden Übertragungsfunktionen den selben Wert bei f=0 haben
//check1=horner(Gmotor,0)-horner(Gmotor_norm,0);
//check=horner(Gmotor,0)-horner(Gp,0);
//
//
//Gmotor_norm1=syslin('c',real(Gmotor_norm.num),real(Gmotor_norm.den))
//Gui = syslin('c',real(Gp.num), real(Gp.den))
//nul_Gui = roots(Gui.num)
//pol_Gui = roots(Gui.den)
//
//
//Bodeplot der Originalstrecken Übertragungsfunktion sowie der verkürzten 
//Ü-Funktion
clf(1);scf(1);
bode(Gstrich,0.001,300000,'Gstrich');
xtitle("Bodeplot von Gstrich");
xgrid();

//Die Nullstelle des Reglers wird auf die Polstelle der Stecke gelegt
s0w=pol_Gstrich(2);
// Die verstärkung des Reglers
V=1/20;
//der Proportionalteil
Kw = V;

//die Übertragungsfunktion des Pi-Reglers, der mit einem PT1-Glied verkettet ist
K2 = Kw*(((s-s0w)/s));
//Die Übertragungsfunktion des PI-Reglers, der mit einem PT1-Glied verkette ist
//- normiert
//K2= (-Ki*s0i)*(1/s)*((-s/s0i)+1)*(1/((-s/s1)+1));

offenerKreis = Gstrich*K2;
offenerKreis = syslin('c',real(offenerKreis.num),real(offenerKreis.den))
//// Plotten der Wurzelortskurve (WOK) von Gui*K
//clf(2);scf(2);
//evans(offenerKreis);
////legend("WOK des offenen Regelkreises",3);
xgrid();


//Plotten des Bodediagramms des offenen Regelkreises (Gui*K) in rad/s
clf(3);scf(3);
[w, db, phi] = bode_w(offenerKreis, 10^(-3), 10^3); 
legend("Offener Regelkreis",3);
xgrid(3);

//// Übertragungsfunktion des geschlossenen Regelkreises
GKgeschlossen = (Gstrich*K2/(1+Gstrich*K2))
GKgeschlossen = syslin('c',real(GKgeschlossen.num),real(GKgeschlossen.den))

//erstellen der Sprungantwort auf den Geschlossenen Kreis
t=[0:0.001:0.5];
h=csim('step',t,GKgeschlossen);

//Plotten der Sprungantwort auf den Geschlossenen Kreis
clf(4);scf(4);
plot2d(t,h);
xtitle("Sprungantwort des Geschlossene Kreises","Zeit [s]","Ankerstrom [A]");
xgrid();




//bode_w_farbe(Ti, -3, 3, 'Bodeplot', %f, 1000, 5);
//
//Übertragungsfunktion der Störfunktion bei einer Störung auf den Eingang des 
//Leistungsverstärkers
Gmw = 1/(1+Gstrich*K2);

//erstellen der Spungantwort auf die Störung
t=[0:0.001:1];
h2=csim('step',t,Gmw);


//errechnen des Faktors D von Gdu um später beim plotten den Fehler ausgleichen
//zu können
MatrizenscheissvonGmw = tf2ss(Gmw);

//plotten der Störsprungantwort
clf(5);scf(5);
plot2d(t,h2+MatrizenscheissvonGmw(5));
xtitle("Störsprungantwort","Zeit [s]","Ankerstrom [A]");
xgrid();

//Sensitivitätsfunktion
Si = 1/(1+Gstrich*K2)
////Komplimentäre Sensitivitätsfunktion
Tw = (Gstrich*K2)/(1+Gstrich*K2)
//
////plotten der Sensitivitätsfunktion sowie der komplimantären Sensitivitätsfunktion
//clf(6);scf(6);
//bode_w_farbe(Si, -3, 3, 'Bodeplot', 'false', 1000, 2);
////bode_w_farbe(Ti, -3, 3, 'Bodeplot', %f, 1000, 5);
//legend("Sensitivitätsfunktion","Komplimentäre Sensitivitätsfunktion",3);
//xgrid();
//
////xtitle("Leistungen vor dem Dimmer Werte aus LabView","Phi [°]","Leistung [W]");
////legend("Sensitivitätsfunktion","Komplimentäre Sensitivitätsfunktion",4);
