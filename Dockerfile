# 빌드용 이미지
# JDK가 있어야 Gradle로 Spring Boot 애플리케이션을 빌드할 수 있음
FROM eclipse-temurin:17-jdk AS builder

# 컨테이너 내부에서 작업할 디렉터리
WORKDIR /app

# Gradle Wrapper 실행 파일 복사
COPY gradlew .

# Gradle Wrapper에 필요한 gradle 디렉터리 복사
COPY gradle gradle

# Gradle 빌드 설정 파일 복사
COPY build.gradle .

# Gradle 프로젝트 설정 파일 복사
COPY settings.gradle .

# 실제 소스 코드 복사
COPY src src

# gradlew에 실행 권한 부여
RUN chmod +x ./gradlew

# Gradle을 이용해 애플리케이션 빌드
# -x test → 테스트는 실행하지 않고 빌드
# 결과물(.jar)은 /app/build/libs/ 아래에 생성됨
RUN ./gradlew build -x test --no-daemon


# 실제 애플리케이션 실행용 이미지
# JDK가 아니라 JRE만 있으면 실행 가능
FROM eclipse-temurin:17-jre

# 컨테이너 내부의 작업 디렉터리
WORKDIR /app

# 첫 번째 단계(builder)에서 생성된 JAR 파일을
# 현재 실행용 이미지의 /app/app.jar로 복사
COPY --from=builder /app/build/libs/*.jar app.jar

# 컨테이너가 사용하는 포트가 8080임을 문서화
EXPOSE 8080

# 컨테이너가 시작될 때 Spring Boot JAR 실행
ENTRYPOINT ["java", "-jar", "app.jar"]