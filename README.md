# STARR-ONCOLOGY Data Lake ARPA-H

Welcome to the STARR-ONCOLOGY Data Lake ARPA-H project. This repository contains resources and documentation for our oncology data initiatives, aimed at facilitating cancer research and improving patient outcomes.

## Overview

The Oncology Data Lake project provides comprehensive datasets and tools for analyzing and sharing healthcare data. Our primary focus is on extracting structured information from unstructured clinical data, ensuring patient privacy, and creating high-quality training data for machine learning models.

## Repository Structure

**Core Documentation (`src/`)**
- Primary Documents
  - `about.qmd` - Project overview and dataset descriptions
  - `data_labeling.qmd` - Data labeling guidelines and methods
  - `data_metrics.qmd` - Dataset statistics and quality analysis
  - `data_dictionary.qmd` - OMOP-CDM schema reference
  - `metadata.qmd` - Metadata standards and documentation

- Configuration Files
  - `_quarto.yml` - Quarto project settings
  - `sql_params.yml` - Database parameters
  - `styles.css` - Custom styling

- Source Code & Assets
  - `R/` - R analysis scripts and utilities
  - `fonts/` - Typography resources
  - `images/` - Documentation images and diagrams

- Genomic Data
  - `bed_files/`
    - `Heme-STAMP_v1_APR2018.bed`
    - `Heme-STAMP_v2_AUG2018.bed`
    - `STAMP1_OCT2014.bed`
    - `STAMP2_OCT2015.bed`
    - `STAMP3_SEP2018.bed`

- Data Dictionaries
  - `cap_forms_data_dict/` - CAP Forms reference
  - `dicom_data_dict/` - DICOM metadata schema
  - `neuralframe_data_dict/` - NeuralFrame documentation
  - `omop_data_dict/` - OMOP CDM specifications
  - `philips_ispm_data_dict/` - Philips ISPM reference
  - `stamp_data_dict/` - STAMP assay documentation
  - `starr_deid_data_dict/` - De-identification protocols

- Data Releases
  - `aug_2025/` (Current)
    - Clinical metrics and analyses
    - Tumor board documentation
    - Imaging data analysis
    - SQL queries and datasets
  - `may_2025/` - Previous release
  - `feb_2025/` - Initial release
    - Demographic studies
    - PHI labeling protocols
    - Release documentation

**Development Setup**
- `.devcontainer/` - Development environment configuration
- `.github/` - GitHub workflows and templates
- `.vscode/` - VS Code workspace settings
- `.venv/` - Python virtual environment
- `.cspell/` - Spell check rules

**Build & Configuration**
- `Dockerfile` - Container definition
- `pyproject.toml` - Python dependencies
- `install.R` - R package installer
- `post_create.sh` - Setup script
- `uv.lock` - Python dependency lock
- `README.md` - Main documentation

## Using the Repository in Visual Studio Code with Devcontainer

### Prerequisites

- Install [Visual Studio Code](https://code.visualstudio.com/).
- Install [Docker](https://www.docker.com/).

### Getting Started

1. **Clone the Repository**:
   ```sh
   git clone https://github.com/your-username/starr-oncology-data-lake-arpah.git
   cd starr-oncology-data-lake-arpah
2. Open the Repository in VS Code:
    * Launch Visual Studio Code.
    * Open the cloned repository folder.
3. Open in Devcontainer:
    * When you open the repository in VS Code, you should see a prompt to reopen the folder in a devcontainer. Click "Reopen in Container".
    * If you don't see the prompt, you can manually reopen in a container by clicking on the green button in the bottom-left corner of the VS Code window and selecting "Reopen in Container".
4. Run Quarto Documents:
    * Open any .qmd file (e.g., data_labeling.qmd).
    * Click the "Render" button in the top-right corner of the editor to render the document.

Example: Rendering data_labeling.qmd

1. Open data_labeling.qmd in VS Code.
2. Click the "Render" button to generate the HTML output.
3. View the rendered document in the browser to see the visualizations and tables.