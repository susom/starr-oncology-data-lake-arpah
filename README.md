# STARR-ONCOLOGY Data Lake ARPA-H

Welcome to the STARR-ONCOLOGY Data Lake ARPA-H project. This repository contains resources and documentation for our oncology data initiatives, aimed at facilitating cancer research and improving patient outcomes.

## Overview

The Oncology Data Lake project provides comprehensive datasets and tools for analyzing and sharing healthcare data. Our primary focus is on extracting structured information from unstructured clinical data, ensuring patient privacy, and creating high-quality training data for machine learning models.

## Repository Structure

- **src/**: Contains the source files for the project, including Quarto documents and styles.
  - **about.qmd**: Information about the Oncology Data Lake project.
  - **data_labeling.qmd**: Documentation and code for data labeling initiatives.
  - **data_metrics.qmd**: Documentation and code for data metrics and descriptive statistics about the dataset.
  - **data_dictionary.qmd**: Detailed descriptions of the OMOP-CDM tables available in the dataset.
  - **styles.css**: Custom CSS styles for the Quarto documents.
  - **_quarto.yml**: Configuration file for the Quarto project.
  - **fonts**: Directory containing custom fonts for the Quarto documents.
  - **images**: Directory containing images used in the Quarto documents.
  - **omop_data_dict**: Directory containing data dictionary files for the OMOP-CDM tables.
  - **sql**: Directory containing SQL queries for data analysis and transformation.
  - **feb_2025**: Directory containing data files for the February 2025 Release.
- **.devcontainer/**: Contains the configuration files for the development container.
- **.cspell**: Configuration file for the Code Spell Checker extension.
- **Dockerfile**: Specifies the development container image. This file is used to build the container image where the development environment will run.
- **install.R**: Installs the R packages required for the project. This is used withing the Dockerfile
- **README.md**: The main documentation file for the project.

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