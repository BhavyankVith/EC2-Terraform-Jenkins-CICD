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

stage('Deploy App on EC2') {
    steps {
        // Use both SSH and Docker credentials
        withCredentials([usernamePassword(credentialsId: 'dd5363fb-0a87-45e1-8c1c-7ea77575b4e0', usernameVariable: 'DOCKER_USER', passwordVariable: 'DOCKER_PASS')]) {
            sshagent(['ec2-ssh-key']) {
                sh '''
                ssh -o StrictHostKeyChecking=no $EC2_USER@$EC2_HOST "
                    # Log in to Docker Hub on the EC2 instance
                    echo ${DOCKER_PASS} | sudo docker login -u ${DOCKER_USER} --password-stdin

                    # Pull latest image
                    sudo docker pull ${IMAGE_NAME}:latest

                    # Stop and cleanup existing container
                    sudo docker stop devops-app || true
                    sudo docker rm devops-app || true

                    # Run new container
                    # Note: Using sudo and ensuring port mapping matches your app
                    sudo docker run -d --name devops-app -p 5000:5000 ${IMAGE_NAME}:latest
                "
                '''
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
