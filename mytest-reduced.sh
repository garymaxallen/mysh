starttime=$(date +%s)
xcrun simctl uninstall booted com.gg.mysh
rm -rf build
mkdir -p build/Release-iphonesimulator
cp myresource/lib* build/Release-iphonesimulator/
xcodebuild build CODE_SIGN_IDENTITY="" CODE_SIGNING_REQUIRED=NO -arch x86_64 -sdk iphonesimulator16.0 -target mysh
cp myresource/repositories.txt build/Release-iphonesimulator/mysh.app/
cp myresource/hterm_all.js build/Release-iphonesimulator/mysh.app/
cp myresource/root.tar.gz build/Release-iphonesimulator/mysh.app/
cp myresource/term.* build/Release-iphonesimulator/mysh.app/
xcrun simctl install "iPhone 12 Pro Max" build/Release-iphonesimulator/mysh.app
xcrun simctl launch booted com.gg.mysh
endtime=$(date +%s)
echo run time: $(expr $endtime - $starttime)s
