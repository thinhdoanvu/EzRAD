#!/bin/bash
sudo add-apt-repository ppa:openjdk-r/ppa  
sudo apt-get update   
sudo apt-get install default-jdk
sudo update-alternatives --config java
2

wget http://sourceforge.net/projects/jfreechart/files/3.%20JCommon/1.0.16/jcommon-1.0.16.tar.gz

wget http://sourceforge.net/projects/jfreechart/files/1.%20JFreeChart/1.0.13/jfreechart-1.0.13.tar.gz

wget https://archive.apache.org/dist/xmlgraphics/batik/batik-1.7.zip

wget http://sourceforge.net/projects/itext/files/iText/iText5.0.2/iText-5.0.2.jar


#wget http://sourceforge.net/projects/jython/files/jython/2.5.1/jython_installer-2.5.1.jar/download
#mv download jython_installer-2.5.1.jar
wget "http://search.maven.org/remotecontent?filepath=org/python/jython-standalone/2.7-b2/jython-standalone-2.7-b2.jar" -O jython.jar

git clone git://github.com/biopython/biopython.git
cd biopython
git checkout tags/biopython-162
cd ..

rm -rf tmp
mkdir tmp
mv *tar.gz *zip *jar biopython tmp
