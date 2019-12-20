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


RUN curl -L https://dev.mysql.com/get/Downloads/Connector-J/mysql-connector-java-${MYSQL_DRIVER_VERSION}.tar.gz -o mysql-connector-java.tar.gz
RUN tar xf mysql-connector-java.tar.gz && \
  mv mysql-connector-java-${MYSQL_DRIVER_VERSION}/mysql-connector-java-${MYSQL_DRIVER_VERSION}.jar mysql-jdbc.jar && \
  rm -rf mysql-connector-java.tar.gz mysql-connector-java-${MYSQL_DRIVER_VERSION}

RUN chmod 777 /liquibase

ENTRYPOINT [ "/usr/local/bin/entrypoint.sh" ]
CMD ["/bin/sh", "-i"]