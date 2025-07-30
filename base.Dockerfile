# Starting from the base Conda image
FROM continuumio/miniconda3

# Copy the config file for creating the environment
COPY environment.yml .

# Create the Conda environment called sktime-test from environment.yml
RUN conda env create -f environment.yml
