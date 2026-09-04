FROM 306dev.harbor.bf.okestro.cloud/cicd-image/maven:3.9.11-eclipse-temurin-8 AS build

WORKDIR /app

COPY settings.xml /root/.m2/settings.xml
COPY pom.xml ./
COPY src ./src
RUN mvn -B -U -DskipTests -Dfile.encoding=UTF-8 -s /root/.m2/settings.xml package

FROM 306dev.harbor.bf.okestro.cloud/cicd-image/tomcat:9.0-jre8

WORKDIR /usr/local/tomcat

# Deploy as root context (/)
RUN rm -rf webapps/*
COPY --from=build /app/target/sht_webapp.war webapps/ROOT.war

EXPOSE 8080
ENTRYPOINT ["catalina.sh", "run"]
