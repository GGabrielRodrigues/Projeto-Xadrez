# ESTÁGIO 1: Construir o projeto com Maven e JDK 17
FROM maven:3.8-openjdk-17 AS builder

# Define o diretório de trabalho
WORKDIR /app

# Copia o pom.xml e baixa as dependências (otimização de cache)
COPY pom.xml .
RUN mvn dependency:go-offline

# Copia o código-fonte
COPY src ./src

# Roda o Maven para compilar e criar o JAR executável
# O resultado estará em /app/target/
RUN mvn clean package

# ESTÁGIO 2: Criar a imagem final com o JRE 17
FROM openjdk:17-jre-slim

WORKDIR /app

# Copia o JAR executável criado no estágio anterior
# O nome do JAR é definido pelo <artifactId>-<version>-jar-with-dependencies.jar
COPY --from=builder /app/target/projeto-xadrez-1.0-SNAPSHOT-jar-with-dependencies.jar app.jar

# Comando para rodar o jogo quando o contêiner iniciar
ENTRYPOINT ["java", "-jar", "app.jar"]
