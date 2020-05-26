pipeline{
    agent any
    environment{
        DOCKER_TAG= getDockerTag()
    }
    stages{
        stage ('Build Docker Image'){
            when {
              branch 'DEV'
            }
            steps{
                sh "docker build . -t elbarnaki/nodeapp:${DOCKER_TAG} "
            }
        }
        stage('DockerHub Push'){
           when {
              branch 'DEV'
            }
           steps{
                withCredentials([string(credentialsId: 'docker-hub', variable: 'dockhubpwd')]) {
                    sh "docker login -u elbarnaki -p ${dockhubpwd}"
                    sh "docker push elbarnaki/nodeapp:${DOCKER_TAG}"
                }
           }  
        }
        //
        
        stage('Deploy to DEV'){
            when {
              branch 'DEV'
            }
            steps{
                sh "chmod +x changeTag.sh"
                sh "./changeTag.sh ${DOCKER_TAG}"
                sshagent(['kubmaster']) {
                 sh " scp -o StrictHostKeyChecking=no services.yml node-app-pod.yml master@40.89.143.198:/home/master/"
                 script{
                        try{
                            sh "ssh master@40.89.143.198  kubectl apply -f ."
                        }catch(error){
                            sh "ssh master@40.89.143.198  kubectl create -f ."
                        }
                    }
                
                }

            }

        }
        stage ("Approve PROD Deployments") {
            when {
                branch 'master'
            }
            input{ message "Do you want to proceed for production deployment?" }
            // steps { 
                
            // }
        } 
        
        stage('Deploy to PROD'){
            when {
                // anyOf {
                // allOf {
                branch 'master'
                    // environment name: 'APPROVE_DEPLOY', value: '{PROD deployment ?=true}'
                // }
                // }
            }
            steps{
                sh "chmod +x changeTag.sh"
                sh "./changeTag.sh ${DOCKER_TAG}"
                sshagent(['kubmaster']) {
                 sh " scp -o StrictHostKeyChecking=no services.yml node-app-pod.yml master@40.89.143.198:/home/master/"
                 script{
                        try{
                            sh "ssh master@40.89.143.198  kubectl apply -f ."
                        }catch(error){
                            sh "ssh master@40.89.143.198  kubectl create -f ."
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