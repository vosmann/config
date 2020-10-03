CHOICE=$1
echo "Want to switch to Java $CHOICE"

JVM_DIR="/usr/lib/jvm"

JAVA_8_DIR="java-8-openjdk-amd64"
JAVA_11_MANUAL_DIR="openjdk-11.0.2-manual-install/jdk-11.0.2"
JAVA_12_MANUAL_DIR="openjdk-12.0.2-manual-install/jdk-12.0.2"
JAVA_13_MANUAL_DIR="openjdk-13.0.2-manual-install/jdk-13.0.2"
JAVA_14_MANUAL_DIR="openjdk-14-ga-2020-03-27-manual-install/jdk-14"

if [ "$CHOICE" ==  8  ];then
    JAVA_SELECTION_DIR=$JAVA_8_DIR
elif [ "$CHOICE" == 11 ];then
    JAVA_SELECTION_DIR=$JAVA_11_MANUAL_DIR
elif [ "$CHOICE" == 12 ];then
    JAVA_SELECTION_DIR=$JAVA_12_MANUAL_DIR
elif [ "$CHOICE" == 13 ];then
    JAVA_SELECTION_DIR=$JAVA_13_MANUAL_DIR
elif [ "$CHOICE" == 14 ];then
    JAVA_SELECTION_DIR=$JAVA_14_MANUAL_DIR
else
    echo "$CHOICE not supported. Not changing anything. Exiting."
    exit 1
fi

echo 
echo "Java before switch"
echo 
echo JAVA_HOME=$JAVA_HOME
java -version


JAVA_SELECTION_FULL="$JVM_DIR/$JAVA_SELECTION_DIR/bin/java"
LINK_FILE="/etc/alternatives/java"
sudo rm $LINK_FILE
sudo ln -s $JAVA_SELECTION_FULL $LINK_FILE

export JAVA_HOME="$JVM_DIR/$JAVA_SELECTION_DIR"
#echo JAVA_HOME=$JAVA_HOME | sudo tee -a /etc/environment

echo export JAVA_HOME=$JAVA_HOME | sudo tee /etc/profile.d/jdk.sh
echo export J2SDKDIR=$JAVA_HOME | sudo tee -a /etc/profile.d/jdk.sh
echo export PATH=$PATH:$JAVA_HOME/bin | sudo tee -a /etc/profile.d/jdk.sh

echo 
echo "Java after switch"
echo 
echo JAVA_HOME=$JAVA_HOME
java -version
echo 
echo "Please log in to pick up JAVA_HOME from /etc/environment."
gnome-session-quit
