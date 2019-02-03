pipeline {
    agent any
environment {
       TERRAFORM_CMD = 'docker run --network host  -w /app -v /home/ec2-user/.aws:/root/.aws  -v `pwd`:/app hashicorp/terraform:light',
       CLEAN_CMD = 'docker run -id -w `pwd` -v `pwd`:`pwd` alpine'
    }
    stages {
        
        stage('clean pwd and initial tests') {
            steps {   
                sh "ls -lat"
                sh "pwd"
                sh "docker ps"
   
            }
        }
        stage('checkout repo') {
            steps {
              git url: 'https://github.com/vynu/terraform-vpc.git'
            }
        }
        stage('pull latest light terraform image') {
            steps {
                sh  """
                    docker pull hashicorp/terraform:light
                    """
            }
        }
        stage('init') {
            steps {
                sh  """
                    ${TERRAFORM_CMD} init -backend=true -input=false
                    """
            }
        }
        stage('plan') {
            steps {
                sh  """
                    ${TERRAFORM_CMD} plan -out=tfplan -input=false 
                    """
                script {
                  timeout(time: 10, unit: 'MINUTES') {
                    input(id: "Deploy Gate", message: "Deploy ${params.project_name}?", ok: 'Deploy')
                  }
                }
            }
        }
        stage('apply') {
            steps {
                sh  """
                    ${TERRAFORM_CMD} apply -lock=false -input=false tfplan
                    """
                
                script {
                  timeout(time: 10, unit: 'MINUTES') {
                    input(id: "destroy Gate", message: "Deploy ${params.project_name}?", ok: 'destroy')
                         }
                      }
              }
        }
        
        stage('destroy') {
            steps {
                sh  """
                    ${TERRAFORM_CMD} destroy -input=false 
                    """
                sh  """
                    ${CLEAN_CMD} /bin/sh -c "rm -rf .terra*" 
                    """
            }
        }
        
    }
    post {
    aborted {
                sh  """
                    ${CLEAN_CMD} /bin/sh -c "rm -rf .terra*" 
                    """
    }
  }
}
