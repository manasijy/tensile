This repo contains scripts to analyse engineering strain- engineering stress data obtained from a tensile test of a metallic specimen. 
The script TensileDataAnalysis takes these inputs and calculates 0.2% proof(yield) stress, ultimate tensile strength both engineering as well as in true stress terms. 
This script also calculates and plots true stress-true strain, true stress-true plastic strain, strain hardening rate. All the data can be stored in .nat or excel format.
There is a separate script to analyse Kocks-Mecking data created from this file in script KM_parameters. In this script the dislocation storage and dynamic recovery coefficients are determined.
Another script stressDrop is to analyse the stress-strain data showing serrations due to dynamic strain aging i.e., PLC effect.
Padcat is a boroowed script from mathworks to enable storage of different lenght arrays in excel
Write2excel is used to create excel files from matdata.
