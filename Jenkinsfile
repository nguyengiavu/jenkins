node{
  stage('SCM Checkout'){  
    git 'https://github.com/nguyengiavu/jenkins'
  }
  stage('Complie-Package'){
    def mvnHome = tool name: 'maven-1', type: 'maven'
    sh "${mvnHome/bin/mvn package}"
  }
}
