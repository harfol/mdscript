#!/bin/bash

set -e

if [ -z "$1" ]; then
	exit 1
fi

src_file=deb/usr/local/mdscript/src/mdscript.sh
des_file=deb/usr/bin/mdspt
doc_path=deb/usr/share/doc/mdscript
version="$1"
log_file=../docs/changelog-${version}.txt

# build bin mdscript
echo -e "build mdscript.sh to bin/mdspt"
cp ../mdscript.sh $src_file
shc -r -f $src_file -o $des_file

# build log file 
echo -e "add changelog-${version}.txt"
if [ ! -e $log_file ]; then 
	echo $log_file not exit.
cat >>deb/DEBIAN/changelog <<-EOF
mdscript ($version) unstable; urgency=urgency

$(sed -e '1s/^/  * &/' -e '2,$s/^/    &/' $log_file)

 -- harfol <1148706823@qq.com>  $(date '+%a, %d %b %Y %H:%M:%S %z')
EOF

# change version
echo "set version ${version}"
sed -i "/^Version/s/:.*$/: $version/" deb/DEBIAN/control

echo "build mdscript_${version}-unstable_all.deb"
dpkg-deb -b deb/ mdscript_${version}-unstable_all.deb 
echo "success ..."


