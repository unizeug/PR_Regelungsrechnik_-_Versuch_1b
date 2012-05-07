// ############################################################################
// Scilab Script zum 1 Praktikum
//
// Reglerentwurf einer Motorregelung mit Wurzelortskurve,
// Frequenzkennlinienverfahren und Simulation
// ############################################################################

// Boris: cd "/Users/borishenckell/Documents/eclipse workspace/PR_Regelungsrtechnik_-_Versuch_1a/PR Regelungsrechnik - Versuch 1a"
// Dirk: cd "/media/daten/workspace/PR_Regelungsrechnik_-_Versuch_1a/PR Regelungsrechnik - Versuch 1a/Scilab/"


function plot_to_come(title)
    
    
endfunction


// Fehlermeldung bei neudefinition vermeiden
funcprot(0);

// Funktion "bode_w" einbinden
exec("bode_w_farbe.sci", -1);
exec("bode_w.sci", -1);



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
V = 3;          //[]Verstärkung

//S törungsgröße
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
Ti = syslin('c', 202.22547, 202.22547 + s);

// Erstellen der Übertragungsfunktion G'(w)
Gstrich = Ti*G2;

// Null-/ Polstellen der Übertragungsfunktion G'(w)
nul_Gstrich=roots(Gstrich.num);
pol_Gstrich=roots(Gstrich.den);

// imaginärteile weglöschen
Gstrich = syslin('c',real(Gstrich.num),real(Gstrich.den));



// Bodeplot der Originalstrecken Übertragungsfunktion sowie der verkürzten 
// Übertragungs-Funktion
clf(1);scf(1);
bode(Gstrich,0.001,300000,'Gstrich'); 
xgrid();

// Die Nullstelle des Reglers wird auf die Polstelle der Stecke gelegt
s0w=pol_Gstrich(2);

// verstärkung und Proportionalteil des Reglers
V=1/20;
Kw = V;

// die Übertragungsfunktion des Pi-Reglers, der mit einem PT1-Glied verkettet ist
K = Kw*(((s-s0w)/s));


offenerKreis = Gstrich*K;
offenerKreis = syslin('c',real(offenerKreis.num),real(offenerKreis.den))

// Plotten der Wurzelortskurve (WOK) von Gui*K
clf(2);scf(2);
evans(offenerKreis);
//legend("WOK des offenen Regelkreises",3);
xgrid();


//Plotten des Bodediagramms des offenen Regelkreises (Gui*K) in rad/s
clf(3);scf(3);
bode_w(offenerKreis, 10^(-3), 10^3); 
legend("Offener Regelkreis",3);
xgrid(3);

//// Übertragungsfunktion des geschlossenen Regelkreises
GKgeschlossen = (Gstrich*K/(1+Gstrich*K))
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
////Übertragungsfunktion der Störfunktion bei einer Störung auf den Eingang des 
////Leistungsverstärkers
//Gdu = Gui/(1+Gui*K);
//
////erstellen der Spungantwort auf die Störung
//t=[0:0.001:1];
//h1=csim('step',t,Gdu);
//
//
////errechnen des Faktors D von Gdu um später beim plotten den Fehler ausgleichen
////zu können
//MatrizenscheissvonGdu = tf2ss(Gdu);
//
////plotten der Störsprungantwort
//clf(5);scf(5);
//plot2d(t,h1+MatrizenscheissvonGdu(5));
//xtitle("Störsprungantwort","Zeit [s]","Ankerstrom [A]");
//xgrid();
//
////Sensitivitätsfunktion
//Si = 1/(1+Gui*K)
////Komplimentäre Sensitivitätsfunktion
//Ti = (Gui*K)/(1+Gui*K)
//
////plotten der Sensitivitätsfunktion sowie der komplimantären Sensitivitätsfunktion
//clf(6);scf(6);
//bode_w_farbe(Si, -3, 3, 'Bodeplot', 'false', 1000, 2);
//bode_w_farbe(Ti, -3, 3, 'Bodeplot', %f, 1000, 5);
//legend("Sensitivitätsfunktion","Komplimentäre Sensitivitätsfunktion",3);
//xgrid();
//
////xtitle("Leistungen vor dem Dimmer Werte aus LabView","Phi [°]","Leistung [W]");
////legend("Sensitivitätsfunktion","Komplimentäre Sensitivitätsfunktion",4);
