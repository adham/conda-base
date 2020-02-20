FROM ubuntu:18.04

LABEL maintainer="Adham Beykikhoshk <adham@worksafe.vic.gov.au>"
ARG NB_USER="jovyan"
ARG NB_UID="1000"
ARG NB_GID="100"


USER root

RUN apt-get update \
    && apt-get upgrade -yq \
    && apt-get install -yq --no-install-recommends \
        wget \
        git \
        ca-certificates \
    && apt-get clean && rm -rf /var/lib/apt/lists/*


# Enable prompt color in the skeleton .bashrc before creating the default NB_USER
RUN sed -i 's/^#force_color_prompt=yes/force_color_prompt=yes/' /etc/skel/.bashrc

# Create NB_USER wtih name jovyan user with UID=1000 and in the 'users' group
# and make sure these dirs are writable by the `users` group.
RUN echo "auth requisite pam_deny.so" >> /etc/pam.d/su \
    && useradd -m -s /bin/bash -N -u $NB_UID $NB_USER \
    && chmod g+w /etc/passwd 

ENV CONDA_DIR=/opt/miniconda3
ENV PATH=$CONDA_DIR/bin:$PATH 

RUN wget -O /tmp/miniconda https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-x86_64.sh \
    && bash /tmp/miniconda -b -p /opt/miniconda3 \
    && rm /tmp/miniconda \
    && conda update --all --yes \
    && conda clean --all -f -y

USER $NB_UID

ENTRYPOINT [ "bash" ]
