pipeline {
    agent any

    environment {
        APP_NAME = "jenkins-cloud-native-app"
        IMAGE_NAME = "jenkins-cloud-native-app"
    }

    stages {

        stage('Verificar Docker') {
            steps {
                bat 'docker --version'
            }
        }

        stage('Construir Imagen') {
            steps {
                bat 'docker build -t %IMAGE_NAME% ./app'
            }
        }

        stage('Eliminar Contenedor Anterior') {
            steps {
                bat '''
                docker stop %APP_NAME% || exit /b 0
                docker rm %APP_NAME% || exit /b 0
                '''
            }
        }

        stage('Desplegar Aplicación') {
            steps {
                bat 'docker compose up -d'
            }
        }

        stage('Verificar Contenedores') {
            steps {
                bat 'docker ps'
            }
        }

    }

    post {
        success {
            echo 'Pipeline ejecutado correctamente.'
        }

        failure {
            echo 'El pipeline falló.'
        }
    }
}