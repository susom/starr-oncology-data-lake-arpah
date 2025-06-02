FROM rocker/rstudio:4.4

# install required libraries
RUN sudo apt-get update && apt-get install -y libxml2-dev \
                                              libcurl4-openssl-dev \
                                              zlib1g-dev \
                                              xdg-utils

# Install R packages
RUN mkdir /temp
COPY install.R /temp/install.R
RUN R -f /temp/install.R

# install language server
RUN R -e 'install.packages("languageserver")'

RUN apt-get update && apt-get install -y curl libpng-dev
    curl

RUN curl -LsSf https://astral.sh/uv/install.sh | sh
RUN source $HOME/.local/bin/env

RUN cd /workspaces/starr-oncology-data-lake-arpah && uv init --bare
RUN uv add pandas pydicom ipykernel
RUN .venv/bin/python -m ipykernel install --user --name=starr-oncology-data-lake-arpah