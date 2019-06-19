pipeline {
    agent any

    stages {
        stage('Terraform Init') {
            steps {
                script {
                    sh 'source /etc/profile; echo $PATH; cd terraform; terraform init; terraform plan'
                }
            }
        }
    }
}