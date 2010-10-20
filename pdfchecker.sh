#!/bin/sh
#
# Distributed under the terms of the GNU General Public License v3
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY. YOU USE AT YOUR OWN RISK. THE AUTHOR
# WILL NOT BE LIABLE FOR DATA LOSS, DAMAGES, LOSS OF PROFITS OR ANY
# OTHER  KIND OF LOSS WHILE USING OR MISUSING THIS SOFTWARE.
# See the GNU General Public License for more details.

if [ $# -eq 0 ]
then
  echo "\nChecks validity of PDF files recursively.\n\nSyntax: $(basename $0) folder\n"
  exit 1
else
  if [ -n "$1" ]
  then
    if [ -d "$1" ] 
    then
      cd "$1"
    else
      echo "Invalid folder: $1"
      exit 1
    fi
  fi
fi
which pdfinfo > /dev/null 2>&1
if [ $? -eq 1 ]
then
  echo "Installing xpdf-utils package...\n"
  sudo apt-get install xpdf-utils
fi
which pdfinfo > /dev/null 2>&1
if [ $? -eq 1 ]
then
  echo "xpdf-utils not installed!\n"
  exit 1
fi
for i in *
do
  if [ -d "$i" ] 
  then
    echo "Recursing into directory: $i"
    $0 "$i"
  fi
  if [ -f "$i" ]
  then
    echo "Checking: $i"
    /usr/bin/pdfinfo "$i" > /dev/null 2>&1
    if [ $? -ne 0 ]
    then
      echo "Invalid file: $i"
      mv "$i" "invalid-pdf-$i"
    fi
  fi
done
sync
echo "Done."
exit 0