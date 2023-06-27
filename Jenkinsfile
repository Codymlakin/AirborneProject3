pipeline {
    agent any
    
    stages {
        stage('Checkout') {
            steps {
                // Checkout your Terraform configuration from version control
                checkout scm
            }
        }
        
        stage('Terraform Init') {
            steps {
                // Initialize Terraform and download providers
                sh 'terraform init'
            }
        }
        
        // stage('Terraform Plan') {
        //     steps {
        //         // Run Terraform plan to see the planned changes
        //         sh 'terraform plan'
        //     }
        // }
        
        stage('Terraform Apply') {
            steps {
                // Apply the changes using Terraform
                sh 'terraform apply -auto-approve'
            }
        }
    }
}

