#!/bin/bash

cd /workspaces/starr-oncology-data-lake-arpah
uv init --bare
uv sync
.venv/bin/python -m ipykernel install --user --name=starr-oncology-data-lake-arpah