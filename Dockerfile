# Use CentOS 7
FROM centos:7.5.1804

# based on https://github.com/pnlbwh/fsl-containers

# set up user and working directory
ARG USER=fsluser
ENV USER="$USER"
ARG CWD=/root
WORKDIR $CWD
ENV PWD="$CWD"

# libraries and commands for FSL
RUN yum -y update \
    && yum -y install epel-release wget file bzip2 openblas-devel which \
    libmng libpng12 libSM gtk2 mesa-dri-drivers

# install FSL, -V 6.0.5.1
RUN wget https://fsl.fmrib.ox.ac.uk/fsldownloads/fslinstaller.py -O fslinstaller.py \
    && python fslinstaller.py -V 6.0.5.1 -d `pwd`/fsl -p

# setup FSL environment
ENV FSLDIR="$PWD/fsl"
ENV PATH="$FSLDIR/bin/:$PATH" \
	FSLMULTIFILEQUIT=TRUE \
	FSLGECUDAQ=cuda.q \
	FSLTCLSH="$FSLDIR/bin/fsltclsh" \
	FSLWISH="$FSLDIR/bin/fslwish" \
	FSLOUTPUTTYPE=NIFTI_GZ

# install gradunwarp
#RUN curl -sSLO https://github.com/Washington-University/gradunwarp/archive/refs/tags/v1.2.0.tar.gz
#RUN tar -xvzf v1.2.0.tar.gz
#RUN rm v1.2.0.tar.gz
#RUN cd gradunwarp-1.2.0; python3 setup.py install

# install ukbb software

ARG VERSION
ARG BUILD_DATE
ARG VCS_REF

LABEL org.label-schema.build-date=$BUILD_DATE \
      org.label-schema.name="ukbb-pipeline" \
      org.label-schema.description="ukbb image pipeline container" \
      org.label-schema.url="http://nirs-fmri.net" \
      org.label-schema.vcs-ref=$VCS_REF \
      org.label-schema.vcs-url="https://github.com/bbfrederick/ukbb-pipeline" \
      org.label-schema.version=$VERSION
