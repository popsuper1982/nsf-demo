FROM openjdk:8-jre
RUN mkdir -p /opt/nsf && cd /opt/nsf && \
    wget "http://console.v190808.163skiff.com/download/nsf-agent-v2.5.6-1daf42fe-20190916-162559.jar" -O nsf-agent.jar
ADD ./* /
RUN ls -l .
RUN ls -l ./nsf-demo-stock-viewer/
ADD ./*/target/nsf*.jar /app.jar
ADD ./*/target/classes/nsf.yml /opt/nsf/
RUN mkdir -p /opt/apm && cd /opt/apm && \
    wget "http://console.v190808.163skiff.com/download/napm-java-agent-v5.3.3-190825-36860798.tar.gz" -O napm-java-agent.tar.gz  && \
    tar zxvf napm-java-agent.tar.gz 
ENTRYPOINT ["java","-Xms256m","-Xmx1024m","-Dserver.port=8080","-Dstock_viewer_url=http://stock-viewer-test", "-Dstock_provider_url=http://stock-provider-test", "-Dstock_advisor_url=http://stock-advisor-test", "-Dnsf.prometheus.enable=true","-javaagent:/opt/nsf/nsf-agent.jar=nsf","-javaagent:/opt/apm/napm-java-agent/napm-java-rewriter.jar=conf=napm-agent.properties","-jar","/app.jar"]