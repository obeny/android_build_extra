# Generating dev-keys to sign android builds
All you need is an Android buildsystem (LineageOS is recommended)  
NOTE: For Lineage 21 and newer, different steps are required.
## PART 1: GENERATING KEYS  
  
1. Export your infos (replace examples with your infos)  
```
subject='/C=US/ST=California/L=Mountain View/O=Android/OU=Android/CN=Android/emailAddress=android@android.com'
```
C: Country shortform  
ST: Country longform  
L: Location (I used federal state)  
O, OU, CN: Your Name  
emailAddress: Your email  
**For example:**  
```
subject='/C=DE/ST=Germany/L=Berlin/O=Max Mustermann/OU=Max Mustermann/CN=Max Mustermann/emailAddress=max@mustermann.de'
```
  
2. Generate the keys
```
mkdir ~/.android-certs

for x in releasekey platform shared media networkstack testkey cyngn-priv-app bluetooth sdk_sandbox verifiedboot; do \
    ./development/tools/make_key ~/.android-certs/$x "$subject"; \
done
```
Note: 
* cyngn-priv-app is only needed if building 14.1 and older.  
* bluetooth, sdk_sandbox and verifiedboot are needed since Android 13.  
* DO NOT set a password for the keys. If you do, you won't be able to use them for building!  
  
## PART 2: SETTING UP PRIVATE VENDOR REPO
1. Create the vendor repo  
```
mkdir vendor/extra
```
For Lineage 21 and newer:
```
mkdir vendor/lineage-priv
```
2. Move your keys to the vendor repo
```
mv ~/.android-certs vendor/extra/keys
```
For Lineage 21 and newer:
```
mv ~/.android-certs vendor/lineage-priv/keys
```
3. Create a makefile and add the following line  
```
echo "PRODUCT_DEFAULT_DEV_CERTIFICATE := vendor/extra/keys/releasekey" > vendor/extra/product.mk
```
For Lineage 21 and newer:
```
echo "PRODUCT_DEFAULT_DEV_CERTIFICATE := vendor/lineage-priv/keys/releasekey" > vendor/lineage-priv/keys/keys.mk
```
A `BUILD.bazel` in `vendor/lineage-priv/keys` is also required for Lineage 21 and newer containing the following:
```
filegroup(
    name = "android_certificate_directory",
    srcs = glob([
        "*.pk8",
        "*.pem",
    ]),
    visibility = ["//visibility:public"],
)
```
You might also need [this commit](https://github.com/LineageOS/android_build_soong/commit/7d4531838a6a1bd0d4d47d48080d83786510ad98) if you're not building Lineage.  
  
Note: NEVER PUBLISH THIS VENDOR REPO, AS IT CONTAINS **YOUR OWN SIGNATURE KEYS**! IF YOU PUBLISH THEM, IT WILL HAVE THE SAME SECURITY RISKS AS BUILDING WITH TEST-KEYS!  
## PART 3: SIGNING YOUR BUILDS
* Most roms (for example LineageOS) automatically includes vendor/extra/product.mk (or vendor/lineage-priv/keys/keys.mk in Lineage 21 or newer). If your rom doesn't, add `-include vendor/extra/product.mk` (or `-include vendor/lineage-priv/keys/keys.mk`) to your device tree.  
* When everything worked fine, your builds should be signed with dev-keys.  

## References and Credits
* [LineageOS Wiki](https://wiki.lineageos.org/signing_builds)
* Linux4 for being a pro
* bengris32 for additional steps in Lineage 21