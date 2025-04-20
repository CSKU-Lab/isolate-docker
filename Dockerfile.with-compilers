FROM cskulab/isolate

# Set up compiler and interpreter environments

# Python Lang
RUN apt update 
RUN apt install -y python3 python3-pip

# C Lang
RUN apt install -y gcc

# C++ Lang
RUN apt install -y g++

# Java Lang
RUN apt install -y openjdk-17-jdk

# Go Lang
RUN apt install -y golang-go

# NodeJS Lang
RUN apt install -y nodejs

ENTRYPOINT ["/bin/bash", "-c", "tail > /dev/null"]
