FROM condaforge/miniforge3
ENV PATH="/opt/conda/bin:${PATH}"

# store the FSL public conda channel
ENV FSL_CONDA_CHANNEL="https://fsl.fmrib.ox.ac.uk/fsldownloads/fslconda/public"

# entrypoint activates conda environment and fsl when you `docker run <command>`
COPY /entrypoint /entrypoint

# make entrypoint executable
RUN chmod +x /entrypoint

# install tini into base conda environment
RUN /opt/conda/bin/conda install -n base -c conda-forge tini

# as a demonstration, install ONLY FSL's bet (brain extraction) tool. This is an example of a minimal, yet usable container without the rest of FSL being installed
# to see all packages available use a browser to navigate to: https://fsl.fmrib.ox.ac.uk/fsldownloads/fslconda/public/
# note the channel priority. The FSL conda channel must be first, then condaforge
RUN /opt/conda/bin/conda install -n base -c $FSL_CONDA_CHANNEL fsl -c conda-forge

# set FSLDIR so FSL tools can use it, in this minimal case, the FSLDIR will be the root conda directory
ENV FSLDIR="/opt/conda"

ENTRYPOINT [ "/opt/conda/bin/tini", "--", "/entrypoint" ]

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
