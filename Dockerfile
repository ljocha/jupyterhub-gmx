# FROM cerit.io/ljocha/gromacs:2023-2-plumed-2-9-afed-pytorch-model-cv as gmx
FROM quay.io/jupyter/base-notebook

USER 0
RUN apt update \
&& apt install -y curl git \
&& apt clean  \
&& rm -rf /var/lib/apt/lists/*


RUN cd /tmp && curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl" && install -m 755 kubectl /opt/conda/bin

COPY --chown=jovyan gmx-wrap2.sh /usr/local/bin/gmx

USER ${NB_USER}

RUN pip install nglview mdtraj

RUN cd /tmp && git clone --single-branch -b k8s https://github.com/ljocha/GromacsWrapper.git && pip install ./GromacsWrapper && rm -rf GromacsWrapper


