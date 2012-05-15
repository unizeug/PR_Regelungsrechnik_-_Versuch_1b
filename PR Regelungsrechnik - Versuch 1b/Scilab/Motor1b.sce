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
exec("globalPlot.sci", -1);

PROCESS_PLOTS = 0;

// Konstaten
u=1

// Gleichstrommotor
RA=10.6;        //[ohm]Ankerwiderstand
LA=0.82E-3;     //[Henry] Ankerinduktivität
km=0.0527;      //[NmA^-1] Motorkonstante
JM=1.16E-6;     //[KGm^2] Ankerträgheitsmoment
cmu=0.4E-6;    //[Nms] Reibungskonstante

// Massescheibe
Ms= 0.068;      //[Kg] Masse
rs= 0.025;      //[m] Radius
Js= 0.5*Ms*rs^2 //[KGm^2] Massescheibeträgheitsmoment

// Leistungsverstärker
Tv=0.2E^-3;    //[s] Zeitkonstante
Verst = 3;          //[]Verstärkung

// Störungsgröße
mL=0;

// Definiert ein Polynom s mit Nullstelle = 0
s = poly(0, 's');

// Lineares system
A = [-(cmu)/(Js+JM)];
B = [(km)/(Js+JM)];
C = [1];
D = [0];



// Übertragungsfunktion

// Erstellen eines linear kontinuerliche Systems
Gss = syslin('c',A,B,C);

// Erstellen der Übertragungsfunktion
G2 =  clean(ss2tf(Gss))

// Null-/ Polstellen der Übertragungsfunktion
nul_G2=roots(G2.num)
pol_G2=roots(G2.den)

// komplimentäre Übertragungsfunktion der Stromregelung
//Ti = syslin('c', 202.22547, 202.22547 + s);

// Erstellen der Übertragungsfunktion G'(w)
Gstrich = Ti*G2;

// Null-/ Polstellen der Übertragungsfunktion G'(w)
nul_Gstrich=roots(Gstrich.num);
pol_Gstrich=roots(Gstrich.den);

// imaginärteile weglöschen
Gstrich = syslin('c',real(Gstrich.num),real(Gstrich.den));


// Die Nullstelle des Reglers wird auf die Polstelle der Stecke gelegt
s0w=pol_Gstrich(2);
//s0w = -10;    //veränderte Nullstelle

// verstärkung und Proportionalteil des Reglers
V2= 1/45//1/20;
Kw = V2;

// die Übertragungsfunktion des Pi-Reglers, der mit einem PT1-Glied verkettet ist
K2 = Kw*(((s-s0w)/s));
K2 = syslin('c',real(K2.num),real(K2.den));

// Bodeplot der Originalstrecken Übertragungsfunktion sowie der verkürzten 
// Übertragungs-Funktion
clf(1);scf(1);
bode_w_farbe(Gstrich, -6, 6, 'Bodeplot K2', %f, 1000, 3);
bode_w_farbe(K2, -6, 6, 'Bodeplot K2', %f, 1000, 5);
bode_w_farbe(Gstrich*K2, -6, 6, 'Bodeplot K2', %f, 1000, 2);
xtitle("Bodeplot von Gstrich");
legend(["Gstrich","K2","Gstrich*K2"],3);
xgrid();

offenerKreis_2 = Gstrich*K2;
offenerKreis = syslin('c',real(offenerKreis_2.num),real(offenerKreis_2.den))
// Plotten der Wurzelortskurve (WOK) von Gui*K
clf(2);scf(2);
evans(offenerKreis,100);
//legend("WOK des offenen Regelkreises",3);
xgrid();


//Plotten des Bodediagramms des offenen Regelkreises (Gui*K) in rad/s
clf(3);scf(3);
[w, db, phi] = bode_w(offenerKreis, 10^(-6), 10^6); 
legend("Offener Regelkreis",3);
xgrid(3);

//// Übertragungsfunktion des geschlossenen Regelkreises
GKgeschlossen = (Gstrich*K2/(1+Gstrich*K2))
GKgeschlossen = syslin('c',real(GKgeschlossen.num),real(GKgeschlossen.den))

//erstellen der Sprungantwort auf den Geschlossenen Kreis
t=[0:0.001:0.7];
h=csim('step',t,GKgeschlossen);

//Plotten der Sprungantwort auf den Geschlossenen Kreis

//globalplot (scf & clf ist schon drin)

p20 = 1.20.*ones(t);
p02 = 1.02.*ones(t);
p98 = 0.98.*ones(t);
t6=[0.6,0.60001];
p6=[0,1.4];

globalPlot(t,h,8)
plot2d(t,p02,3);
plot2d(t,p98,3);
plot2d(t,p20,3);
plot2d(t6,p6,5);

xtitle("Sprungantwort des Geschlossene Kreises","Zeit [s]","Ankerstrom [A]");
xgrid();




//bode_w_farbe(Ti, -3, 3, 'Bodeplot', %f, 1000, 5);
//
//Übertragungsfunktion der Störfunktion bei einer Störung auf den Eingang des 
//Leistungsverstärkers
Gmw = ((1/km)*G2)/(1+Gstrich*K2);

//erstellen der Spungantwort auf die Störung
t=[0:0.001:1];
h2=csim('step',t,Gmw);


//errechnen des Faktors D von Gdu um später beim plotten den Fehler ausgleichen
//zu können
MatrizenscheissvonGmw = tf2ss(Gmw);

//plotten der Störsprungantwort
globalPlot(t,h2+MatrizenscheissvonGmw(5),9);
xtitle("Störsprungantwort","Zeit [s]","Winkelgeschindigkeit [rad/s]");
xgrid();

//Sensitivitätsfunktion
Si = 1/(1+Gstrich*K2)
////Komplimentäre Sensitivitätsfunktion
Tw = (Gstrich*K2)/(1+Gstrich*K2)
