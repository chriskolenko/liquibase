FROM openjdk:11-slim-buster

ARG LIQUIBASE_VERSION=3.8.1
ENV LIQUIBASE_VERSION=${LIQUIBASE_VERSION}
ARG POSTGRES_DRIVER_VERSION=42.2.9
ENV POSTGRES_DRIVER_VERSION=${POSTGRES_DRIVER_VERSION}
ARG MYSQL_DRIVER_VERSION=8.0.18
ENV MYSQL_DRIVER_VERSION=${MYSQL_DRIVER_VERSION}

RUN mkdir /liquibase
WORKDIR /liquibase

COPY bin/* /usr/local/bin/
COPY liquibase.properties /liquibase/liquibase.properties

RUN apt-get update && apt-get install -y \
  curl

RUN curl -L https://github.com/liquibase/liquibase/releases/download/v${LIQUIBASE_VERSION}/liquibase-${LIQUIBASE_VERSION}.tar.gz -o liquibase-core-${LIQUIBASE_VERSION}-bin.tar.gz \
  && tar -xzf liquibase-core-${LIQUIBASE_VERSION}-bin.tar.gz \
  && rm liquibase-core-${LIQUIBASE_VERSION}-bin.tar.gz

RUN curl -L https://jdbc.postgresql.org/download/postgresql-${POSTGRES_DRIVER_VERSION}.jar -o postgres-jdbc.jar

# RUN set -x -e -o pipefail;\
#     echo "JDBC DRIVER VERSION: $jdbc_driver_version";\
#     chmod +x /opt/test_liquibase_mysql/run_test.sh;\
#     cd /opt/jdbc;\
#     tarfile=mysql-connector-java-${jdbc_driver_version}.tar.gz;\
#     curl -SOLs ${jdbc_driver_download_url}/${tarfile};\
#     tar -x -f ${tarfile};\
#     jarfile=mysql-connector-java-${jdbc_driver_version}-bin.jar;\
#     mv mysql-connector-java-${jdbc_driver_version}/${jarfile} ./;\
#     rm -rf ${tarfile} mysql-connector-java-${jdbc_driver_version};\
#     ln -s ${jarfile} mysql-jdbc.jar;

RUN chmod 777 /liquibase

ENTRYPOINT [ "/usr/local/bin/entrypoint.sh" ]
CMD ["/bin/sh", "-i"]