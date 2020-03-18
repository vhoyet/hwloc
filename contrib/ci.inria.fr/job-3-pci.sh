echo "############################"
echo "Running on:"
uname -a
echo "Tarball: $1"
echo "############################"

set -e
set -x

# environment variables
test -f $HOME/.ciprofile && . $HOME/.ciprofile

# extract the tarball
tarball="$1"
basename=$(basename $tarball .tar.gz)
test -d $basename && chmod -R u+rwX $basename && rm -rf $basename
tar xfz $tarball
rm $tarball
cd $basename

#check 32 bits pci domain
./configure --enable-32bits-pci-domain
make check

exit 0
