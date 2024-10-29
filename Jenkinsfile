pipeline {
    agent any

    environment {
        AWS_ACCOUNT_ID = '971422678337'
        AWS_CREDENTIALS_ID = 'aws_credentials'
        AWS_REGION = 'us-east-1'
        CLUSTER_NAME = 'comet-eks-cluster'
        ECR_REPOSITORY = "${AWS_ACCOUNT_ID}.dkr.ecr.${AWS_REGION}.amazonaws.com/comet-app-repo"
    }

    stages {
        stage('Checkout') {
            steps {
                git 'https://github.com/Infotrend-Inc/COMET-REACT.git'
            }
        }

        stage('Log in to Amazon ECR') {
            steps {
                withCredentials([[$class: 'AmazonWebServicesCredentialsBinding', credentialsId: "${AWS_CREDENTIALS_ID}"]]) {
                    bat '''
                    aws ecr get-login-password --region %AWS_REGION% | docker login --username AWS --password-stdin %AWS_ACCOUNT_ID%.dkr.ecr.%AWS_REGION%.amazonaws.com
                    '''
                }
            }
        }

        stage('Pull Docker image') {
            steps {
                bat '''
                docker pull %ECR_REPOSITORY%:react-latest
                '''
            }
        }

        stage('Update EKS kubeconfig') {
            steps {
                withCredentials([[$class: 'AmazonWebServicesCredentialsBinding', credentialsId: "${AWS_CREDENTIALS_ID}"]]) {
                    bat '''
                    aws eks update-kubeconfig --region %AWS_REGION% --name %CLUSTER_NAME%
                    '''
                }
            }
        }

       stage('Deploy to EKS') {
            steps {
                withCredentials([[$class: 'AmazonWebServicesCredentialsBinding', credentialsId: AWS_CREDENTIALS_ID]]) {
                    bat '''
                    kubectl set image deployment/react-app react-container=%ECR_REPOSITORY%:react-latest --namespace=default
                    kubectl rollout status deployment/react-app --namespace=default
                    '''
                }
            }
        }
    }
}
