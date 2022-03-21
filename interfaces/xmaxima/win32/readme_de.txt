Dies ist die Windows-LIESMICH-Datei.


In dieser Distribution enthaltende Bin�rdateien
-----------------------------------------------

Die Windows-Version des Maxima-Pakets enth�lt Bin�rdateien 
aus anderen Open-Source-Projekten, die ebenfalls auf Sourceforge 
gewartet werden.


gcc: 

gcc.exe, cc1.exe und die Dateien in den lib/gcc-lib und include/ 
Unterverzeichnissen stammen aus der mingw-Version des gcc.  Diese
ist erh�ltlich unter http://prdownloads.sf.net/mingw/
     

binutils:

as.exe stammt vom mingw (http://www.mingw.org/)-Port der binutils
erh�ltlich unter http://prdownloads.sf.net/mingw/


gnuplot:

Die Dateien wgnuplot.exe, wgnuplot.hlp und wgnuplot.mnu stammen 
aus der Windows-Distribution von gnuplot unter 
http://gnuplot.sourceforge.net


wxMaxima:

Die Dateien im wxMaxima-Unterverzeichnis stammen aus der Windows-
Distribution von wxMaxima erh�ltlich unter 
https://wxmaxima-developers.github.io/wxmaxima/


Maxima-GUI und Firewall
-----------------------

Manchmal kann die Maxima-GUI (xmaxima oder wxMaxima) Maxima nicht 
starten, gibt Zeit�berschreitungsmeldungen aus oder erh�lt auf 
Maxima-Kommandos keine Antworten. Sehr wahrscheinlich ist dieses 
Problem dann durch die Firewall und/oder eine Antivirus-Software 
verursacht. Die Maxima-GUI kommuniziert mit der Berechnungseinheit 
�ber ein Socket. Antivirus- und/oder Firewall-Progamme erkennen 
das und versuchen eventuell, dies zu blocken 
(da einige sch�dliche Programme ebenfalls Sockets �ffnen). 

Zur L�sung des Problems:

1.  Versuchen Sie, die Systemsteuerung der Antivirus- und/oder 
    Firewall-Software zu finden.

2.  Finden Sie die Maxima-GUI auf der Liste der geblockten Programme 
    und deaktivieren Sie die Blockierung der GUI. Das GUI-Programm 
    wird eventuell als "Tcl/Tk" aufgef�hrt 
    (der Name des GUI-Werkzeugsatzes f�r xmaxima).


Datenausf�hrungsverhinderung (DEP)
----------------------------------

In einigen F�llen funktioniert weder Maxima GUI noch 
Kommandozeilen-Maxima (maxima.bat startet und beendet sich sofort wieder).
Sehr wahrscheinlich h�ngt das Problem mit Windwos DEP zusammen.
Einige Lisp-Implementierungen f�hren Code in Datenbereichen des 
Arbeitsspeichers aus. Windows DEP bemerkt und blockiert dies (weil
einige sch�dliche Programme ebenfalls Code in Datenbereichen ausf�hren).

L�sung:

   F�gen Sie den vollen Programmpfad von Maxima (z.B. 
   C:\Programme\Maxima-5.12.0\lib\maxima\5.12.0\binary-gcl\maxima.exe)
   in die Liste von DEP-Ausnahmen ein  
   (Systemsteuerung -> System ->  Erweitert -> Systemleistung "Einstellung" 
    -> Datenausf�hrungsverhinderung)

