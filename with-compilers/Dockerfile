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

# Rust
RUN curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y

CMD ["/bin/bash", "-c", "tail -f > /dev/null"]
