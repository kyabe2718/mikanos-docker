FROM ubuntu:18.04

LABEL maintainer "kyabe2718 <kyabetsu.3141@gmail.com>"

RUN apt-get update && apt-get install -y \
    bash \
    git \
    build-essential \
    qemu-system-x86 \
    ansible \
    dosfstools \
    sudo \
    x11-apps \
    python3 \
    python3-distutils && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

WORKDIR /root

RUN git clone --depth 1  https://github.com/uchan-nos/mikanos-build.git osbook

RUN cd osbook/devenv && ansible-playbook -K -i ansible_inventory ansible_provision.yml

RUN cd edk2 && make -C BaseTools/Source/C && \
    /bin/bash -c "source ./edksetup.sh; sed -i '/CLANG38/ s/-flto//' Conf/tools_def.txt; build --platform=OvmfPkg/OvmfPkgX64.dsc --buildtarget=DEBUG --arch=X64 --tagname=CLANG38"

RUN cd edk2 && ln -s ../mikanos/MikanLoaderPkg .
RUN echo "cd /root/edk2 && source ./edksetup.sh && cd" >> /root/.bashrc

CMD ["/bin/bash"]

