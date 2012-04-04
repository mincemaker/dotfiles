#!/bin/sh

if [ $# -ne 1 ]; then
    echo "Usage $0 <submodule name>";
    exit 1;
fi

name=$1;

echo -n "remove submodule ($name) ok? [y/n]"
read ANSWER

if [ "${ANSWER}" = "y" ];
then
    git rm --cached `git config --file .gitmodules --get submodule.$name.path`
    git config --file .gitmodules --remove-section submodule.$name
fi

