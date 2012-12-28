# vim: set et ai cin sw=2 ts=2 tw=0:
#Maintainer: JRD <jrd@enialis.net>
# Use fake-uname to match the kernel version you want to compile, or use the KVER variable
# Build deps: git

cd "$(dirname "$0")"
[ -z "$KVER" ] && KVER=$(uname -r)
TKVER=$(echo $KVER|sed 's/-.*//') # remove the -smp
echo "KVER=$KVER"
echo "TKVER=$TKVER"
echo "Proceed?"
read junk
aufsrepo=git://aufs.git.sourceforge.net/gitroot/aufs/aufs3-standalone.git
fwrepo=git://git.kernel.org/pub/scm/linux/kernel/git/dwmw2/linux-firmware.git
AUFSDIR=aufs-${TKVER}_$(date +%Y-%m-%d)
echo "** Aufs **"
git clone -n $aufsrepo $AUFSDIR || exit 1
(
  cd $AUFSDIR
  if ! git checkout aufs$(echo $TKVER|cut -d. -f1-2); then
    echo "No branch exist in aufs for your kernel version" >&2
    exit 1
  fi
  rm -rf .git
)
FWDIR=kernel-firmwares-${TKVER}_$(date +%Y-%m-%d)
echo "** Kernel firmwares **"
git clone $fwrepo $FWDIR || exit 1
(
  cd $FWDIR
  rm -rf .git
)
echo "** Creating $AUFSDIR.tar.xz **"
tar caf $AUFSDIR.tar.xz $AUFSDIR
echo "** Creating $FWDIR.tar.xz **"
tar caf $FWDIR.tar.xz $FWDIR
echo "** Cleaning **"
rm -rf $AUFSDIR $FWDIR
