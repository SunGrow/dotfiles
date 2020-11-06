cd $(dirname "$0")
ls -d $PWD/* | grep -v "$0"| sort -R | head -1
