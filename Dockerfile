FROM oraclelinux:10

RUN echo > /etc/dnf/vars/ociregion \
    && dnf -y install dnf-plugins-core \
    && dnf config-manager --enable ol10_codeready_builder ol10_distro_builder \
    && dnf -y install oracle-epel-release-el10 python3-pip python3-setuptools \
    && dnf config-manager --setopt=tsflags=nodocs --save \
    && dnf -y groupinstall "Development Tools" "RPM Development Tools" \
    && dnf -y install nodejs npm which \
    && dnf -y clean all \
    && npm i -g corepack \
    && corepack prepare yarn@stable --activate \
    && python3 -m pip install --no-cache-dir tito==0.6.22 \
    && rpmdev-setuptree

COPY scripts/build-rhsm.sh /
RUN chmod +x /build-rhsm.sh

CMD ["/build-rhsm.sh"]
