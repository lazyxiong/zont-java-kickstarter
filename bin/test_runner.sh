#!/bin/sh
#
# usage: $0 <executeClass> [<executeArgs>]
#
# Alexandre Berman
suiteDir=`cd $(dirname $0)/..;pwd`

# -- check our arguments
if [ $# -lt 1 ]; then
   echo "-- ERROR: must provide at least 1 argument - path to java test file (.java) !"
   exit 1
else
   # -- this is our test
   executeClass=$1
fi
# -- test if test exists
if [ ! -r $executeClass ]; then
   echo "-- ERROR: cannot find your test [ $executeClass ] !"
   exit 1
fi
# -- arguments to a test ?
if [ $# == 2 ]; then
   # -- we got argument to a test
   executeArgs=$2
fi
# -- setup
className=`echo $executeClass | sed -e 's|^.*/||g' -e 's|\.java||g'`
testDir=`cd $(dirname $executeClass);pwd`
if [ "x$JAVA_HOME" == "x" ]; then
   javaBinDir=`cd $(dirname $(which java));pwd`
else
   javaBinDir="${JAVA_HOME}/bin"
fi

echo ""
echo "-------------------------------"
echo "executeClass: $executeClass"
echo "className   : $className"
echo "testDir     : $testDir "
echo "javaBinDir  : $javaBinDir"
echo "-------------------------------"
echo ""

#export j_opts=""
#QA_LIB="$suiteDir/lib"
#qaCP=`find $QA_LIB -name \*.jar -printf %p:`
#export myCP="${qaCP}:."
export myCP="."
# *******************************************
echo "-- cleaning..."
find $suiteDir/tests -name "*.class" | xargs rm -f
echo "-- compiling: $executeClass"
#cd $testDir && ${javaBinDir}/javac -classpath $myCP ${executeClass}
find $suiteDir/tests -name "*.java" | xargs ${javaBinDir}/javac -classpath $myCP
if [ $? -ne 0 ]; then
   echo "-- ERROR: compilation failed !"
   exit 1
fi
echo "-- executing: $className"
echo ""
echo "   [cd $testDir && ${javaBinDir}/java -classpath $myCP $className]"
echo ""
cd $testDir && ${javaBinDir}/java -classpath $myCP $className
exit $?
