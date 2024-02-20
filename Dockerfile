FROM cerit.io/ljocha/gromacs:2023-2-plumed-2-9-afed-pytorch-model-cv as gmx
FROM quay.io/jupyter/base-notebook


USER 0
RUN apt update \
&& apt install -y gcc \
&& apt install -y mpich \
&& apt install -y libcufft10 libmpich12 libblas3 libgomp1 \
&& apt install -y rsync \
&& apt install -y curl git \
&& apt clean  \
&& rm -rf /var/lib/apt/lists/*

RUN pip install nglview mdtraj

RUN cd /tmp && curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl" && install -m 755 kubectl /opt/conda/bin


COPY --from=gmx /build/libtorch /build/libtorch
ENV LD_LIBRARY_PATH=/build/libtorch/lib:$LD_LIBRARY_PATH
ENV CPLUS_INCLUDE_PATH=/build/libtorch/include:$CPLUS_INCLUDE_PATH

COPY --from=gmx /build/libtorch/lib/* /usr/local/lib/
COPY --from=gmx /usr/local/bin /usr/local/bin
COPY --from=gmx /usr/local/lib/libplumed* /usr/local/lib/
COPY --from=gmx /usr/local/lib/plumed/ /usr/local/lib/plumed/
COPY --from=gmx /usr/local/cuda/ /usr/local/cuda/
COPY --from=gmx /etc/ld.so.conf.d/000_cuda.conf /etc/ld.so.conf.d/

COPY --from=gmx /gromacs /gromacs

RUN ldconfig

USER ${NB_USER}

RUN cd /tmp && git clone --single-branch -b k8s https://github.com/ljocha/GromacsWrapper.git && pip install ./GromacsWrapper && rm -rf GromacsWrapper


