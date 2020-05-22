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
        stage('Deploy to k8s'){
            steps{
                sh "chmod +x changeTag.sh"
                sh "./changeTag.sh ${DOCKER_TAG}"
                sshagent(['84a81d5c-b02d-4a6e-b0e8-8dd3c2c529d0']) {
                 sh " scp -o StrictHostKeyChecking=no services.yml node-app-pode.yml master@20.42.100.8:/home/master/"
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