Folder for manually downloaded software installation packages used by
Dockerfile. 

The Dockerfile script also downloads and installs third-party software that can be used with Biskit (TM-Align, DSSP, etc). Some helper applications require login, registration or license keys though and cannot therefore be fetched from the commandline. Download them manually and place the downloaded file in this folder. Files currently expected are:

| File name                   | Description           | Source|
------------------------------|-----------------------|-------|
Delphicpp_Linux.zip           | Delphi, C++ v7.1      | http://bhapp.c2b2.columbia.edu/software/cgi-bin/software.pl?input=DelPhi |
xplor-nih-2.48-db.tar.gz      | NIH-Xplor Database    | https://nmr.cit.nih.gov/xplor-nih/ |
xplor-nih-2.48-Linux_x86_64.tar.gz | NIH-Xplor        | https://nmr.cit.nih.gov/xplor-nih/ |


