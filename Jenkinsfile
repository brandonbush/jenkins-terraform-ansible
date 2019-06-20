pipeline {
    agent any

    stages {
        stage('Terraform Init and Plan') {
            steps {
                script {
                    sh 'cd terraform; terraform init; terraform plan'
                }
            }
        }
        stage('Run Terraform Tests') {
            steps {
                echo 'Running tests here'
            }
        }
        stage('Deploy Terraform') {
            steps {
                script {
                    sh 'cd terraform; terraform apply -auto-approve'
                }
            }
        }
    }
}