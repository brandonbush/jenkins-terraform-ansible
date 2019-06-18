pipeline {
    agent any

    stages {
        stage('Terraform Init') {
            steps {
                script {
                    sh 'source /etc/profile'
                    sh 'cd terraform; terraform init; terraform plan'
                }
            }
        }
    }
}