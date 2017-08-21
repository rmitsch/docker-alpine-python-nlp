 
FROM python:3.5-alpine

##########################################
# 1. Copy relevant files into container.
##########################################

# Copy file containing commands for installing numpy versus openblas.
COPY install_numpy_with_openblas.sh /tmp/install_numpy_with_openblas.sh

##########################################
# 2. Prepare repos and env. variables.
##########################################

# Set versions of numpy and openblas to be installed.
ENV NUMPY_VERSION="1.13.1" \ 
	OPENBLAS_VERSION="0.2.18" 

# Allow execution of setup scripts.
RUN chmod +x /tmp/install_numpy_with_openblas.sh && \
	chmod +x /tmp/setup.sh

##########################################
# 3. Install numpy with openblas.
##########################################

# Run setup scripts.
RUN ./tmp/install_numpy_with_openblas.sh