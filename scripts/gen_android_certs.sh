subject='/C=PL/ST=Poland/L=Wroclaw/O=Marcin Benka/OU=Marcin Benka/CN=Marcin Benka/emailAddress=marcin.benka@gmail.com'

for x in bluetooth cyngn-app media networkstack nfc platform releasekey sdk_sandbox shared testcert testkey verity
do
    ~/.android-certs/make_key ~/.android-certs/$x "$subject";
done
