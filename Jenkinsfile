pipeline {
    agent any
    environment {
        REGISTRY   = "192.168.100.102:5000"
        APP_NAME   = "sample-app"
        KUBECONFIG = "/var/lib/jenkins/.kube/config"
    }

    stages {
        stage('Checkout') {
            steps {
                git branch: 'main', url: 'https://github.com/YOUR-USER/sample-app.git'
            }
        }

        stage('Build & Push Docker Image') {
            steps {
                sh '''
                echo "🚀 Building Docker image..."
                docker build -t $REGISTRY/$APP_NAME:$BUILD_NUMBER -t $REGISTRY/$APP_NAME:latest .
                
                echo "📤 Pushing Docker images..."
                docker push $REGISTRY/$APP_NAME:$BUILD_NUMBER
                docker push $REGISTRY/$APP_NAME:latest
                '''
            }
        }

        stage('Deploy to Kubernetes') {
            steps {
                sh '''
                echo "📦 Deploying to Kubernetes..."
                kubectl set image deployment/$APP_NAME $APP_NAME=$REGISTRY/$APP_NAME:$BUILD_NUMBER || \
                kubectl apply -f deployment.yaml

                # Annotate for rollout history
                kubectl annotate deployment $APP_NAME kubernetes.io/change-cause="Jenkins Build #$BUILD_NUMBER" --overwrite
                '''
            }
        }

        stage('Verify Rollout') {
            steps {
                sh '''
                echo "🔍 Checking rollout status..."
                kubectl rollout status deployment/$APP_NAME
                '''
            }
        }
    }
}

