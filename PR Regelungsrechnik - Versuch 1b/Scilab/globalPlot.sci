// Fehlermeldung bei neudefinition vermeiden
funcprot(0);

function globalPlot(x,y,fig,style)

    // actual inputs arguments (rhs) and output arguments (lhs)
    [lhs,rhs]=argn(0) ;
    
    
    // does the variable PROCESS_PLOTS _NOT_ exist?
    if exists("PROCESS_PLOTS") ~= 1 then
        error("   ### ERROR ### SuperPlot: Bitte die Variable PROCESS_PLOTS definieren! (= 1 ums an zu schlaten)");
    end
    
    // is there enough info to Plot
    if rhs < 2 then
         error("   ### ERROR ### SuperPlot: Bitte mindestens zwei Variablen übergeben!");
    end
    
    // is the figure argument given
    if rhs < 3 then
        fig = 0;
    end
    
    
// alles OK soweit, anfangen mit dem Plotten

    if PROCESS_PLOTS == 1 & rhs >= 4 then
        clf(fig);scf(fig);
        plot2d(x,y,style);
    elseif PROCESS_PLOTS == 1
        clf(fig);scf(fig);
        plot2d(x,y);
    else
        warning("Achtung: superPlots ist ausgeschaltet!");
    end

endfunction
