function setJavaVersion(){
  for i in `update-alternatives --list java`
  do
    escapedi=$(echo -n $i | sed 's/bin\/java/bin/g' | sed 's/\//\\\//g')
    PATH=$(echo -n $PATH | sed "s/$escapedi://g");
  done

  export PATH=$1/bin:$PATH
  export JAVA_HOME=$1
}

alias setZuluJdk17='setJavaVersion "/usr/lib/jvm/zulu17-ca-amd64"'
alias setZuluJdk13='setJavaVersion "/usr/lib/jvm/zulu13-ca-amd64"'
alias setZuluJdk11='setJavaVersion "/usr/lib/jvm/zulu11-ca-amd64"'
alias setZuluJdk8='setJavaVersion "/usr/lib/jvm/zulu8-ca-amd64"'
alias setZuluJdk20='setJavaVersion "/usr/lib/jvm/zulu20-ca-amd64"'
setZuluJdk11
