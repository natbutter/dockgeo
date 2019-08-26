#To build this docker file
#docker build -t pygeoc .

#To run this, with an interactive python2 temrinal, mounting your current host directory in the container directory at /workspace use:
#sudo docker run -it --rm -v`pwd`:/workspace pyg /bin/bash

#To run a jupyter notebook server with the python 2 conda environement
#sudo docker run -p 8888:8888 -it --rm -v`pwd`:/workspace pyg /bin/bash -c "source activate py2GEOL && jupyter notebook --allow-root --ip=0.0.0.0 --no-browser"

# Pull base image.
# Pull base image.
FROM ubuntu:xenial
MAINTAINER Nathaniel Butterworth

#Create some directories to work with
WORKDIR /build

#Install ubuntu libraires and packages
RUN apt-get update -y

RUN apt-get update -qq && apt-get dist-upgrade -y && \
    apt install vim gmt gmt-dcw gmt-gshhg netcdf-bin -y && \
    echo "cat /etc/motd" >> /root/.bashrc

COPY version /etc/motd

RUN apt-get install -y wget


#Download pygplates and install it
#RUN wget https://sourceforge.net/projects/gplates/files/pygplates/beta-revision-12/pygplates-ubuntu-xenial_1.5_1_amd64.deb
COPY pygplates-ubuntu-xenial_1.5_1_amd64.deb pygplates-ubuntu-xenial_1.5_1_amd64.deb

RUN apt-get install libglew-dev python-dev libboost-dev libboost-python-dev libboost-thread-dev libboost-program-options-dev libboost-test-dev libboost-system-dev libqt4-dev libgdal1-dev libcgal-dev libproj-dev libqwt-dev libfreetype6-dev libfontconfig1-dev libxrender-dev libice-dev libsm-dev -y

RUN dpkg -i pygplates-ubuntu-xenial_1.5_1_amd64.deb

#Download conda python because I like it
RUN wget -O ~/miniconda.sh https://repo.continuum.io/miniconda/Miniconda2-latest-Linux-x86_64.sh  && \
     chmod +x ~/miniconda.sh && \
     ~/miniconda.sh -b -p /opt/conda && \
     rm ~/miniconda.sh 
     
RUN /opt/conda/bin/conda install python=2.7.14 scipy=1.0.0 scikit-learn=0.19.1 matplotlib=2.1.2 shapely=1.6.4 numpy=1.14.1 pandas=0.22.0 xarray=0.10.1 seaborn=0.8.1

#RUN /opt/conda/bin/conda init bash
#RUN /opt/conda/bin/conda activate py2GEOL

#RUN /opt/conda/bin/conda install gmt --channel conda-forge

#Get GMT
#RUN wget ftp://ftp.soest.hawaii.edu/gmt/gmt-5.4.5-src.tar.xz
#RUN tar xf gmt-5.4.5-src.tar.xz
#RUN mkdir  ./gmt-5.4.5/build
#RUN cd ./gmt-5.4.5/build && \
#    cmake -DCMAKE_INSTALL_PREFIX=/usr \
#      -DGSHHG_ROOT=/usr/share/gmt/coast \
#      -DGMT_LIBDIR=lib \
#      -DDCW_ROOT=/usr/share/gmt/dcw \
#      -DGMT_DATADIR=share/gmt \
#      -DGMT_MANDIR=share/man \
#      -DGMT_DOCDIR=share/doc/gmt \
#      -DCMAKE_BUILD_TYPE=Release .. && \
#    make && make install

ENV PYTHONPATH ${PYTHONPATH}:/usr/lib:/usr/lib/pygplates/revision12/
ENV PATH "/opt/conda/bin:$PATH"

#Make the workspace persistant
#VOLUME /workspace
WORKDIR /workspace
CMD /bin/bash

#EXPOSE 8888

#Set the path so python can find pygplates
#ENV PYTHONPATH ${PYTHONPATH}:/usr/lib:/usr/lib/pygplates/revision12/
#ENV PATH "/opt/conda/bin:$PATH"

#RUN ln -s /opt/conda/etc/profile.d/conda.sh /etc/profile.d/conda.sh