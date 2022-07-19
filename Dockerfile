FROM quay.io/keycloak/keycloak-x
#docker run -p 80:8080 -e KEYCLOAK_ADMIN=<username> -e KEYCLOAK_ADMIN_PASSWORD=<password> -ti nunimbus/keycloak.x:latest --db-url='jdbc:mysql://<ip>/<database>' --db-username=<db-user> --db-password=<db-password> --http-enabled=true --proxy=passthrough

USER root

RUN microdnf update -y && microdnf install -y git findutils

WORKDIR /opt/keycloak/themes/
RUN git clone https://github.com/nunimbus/nextcloud-theme nextcloud ; \
    git clone https://github.com/nunimbus/nunimbus-theme nunimbus ; \
    find . -name .git | xargs rm -r

WORKDIR /tmp
RUN git clone https://github.com/nunimbus/registration-encrypted-attributes ;
RUN git clone https://github.com/nunimbus/encrypted-attribute-mapper-saml ;
RUN find . -name *.jar | xargs mv -t /opt/keycloak/providers/ ; \
    rm -r /tmp/*

RUN /opt/keycloak/bin/kc.sh build --db=mariadb

RUN microdnf remove -y emacs-filesystem git git-core git-core-doc groff-base less libedit ncurses openssh openssh-clients perl-Carp perl-Data-Dumper perl-Digest perl-Digest-MD5 perl-Encode perl-Errno perl-Error perl-Exporter perl-File-Path perl-File-Temp perl-Getopt-Long perl-Git perl-HTTP-Tiny perl-IO perl-IO-Socket-IP perl-IO-Socket-SSL perl-MIME-Base64 perl-Mozilla-CA perl-Net-SSLeay perl-PathTools perl-Pod-Escapes perl-Pod-Perldoc perl-Pod-Simple perl-Pod-Usage perl-Scalar-List-Utils perl-Socket perl-Storable perl-Term-ANSIColor perl-Term-Cap perl-TermReadKey perl-Text-ParseWords perl-Text-Tabs+Wrap perl-Time-Local perl-URI perl-Unicode-Normalize perl-constant perl-interpreter perl-libnet perl-libs perl-macros perl-parent perl-podlators perl-threads perl-threads-shared ; \
    microdnf clean all

USER 1000
