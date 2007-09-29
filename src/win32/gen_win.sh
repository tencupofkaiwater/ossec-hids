#!/bin/sh

# Generate windows packages
DIR=`dirname $0`;
FILE="win-files.txt"
CAT=`cat ${FILE}`
WINPKG="win-pkg"

# Generating configs
./unix2dos.pl ossec.conf > ossec-win.conf
./unix2dos.pl help.txt > help_win.txt
./unix2dos.pl ../../etc/internal_options.conf > internal_options-win.conf
./unix2dos.pl ../../LICENSE > LICENSE.txt

# Going to the source dir
cd ${DIR}
CAT=`cat ${FILE}`
cd ..
mkdir ${WINPKG}
mkdir ${WINPKG}/setup

source=""
dest=""
for i in ${CAT}; do
    echo $i;
    if [ "X${source}" = "X" ]; then
        source=$i;
    elif [ "X${dest}" = "X" ]; then
        dest=$i;
        echo "cp -pr ${source} ${WINPKG}/${dest}"
        cp -pr ${source} "${WINPKG}/${dest}"
        if [ ! $? = 0 ]; then
            echo "Error copying ${source} to ${WINPKG}/${dest}"
            exit 1;
        fi    
        source=""
        dest=""
    fi            
done    

# Final cleanup
rm ${WINPKG}/os_crypto/md5/main.c
rm ${WINPKG}/os_crypto/blowfish/main.c
rm ${WINPKG}/os_crypto/sha1/main.c
rm ${WINPKG}/os_crypto/md5_sha1/main.c
rm ${WINPKG}/shared/rules_op.c
