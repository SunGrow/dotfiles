cd $(dirname "$0")
ls -d $PWD/* | grep -v "$0"| grep $1 | sort -R | head -1
