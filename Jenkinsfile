pipeline {
    agent any

    stages {
        stage('Terraform Apply') {
            steps {
                // Apply the changes using Terraform
                sh 'terraform apply -auto-approve'
            }
        }
    }
}
