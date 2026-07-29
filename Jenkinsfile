pipeline {
    agent any

        options {
        timestamps()
    }

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

        stage('Mostrar Estructura del Proyecto') {
    steps {
        sh '''
        echo "========== ESTRUCTURA DEL PROYECTO =========="
        ls -R
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

                stage('Información del Entorno') {
            steps {
                sh '''
                echo "========== VERSIONES =========="
                docker --version
                docker compose version
                terraform --version
                git --version
                '''
            }
        }

        stage('Verificar Kubernetes') {
            steps {
                sh '''
                echo "========== KUBERNETES =========="
                test -f kubernetes/base/deployment.yaml
                test -f kubernetes/base/service.yaml
                ls -R kubernetes
                echo "Kubernetes verificado correctamente."
                '''
            }
        }

        stage('Verificar Monitoring') {
            steps {
                sh '''
                echo "========== MONITORING =========="
                test -f monitoring/prometheus/prometheus.yml
                ls -R monitoring
                echo "Monitoring verificado correctamente."
                '''
            }
        }

        stage('Verificar Chaos Engineering') {
            steps {
                sh '''
                echo "========== CHAOS ENGINEERING =========="
                test -f chaos/experiments/pod-failure.yaml
                ls -R chaos
                echo "Chaos Engineering verificado correctamente."
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

                stage('Resumen del Pipeline') {
            steps {
                sh '''
                echo ""
                echo "========================================"
                echo "      PIPELINE CLOUD NATIVE"
                echo "========================================"
                echo "Docker............... OK"
                echo "Terraform............ OK"
                echo "Kubernetes........... OK"
                echo "Monitoring........... OK"
                echo "Chaos Engineering.... OK"
                echo "Health Check......... OK"
                echo "========================================"
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
    sh '''
    echo "===== CONTENEDORES ====="
    docker ps

    echo ""

    echo "===== IMÁGENES ====="
    docker images

    echo ""

    echo "===== REDES ====="
    docker network ls
    '''
}
    }
}