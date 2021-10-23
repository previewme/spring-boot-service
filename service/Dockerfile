FROM public.ecr.aws/amazoncorretto/amazoncorretto:17.0.0

RUN groupadd -g 999 appuser && useradd -r -u 999 -g appuser appuser
USER appuser

EXPOSE 8080

ENTRYPOINT exec java -XX:+UseG1GC -XX:MaxRAMPercentage=70 -XX:+AlwaysPreTouch -XX:+UseStringDeduplication -Djava.security.egd=file:/dev/./urandom $JAVA_OPTS -jar app.jar

HEALTHCHECK --start-period=300s \
  CMD curl --silent --fail --max-time 30 http://localhost:8080/actuator/health || exit 1

COPY *.jar app.jar