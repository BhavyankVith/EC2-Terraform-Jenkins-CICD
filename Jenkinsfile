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
      credentialsId: 'dd5363fb-0a87-45e1-8c1c-7ea77575b4e0', // Use the UUID here
      usernameVariable: 'DOCKER_USER',
      passwordVariable: 'DOCKER_PASS'
    )])
        
        {
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

// To check whether SSH-agent is working fine or not
stage('SSH Test') {
  steps {
    sshagent(credentials: ['ec2-ssh-key-v2']) {
      sh "ssh -o StrictHostKeyChecking=no ec2-user@${EC2_HOST} 'whoami'"
    }
  }
}
stage('Deploy App on EC2') {
  steps {
    withCredentials([
      usernamePassword(
        credentialsId: 'dd5363fb-0a87-45e1-8c1c-7ea77575b4e0',
        usernameVariable: 'DOCKER_USER',
        passwordVariable: 'DOCKER_PASS'
      )
    ]) {
      sshagent(['ec2-ssh-key-v2']) {
        sh """
        ssh ec2-user@${EC2_HOST} 'docker ps'
        ssh -o StrictHostKeyChecking=no ec2-user@${EC2_HOST} << EOF
          echo '${DOCKER_PASS}' | sudo docker login -u '${DOCKER_USER}' --password-stdin
          sudo docker pull ${IMAGE_NAME}:latest
          sudo docker stop devops-app || true
          sudo docker rm devops-app || true
          sudo docker run -d --name devops-app -p 5000:5000 ${IMAGE_NAME}:latest
EOF
        """
          }
        }
      }
    }
  }
}


//Simple approach build 

// pipeline {
//   agent any

//   stages {
//     stage('Build Docker Image') {
//       steps {
//         sh 'docker build -t devops-demo-app .'
//       }
//     }

//     stage('Provision Infrastructure') {
//       steps {
//         sh 'terraform init'
//         sh 'terraform apply -auto-approve'
//       }
//     }
//   }
// }
