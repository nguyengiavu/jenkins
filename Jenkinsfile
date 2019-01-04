node{
  stage('SCM Checkout'){
    git 'https://github.com/nguyengiavu/jenkins'
  }
  stage('Compile-Package'){
    sh 'mvn package -DskipTests'
  }
}
