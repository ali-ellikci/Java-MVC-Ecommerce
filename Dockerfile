FROM tomcat:10.1-jdk21

RUN rm -rf /usr/local/tomcat/webapps/*


WORKDIR /usr/local/tomcat/webapps/Java-MVC-Ecommerce


COPY src/main/webapp/ ./

COPY src/main/java/ /tmp/src/


RUN mkdir -p WEB-INF/classes && \
    find /tmp/src/ -name "*.java" > /tmp/sources.txt && \
    javac -encoding UTF-8 -cp "/usr/local/tomcat/lib/*:WEB-INF/lib/*" -d WEB-INF/classes/ @/tmp/sources.txt && \
    rm -rf /tmp/src /tmp/sources.txt

EXPOSE 8080

CMD ["catalina.sh", "run"]
