pipeline {
    agent any
    environment {
        REGISTRY = "192.168.100.102:5000"
        IMAGE = "sample-app"
    }
    stages {
        stage('Checkout') {
            steps {
                git 'https://github.com/mamungtg/sample-app.git'
            }
        }
        stage('Build & Push Docker Image') {
            steps {
                script {
                    def IMAGE_TAG = "${BUILD_NUMBER}"
                    sh """
                        docker build -t $REGISTRY/$IMAGE:$IMAGE_TAG .
                        docker push $REGISTRY/$IMAGE:$IMAGE_TAG
                    """
                }
            }
        }
        stage('Deploy to Kubernetes') {
            steps {
                script {
                    sh """
                        kubectl set image deployment/$IMAGE $IMAGE=$REGISTRY/$IMAGE:$BUILD_NUMBER
                        kubectl rollout status deployment/$IMAGE
                    """
                }
            }
        }
    }
}

