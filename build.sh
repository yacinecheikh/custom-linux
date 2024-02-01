# tarball setup scripts
rm apks/apk/files.tar.gz
tar cvzf apks/apk/files.tar.gz scripts

# build the apk
cd apks/apk
abuild checksum
# due to the /etc/abuild.conf config,
# abuild should directly build (and update the index) in the iso extracted files
abuild -r
cd ../..

# fix permissions
chmod u+x iso/extracted/apks/x86_64/custom-scripts-*


# generate the patch for the iso files
# the actual iso is built with iso/build.sh
# (and requires having a ubuntu-like install)
#cp output/custom-scripts.apk iso/iso-updates/apks/x86_64/
