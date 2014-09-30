*************************************************************************
*************               SPECTRAN TOOLBOX         ********************
*************************************************************************


This Matlab toolbox performs spectral analysis of time series.


In particular, the toolbox provides functions for:
1. spectrum estimation
2. estimation of bivariate spectral measures:
   - coherency, 
   - coherence,
   - phase angle,
   - gain
3. estimation of multiple coherency and multiple coherence 
   and partial spectral measures:
   - partial coherency,
   - partial coherence,
   - partial phase angle,
   - partial gain
4. calculation of the mean (partial) phase angle
5. lead-lag analysis
6. writing the results to a text file
7. plotting univariate and multivariate spectral measures
   along with their confidence bands


Contents:

The directory where the toolbox is located has the subdirectories
'data', 'results' (with the subsubdirectory plots) and 'manual'.
The folder 'manual' contains the manual of the toolbox.
The toolbox consists of 27 function files.
The files 'exGER.m' and 'exUS1.m' and 'exUS2.m' are demo files.
The data for the demos are stored in the subdirectory data.




*************************************************************************

 Martyna Marczak                     Victor Gomez
 Department of Economics (520G)      Ministerio de Hacienda 
 University of Hohenheim             Direccion Gral. de Presupuestos
 Schloss, Museumsfluegel             Subdireccion Gral. de Analisis y P.E.
 70593 Stuttgart                     Alberto Alcocer 2, 1-P, D-34
 GERMANY                             8046 Madrid
                                     SPAIN                     
 Phone: + 49 711 459 23823           Phone : +34 915835439
 E-mail: marczak@uni-hohenheim.de    E-mail: vgomez@sepg.minhac.es    

 Recent release: 2012

 Copyright (c) 2012 
 This software may be used, copied, or redistributed as long as it is not sold.
 Usage of the functions and/or alterations of them should be referenced.
                              
**************************************************************************