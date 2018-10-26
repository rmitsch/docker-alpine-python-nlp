 
FROM python:3.5-alpine

##########################################
# 1. Copy relevant files into container.
##########################################

# Copy file with python requirements into container.
COPY requirements.txt /tmp/requirements.txt
# Copy file containing commands for installing numpy versus openblas.
COPY install_numpy_with_openblas.sh /tmp/install_numpy_with_openblas.sh

##########################################
# 2. Prepare environment variables.
##########################################

# Set versions of numpy and openblas to be installed.
ENV NUMPY_VERSION="1.13.1" \ 
	OPENBLAS_VERSION="0.2.18" 

##########################################
# 3. Install numpy with openblas.
##########################################

RUN apk update && \
	# Make setup script executable.
	chmod +x /tmp/install_numpy_with_openblas.sh && \
	# Install various drivers required by python dependencies.
	apk add libffi-dev=3.2.1-r4 zlib-dev=1.2.11-r1 libxml2=2.9.8-r1 libxml2-dev=2.9.8-r1 libxslt-dev=1.1.32-r0 && \
	# Workaround to avoid "Text file busy" message.
	sync && \
	# Install numpy with openblas.
 	./tmp/install_numpy_with_openblas.sh && \
 	# Install python dependencies.
	pip install -r /tmp/requirements.txt && \
	# Download spacy's model of the english language.
	python -m spacy download en 
