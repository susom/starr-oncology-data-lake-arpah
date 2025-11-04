FROM rocker/rstudio:4.4

# install required libraries
RUN sudo apt-get update && apt-get install -y libxml2-dev \
                                              libcurl4-openssl-dev \
                                              zlib1g-dev \
                                              xdg-utils \
                                              libpng-dev \
                                              curl \
                                              libfontconfig1-dev \
                                              libfreetype6-dev \
                                              pkg-config \
                                              libharfbuzz-dev \
                                              libfribidi-dev 

# Install R packages
RUN mkdir /temp
COPY install.R /temp/install.R
RUN R -f /temp/install.R

# install language server
RUN R -e 'install.packages("languageserver")'

# Download the latest installer
ADD https://astral.sh/uv/install.sh /uv-installer.sh

# Run the installer then remove it
RUN sh /uv-installer.sh && rm /uv-installer.sh

# Ensure the installed binary is on the `PATH`
ENV PATH="/root/.local/bin/:$PATH"