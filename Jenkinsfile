node{
  stage('SCM Checkout'){  
    git 'https://github.com/nguyengiavu/jenkins'
  }
  stage('Complie-Package'){
    sh 'mvn package'
  }
}
