pipeline {
    agent any
    environment {
        REGISTRY = "192.168.100.102:5000"
        APP_NAME = "sample-app"
        KUBECONFIG = "/var/lib/jenkins/.kube/config"
    }
    stages {
        stage('Checkout') {
            steps {
                git branch: 'main', url: 'https://github.com/YOUR-USER/sample-app.git'
            }
        }
        stage('Build Docker Image') {
            steps {
                sh 'docker build -t $REGISTRY/$APP_NAME:$BUILD_NUMBER .'
            }
        }
        stage('Push Image') {
            steps {
                sh 'docker push $REGISTRY/$APP_NAME:$BUILD_NUMBER'
            }
        }
        stage('Deploy to Kubernetes') {
            steps {
                sh '''
                kubectl set image deployment/$APP_NAME $APP_NAME=$REGISTRY/$APP_NAME:$BUILD_NUMBER --record || \
                kubectl apply -f deployment.yaml
                '''
            }
        }
    }
}

