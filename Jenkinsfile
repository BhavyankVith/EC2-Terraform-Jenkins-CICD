pipeline {
  agent any

  environment {
    IMAGE_NAME = "bhavyank99/devops-demo-app"
    EC2_USER   = "ec2-user"
    EC2_HOST   = "EC2_PUBLIC_IP"
  }

  stages {

    stage('Build Docker Image') {
      steps {
        sh 'docker build -t $IMAGE_NAME:latest .'
      }
    }

    stage('Push Image to Docker Hub') {
      steps {
        withCredentials([usernamePassword(
          credentialsId: 'dockerhub-creds',
          usernameVariable: 'DOCKER_USER',
          passwordVariable: 'DOCKER_PASS'
        )]) {
          sh '''
          echo $DOCKER_PASS | docker login -u $DOCKER_USER --password-stdin
          docker push $IMAGE_NAME:latest
          '''
        }
      }
    }

    stage('Provision Infrastructure') {
      steps {
        sh 'terraform init'
        sh 'terraform apply -auto-approve'
      }
    }

    stage('Deploy App on EC2') {
      steps {
        sshagent(['ec2-ssh-key']) {
          sh '''
          ssh -o StrictHostKeyChecking=no $EC2_USER@$EC2_HOST "
            docker pull $IMAGE_NAME:latest &&
            docker stop devops-app || true &&
            docker rm devops-app || true &&
            docker run -d --name devops-app -p 5000:5000 $IMAGE_NAME:latest
          "
          '''
        }
      }
    }
  }
}
