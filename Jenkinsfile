pipeline{
    agent any
    environment{
        DOCKER_TAG= getDockerTag()
    }
    stages{
        stage ('Build Docker Image'){
            steps{
                sh "docker build . -t elbarnaki/nodeapp:${DOCKER_TAG} "
            }
        }
        stage('DockerHub Push'){
           steps{
                withCredentials([string(credentialsId: 'docker-hub', variable: 'dockhubpwd')]) {
                    sh "docker login -u elbarnaki -p ${dockhubpwd}"
                    sh "docker push elbarnaki/nodeapp:${DOCKER_TAG}"
                }
           }  
        } 
        stage('Deploy to Kubernetes'){
            steps{
                sh "chmod +x changeTag.sh"
                sh "./changeTag.sh ${DOCKER_TAG}"
                sshagent(['kubmaster']) {
                 sh " scp -o StrictHostKeyChecking=no services.yml node-app-pode.yml master@40.66.33.124:/home/master/"
                 script{
                        try{
                            sh "ssh master@40.66.33.124 kubectl apply -f ."
                        }catch(error){
                            sh "ssh master@40.66.33.124 kubectl create -f ."
                        }
                    }
                
                }

            }

        }
             
    }
}

def getDockerTag(){
    def tag  = sh script: 'git rev-parse HEAD', returnStdout: true
    return tag
}