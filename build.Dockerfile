# Starting from the base-image
FROM base-image:latest

# Copying new changes to the sktime repository
COPY . .

# Ensure that when the container runs it uses the Python and 
# binaries in the sktime-test environment
ENV PATH /opt/conda/envs/sktime-test/bin:$PATH

# Set ENTRYPOINT to use conda run with your environment
ENTRYPOINT ["conda", "run", "-n", "sktime-test"]
