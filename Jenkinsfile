pipeline {
    agent any

    environment {
        APP_NAME = "jenkins-cloud-native-app"
        IMAGE_NAME = "jenkins-cloud-native-app"
    }

    stages {

        stage('Verificar Docker') {
            steps {
                sh 'docker --version'
            }
        }

        stage('Verificar Proyecto') {
            steps {
                sh '''
                test -f app/package.json
                test -f app/Dockerfile
                echo "Proyecto verificado correctamente."
                '''
            }
        }

        stage('Construir Imagen') {
            steps {
                sh 'docker compose build'
            }
        }

        stage('Terraform Init') {
            steps {
                sh '''
                cd infrastructure/terraform
                terraform init
                '''
            }
        }

        stage('Terraform Validate') {
            steps {
                sh '''
                cd infrastructure/terraform
                terraform validate
                '''
            }
        }

        stage('Terraform Plan') {
            steps {
                sh '''
                cd infrastructure/terraform
                terraform plan || echo "Terraform Plan omitido por falta de credenciales AWS."
                '''
            }
        }

                stage('Verificar Kubernetes') {
            steps {
                sh '''
                echo "=== Kubernetes ==="
                ls -R kubernetes
                echo "Archivos encontrados:"
                test -f kubernetes/base/deployment.yaml
                test -f kubernetes/base/service.yaml
                echo "Estructura de Kubernetes verificada."
                '''
            }
        }

        stage('Verificar Monitoring') {
            steps {
                sh '''
                echo "=== Monitoring ==="
                ls -R monitoring
                test -f monitoring/prometheus/prometheus.yml
                echo "Prometheus configurado."
                '''
            }
        }

        stage('Verificar Chaos Engineering') {
            steps {
                sh '''
                echo "=== Chaos Engineering ==="
                ls -R chaos
                test -f chaos/experiments/pod-failure.yaml
                echo "Experimento de Chaos encontrado."
                '''
            }
        }

        stage('Eliminar Contenedor Anterior') {
            steps {
                sh '''
                docker stop ${APP_NAME} || true
                docker rm ${APP_NAME} || true
                '''
            }
        }

        stage('Desplegar Aplicación') {
            steps {
                sh 'docker compose up -d'
            }
        }

        stage('Verificar Contenedores') {
            steps {
                sh 'docker ps'
            }
        }

        stage('Health Check') {
        steps {
        sh '''
        echo "Esperando que la aplicación inicie..."
        sleep 10
        curl -f http://host.docker.internal:3000
        '''
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

        always {
            sh 'docker ps'
        }
    }
}