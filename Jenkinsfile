pipeline {
  agent any

  stages {
    stage('Build Docker Image') {
      steps {
        sh 'docker build -t devops-demo-app .'
      }
    }

    stage('Provision Infrastructure') {
      steps {
        sh 'terraform init'
        sh 'terraform apply -auto-approve'
      }
    }
  }
}
