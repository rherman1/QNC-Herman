# QNC-Herman
 ## Code organization
 * 'IPI data matlab.csv' contains formatted data for interpuff interval analysis
 * 'InterpuffIntervals.m' visualizes and analyzes this data with:
 
        * 'distributionPlot.m' is used to create violin plots
                 * uses 'colorCode2rgb.m', 'myErrorbar.m', 'myHistogram.m' and 'weightedStats.m'
               
        * 'plotSpread.m' is used to create individual points on violin plots
                * uses 'distinguishable_colors.m', 'isEven.m', and 'repeatEntries.m'
