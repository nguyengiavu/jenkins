node{
  stage('SCM Checkout'){
    git 'https://github.com/nguyengiavu/hub'
  }
  stage('Compile-Package'){
    sh 'mvn package'
  }
}
