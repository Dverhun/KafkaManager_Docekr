FROM openjdk:11-slim

ENV KAFKA_MANAGER_DIR="/kafka-manager" \
	KAFKA_MANAGER_VERSION="3.0.0.5" \
	ZOOKEEPER="zookeeper1.server.local:2181,zookeeper2.server.local:2181,zookeeper3.server.local:2181"

RUN apt-get update && apt-get -y install git curl unzip && \
	mkdir "${KAFKA_MANAGER_DIR}" && cd "${KAFKA_MANAGER_DIR}" && \
	git clone https://github.com/yahoo/CMAK.git && \
	cd "${KAFKA_MANAGER_DIR}"/CMAK && \
    echo 'scalacOptions ++= Seq("-Xmax-classfile-name", "200")' >> build.sbt && \
    ./sbt clean dist && \
	unzip -d "${KAFKA_MANAGER_DIR}" "${KAFKA_MANAGER_DIR}"/CMAK/target/universal/cmak-"${KAFKA_MANAGER_VERSION}".zip && \
	apt clean && apt-get clean && \
	rm -rf /tmp/* /root/.sbt /root/.ivy2 "${KAFKA_MANAGER_DIR}"/CMAK 

WORKDIR "${KAFKA_MANAGER_DIR}"/cmak-"${KAFKA_MANAGER_VERSION}"

RUN sed -i "s/kafka-manager-zookeeper:2181/${ZOOKEEPER}/g" conf/application.conf 

EXPOSE 9000

ENTRYPOINT ["./bin/cmak"]

CMD [""]
