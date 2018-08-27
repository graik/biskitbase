FROM python:3.6

## dependencies for Biskit and Biggles
RUN apt-get -qq update \
    && apt-get install -y --no-install-recommends \
         gfortran \
         gnuplot \
         libblas-dev \
         liblapack-dev \
         libplot-dev \
         plotutils \
    && rm -rf /var/lib/apt/lists/*

## don't use -r requirements.txt here because we have not ADDed file yet
RUN pip install --no-cache numpy scipy biopython \
## biggles compilation cannot see numpy when invoked in same pip command
    && pip --no-cache install biggles

## install TM-Align
RUN cd /tmp && wget http://zhanglab.ccmb.med.umich.edu/TM-align/TMalign.gz \
    && gzip -d TMalign.gz \
    && chmod +x TMalign \
    && mv TMalign /usr/local/bin/

## install DSSP, Pymol, surfrace dependencies
RUN apt-get -qq update \
    && apt-get install -y --no-install-recommends \
         dssp \
         pymol \
         unzip \ 
         libstdc++5 \ 
    && rm -rf /var/lib/apt/lists/*

## install SurfaceRacer
RUN cd /tmp \
    && wget http://pharmacy.uky.edu/sites/pharmacy.uky.edu/files/files/tsodikov/surface_racer_5.0_linux64.zip \
    && unzip surface_racer_5.0_linux64.zip \
    && rm surface_racer_5.0_linux64.zip \
    && mv surface_racer_5.0_64bit/surfrace5_0_linux_64bit /usr/local/bin/surfrace \
    && chmod +x /usr/local/bin/surfrace \
    && rm -rf surface_racer*

## install AmberTools 17
RUN cd /tmp \
    && wget -nv http://ambermd.org/downloads/install_ambertools.sh \
    && bash install_ambertools.sh --prefix /opt --non-conda \
    && rm -r /opt/ambertools*bz2 

ENV AMBERHOME /opt/amber17
ENV PATH $PATH:$AMBERHOME/bin

## install HEX 8.1.1 (docking)
RUN cd /tmp \
    && wget -nv http://hex.loria.fr/dist800/hex-8.1.1-x64-mint17.2.run \
    && chmod +x hex-8*.run \
       ## extract archive file without running setup script:
    && mkdir hexsetup \
    && ./hex-8*.run --target /tmp/hexsetup --noexec \
    && rm hex-8*.run \
    && mkdir /opt/hex \
    && cd /opt/hex \
    && tar xf /tmp/hexsetup/*tgz \
    && mkdir hex_cache \
       ## cleanup
    && rm -r /tmp/hexsetup

ENV HEX_ROOT /opt/hex
ENV HEX_CACHE /opt/hex/hex_cache
ENV PATH $PATH:$HEX_ROOT/bin


## Everything following ADD is not cached by Docker
## -> the following RUN commands have to be re-executed with every build
ADD . /app
WORKDIR /app

## Now install programs that require registration or cannot be automatically
## downloaded for other reasons
## download manually and put copies into the `downloads` folder

## Try installing Delphi from downloads copy
# RUN if test -e downloads/Del?hi*95*.tar.gz; then \
#       mv downloads/Del?hi*.tar.gz /tmp; \
#       cd /tmp ; \
#       tar xfz Del?hi*.tar.gz ; \
#       rm Del?hi*.tar.gz \
#       mv Del?hi*/ /opt/delphi_sp ; \
#       ln -s /opt/delphi_sp/executable/delphi95 /usr/local/bin/delphi ; \
#       cd /app ; \
#       rm /tmp/Del?hi* ; \
#       echo "Delphi 95 installed from downloads copy."; \
#    else \
#       echo "Delphi 95 not found in downloads"; \
#    fi

## Try installing Delphi v 7.1 from downloads copy
RUN if test -e downloads/Delphicpp*.zip; then \
       mv downloads/Delphicpp*.zip /tmp; \
       cd /tmp ; \
       unzip -q Delphi*.zip ; \
       rm Delphi*.zip ; \
       mv Delphi*/delphi_v??/bin/delphicpp_release \
          /usr/local/bin/delphi ; \
       chmod +x /usr/local/bin/delphi ; \
       rm -r /tmp/Delphi* ; \
       cd /app ; \
       echo "Delphi v7.1 installed from downloads copy."; \
    else \
       echo "Delphi v7.1 not found in downloads"; \
    fi


## Try installing XPLOR-NIH from downloads copy
RUN apt-get -qq update \
    && apt-get install -y --no-install-recommends \
         bc \
    && rm -rf /var/lib/apt/lists/*

RUN if  test -e downloads/xplor-nih-????-db.tar.gz \
      && test -e downloads/xplor-nih-????-Linux_x86_64.tar.gz; then \
        cd /opt ; \
        tar zxf /app/downloads/xplor-nih-????-db.tar.gz; \
        tar zxf /app/downloads/xplor-nih-????-Linux_x86_64.tar.gz; \
        cd xplor-nih*; \
        ./configure -symlinks /usr/local/bin; \
        rm /app/downloads/xplor-nih-????-db.tar.gz; \
        rm /app/downloads/xplor-nih-????-Linux_x86_64.tar.gz; \
        ## try to minimize xplorer installation
        rm -r python deprecated eginput tcl test; \ 
        cd /app ; \
        echo "XPlor NIH installed from downloads copy."; \
    else \
        echo "XPlor NIH not found in downloads."; \
    fi 


## CMD ["python"]
