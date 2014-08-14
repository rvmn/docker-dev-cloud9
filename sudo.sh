if [ -z "$1" ]; then
  echo "Starting up visudo with this script as first parameter" 
  export EDITOR=$0 && visudo 
else
  echo "Changing sudoers" 
  echo "c9dev ALL=(root) NOPASSWD:/cloud9/*" >> $1
fi