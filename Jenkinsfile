pipeline {
    agent any

    tools {
        git 'Default'
        jdk 'JDK17' // Lembre-se de configurar essa ferramenta no Jenkins
        Maven 'Maven3'
    }

    stages {
        stage('Checkout') {
            steps {
                echo 'Baixando código do GitHub...'
                checkout scm
            }
        }

        stage('Build & Test with Maven') {
            steps {
                echo 'Compilando e testando com Maven...'
                // Usamos o Maven Wrapper (se existir) ou o comando 'mvn'
                sh 'mvn clean install'
            }
        }

        stage('Build Docker Image') {
            steps {
                script {
                    echo 'Construindo imagem Docker...'
                    def imageName = "projeto-xadrez:${env.BUILD_NUMBER}"
                    sh "docker build -t ${imageName} ."
                    echo "Imagem Docker '${imageName}' construída."
                }
            }
        }

        stage('Run Game in Docker (Verification)') {
            steps {
                script {
                    echo 'Verificando a execução do jogo dentro do contêiner...'
                    def imageName = "projeto-xadrez:${env.BUILD_NUMBER}"
                    sh "docker run --rm ${imageName}"
                    echo 'Verificação concluída!'
                }
            }
        }
    }
    
    post {
        always {
            echo 'Limpando imagens Docker antigas...'
            // Comando para remover imagens de builds anteriores deste job
            sh """
                docker images -a --filter=reference='projeto-xadrez:*' --format='{{.ID}} {{.Tag}}' | grep -v "<none>" | grep -v "${env.BUILD_NUMBER}" | awk '{print \$1}' | xargs --no-run-if-empty docker rmi -f || true
            """
        }
    }
}
