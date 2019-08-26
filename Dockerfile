#To build this docker file
#docker build -t dockgeo .

#To run this, with an interactive python2 temrinal, mounting your current host directory in the container directory at /workspace use:
#sudo docker run -it --rm -v`pwd`:/workspace dockgeo /bin/bash

#To run a jupyter notebook server with the python 2 conda environement
#sudo docker run -p 8888:8888 -it --rm -v`pwd`:/workspace dockgeo /bin/bash -c "jupyter notebook --allow-root --ip=0.0.0.0 --no-browser"

# Pull base image.
FROM ubuntu:xenial
MAINTAINER Nathaniel Butterworth

#Create some directories to work with
WORKDIR /build

#Install ubuntu libraires and packages and generic mapping tools (gmt)
RUN apt-get update -y

RUN apt-get update -qq && apt-get dist-upgrade -y && \
    apt install vim gmt gmt-dcw gmt-gshhg netcdf-bin -y && \
    echo "cat /etc/motd" >> /root/.bashrc

COPY version /etc/motd

RUN apt-get install -y wget

#Download pygplates and install it
#RUN wget https://sourceforge.net/projects/gplates/files/pygplates/beta-revision-12/pygplates-ubuntu-xenial_1.5_1_amd64.deb
#If the download does not work you can copy into the repo
COPY pygplates-ubuntu-xenial_1.5_1_amd64.deb pygplates-ubuntu-xenial_1.5_1_amd64.deb

#Install pygplates dependencies
RUN apt-get install libglew-dev python-dev libboost-dev libboost-python-dev libboost-thread-dev libboost-program-options-dev libboost-test-dev libboost-system-dev libqt4-dev libgdal1-dev libcgal-dev libproj-dev libqwt-dev libfreetype6-dev libfontconfig1-dev libxrender-dev libice-dev libsm-dev -y

#Install pygplates
RUN dpkg -i pygplates-ubuntu-xenial_1.5_1_amd64.deb

#Download conda python because I like it
RUN wget -O ~/miniconda.sh https://repo.continuum.io/miniconda/Miniconda2-latest-Linux-x86_64.sh  && \
     chmod +x ~/miniconda.sh && \
     ~/miniconda.sh -b -p /opt/conda && \
     rm ~/miniconda.sh 
     
#Set up the conda environment     
RUN /opt/conda/bin/conda install python=2.7.14 scipy=1.0.0 scikit-learn=0.19.1 matplotlib=2.1.2 shapely=1.6.4 numpy=1.14.1 pandas=0.22.0 xarray=0.10.1 seaborn=0.8.1

#Set the paths
ENV PYTHONPATH ${PYTHONPATH}:/usr/lib:/usr/lib/pygplates/revision12/
ENV PATH "/opt/conda/bin:$PATH"

#Make the workspace persistant
WORKDIR /workspace
CMD /bin/bash

#EXPOSE 8888
