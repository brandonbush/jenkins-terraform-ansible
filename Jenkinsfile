pipeline {
    agent any

    stages {
        stage('Terraform Apply') {
            steps {
                script {
                    sh 'source /etc/profile; terraform plan'
                }
            }
        }
    }
}