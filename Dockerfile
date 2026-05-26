FROM tomcat:10.1-jdk21

# Tomcat varsayılan uygulamalarını temizle
RUN rm -rf /usr/local/tomcat/webapps/*

# Uygulama dizinini oluştur
WORKDIR /usr/local/tomcat/webapps/Java-MVC-Ecommerce

# Web kaynaklarını kopyala (JSP, assets, web.xml, lib klasöründeki JAR'lar)
COPY src/main/webapp/ ./

# Java kaynak kodunu geçici olarak kopyala ve konteyner içinde derle
COPY src/main/java/ /tmp/src/

# Sınıfları derle ve WEB-INF/classes altına yerleştir, ardından geçici dosyaları temizle
RUN mkdir -p WEB-INF/classes && \
    find /tmp/src/ -name "*.java" > /tmp/sources.txt && \
    javac -encoding UTF-8 -cp "/usr/local/tomcat/lib/*:WEB-INF/lib/*" -d WEB-INF/classes/ @/tmp/sources.txt && \
    rm -rf /tmp/src /tmp/sources.txt

EXPOSE 8080

CMD ["catalina.sh", "run"]
