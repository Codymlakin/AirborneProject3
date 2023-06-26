pipeline {
    agent any

    stages {
        stage('Terraform Plan') {
            steps {
                // Run Terraform plan to see the planned changes
                sh 'terraform plan'
            }
        }

        stage('Terraform Apply') {
            steps {
                // Apply the changes using Terraform
                sh 'terraform apply -auto-approve'
            }
        }
    }
}
