pipeline {
    agent any

    stages {
        stage('Terraform Apply') {
            steps {
                script {
                    sh 'terraform plan'
                }
            }
        }
    }
}