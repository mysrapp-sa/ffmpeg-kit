# FFmpeg Kit Android Build Instructions

## Τι θα κάνουμε
Θα κάνουμε build το FFmpeg Kit για Android με το "https" package (gmp + gnutls) χρησιμοποιώντας Docker.

## Προαπαιτούμενα
- Docker Desktop installed και running
- ~5-10GB ελεύθερο χώρο
- 30-90 λεπτά χρόνος (ανάλογα με το μηχάνημα)

---

## Βήμα 1: Έλεγχος Docker

Βεβαιώσου ότι το Docker τρέχει:

```bash
docker info
```

Αν δεν τρέχει, άνοιξε το Docker Desktop και περίμενε να ξεκινήσει.

---

## Βήμα 2: Build το Docker Image

Το Docker image περιέχει Android SDK, NDK και όλα τα build tools:

```bash
cd "C:\Users\NewHive\Documents\Coding\www\Srapp\ffmpeg-kit"

docker build -f Dockerfile.android -t ffmpeg-kit-android:latest .
```

**Χρόνος**: ~10-20 λεπτά
**Μέγεθος**: ~4-5GB

Θα δεις output σαν:
```
Step 1/7 : FROM ubuntu:22.04
Step 2/7 : RUN apt-get update && apt-get install -y ...
Step 3/7 : ENV JAVA_HOME=...
...
Successfully built xxxxx
Successfully tagged ffmpeg-kit-android:latest
```

---

## Βήμα 3: Run το Container και Build το FFmpeg Kit

Μόλις τελειώσει το image, τρέξε:

```bash
docker run --rm -v "C:\Users\NewHive\Documents\Coding\www\Srapp\ffmpeg-kit:/ffmpeg-kit" -w /ffmpeg-kit ffmpeg-kit-android:latest /bin/bash -c "./build-android-https.sh"
```

**Τι κάνει**:
- `--rm`: Διαγράφει το container μετά το build
- `-v`: Mount το local directory μέσα στο container
- `-w`: Set working directory
- Τρέχει το build script

**Χρόνος**: ~20-60 λεπτά (ανάλογα με CPU)

Θα δεις output σαν:
```
Building FFmpeg Kit HTTPS Package for Android
================================
Android SDK Root: /opt/android-sdk
Android NDK Root: /opt/android-sdk/ndk/26.1.10909125

Starting build process...
Package: https (gmp + gnutls)
No GPL libraries included

[... πολύ build output ...]

Build completed!
================================
```

---

## Βήμα 4: Βρες τα AAR Files

Μετά το build, τα AAR files θα βρίσκονται σε:

```bash
C:\Users\NewHive\Documents\Coding\www\Srapp\ffmpeg-kit\prebuilt\android-aar\
```

Ψάξε για:
- `ffmpeg-kit-https-6.0-2.aar` (ή παρόμοιο όνομα)

Τσέκαρε με:
```bash
ls -lh prebuilt/android-aar/
```

---

## Troubleshooting

### Πρόβλημα: Docker build κολλάει
**Λύση**: Δώσε περισσότερο RAM στο Docker
- Docker Desktop → Settings → Resources
- Increase RAM to 8GB+
- Increase CPUs to 4+

### Πρόβλημα: "ANDROID_NDK_ROOT not defined"
**Λύση**: Το Docker image δεν build-άρισε σωστά. Ξανά-τρέξε το Step 2.

### Πρόβλημα: Build fails με compilation errors
**Λύση**: Check τα logs. Συνήθως είναι:
- Έλλειψη χώρου
- Network issues κατά το download dependencies
- Ξανά-προσπάθησε

---

## Alternative: WSL Build (Αντί για Docker)

Αν προτιμάς WSL:

1. **Άνοιξε WSL Ubuntu**:
   ```bash
   wsl
   ```

2. **Install dependencies**:
   ```bash
   sudo apt-get update
   sudo apt-get install -y build-essential git curl wget unzip python3 openjdk-17-jdk autoconf automake libtool pkg-config cmake ninja-build nasm yasm
   ```

3. **Download Android SDK/NDK**:
   ```bash
   # Download Android Command Line Tools
   mkdir -p ~/android-sdk/cmdline-tools
   cd ~/android-sdk/cmdline-tools
   wget https://dl.google.com/android/repository/commandlinetools-linux-11076708_latest.zip
   unzip commandlinetools-linux-11076708_latest.zip
   mv cmdline-tools latest

   # Set environment variables
   export ANDROID_SDK_ROOT=~/android-sdk
   export PATH=$ANDROID_SDK_ROOT/cmdline-tools/latest/bin:$PATH

   # Accept licenses
   yes | sdkmanager --licenses

   # Install NDK
   sdkmanager "ndk;26.1.10909125" "platform-tools" "platforms;android-34" "build-tools;34.0.0"

   export ANDROID_NDK_ROOT=$ANDROID_SDK_ROOT/ndk/26.1.10909125
   ```

4. **Clone repo και build**:
   ```bash
   cd /mnt/c/Users/NewHive/Documents/Coding/www/Srapp/ffmpeg-kit
   ./build-android-https.sh
   ```

---

## Τι να κάνεις μετά το Build

1. **Verify AAR**:
   ```bash
   unzip -l prebuilt/android-aar/ffmpeg-kit-https-*.aar
   ```

   Θα πρέπει να δεις:
   - `AndroidManifest.xml`
   - `classes.jar`
   - `jni/` folder με `.so` files για κάθε architecture

2. **Upload στο GitHub**:
   - Πήγαινε στο https://github.com/mysrapp-ae/ffmpeg-kit/releases
   - Create new release (v6.0-android)
   - Upload τα AAR files

3. **Update build.gradle**:
   - Τροποποίησε το forked `ffmpeg-kit-react-native/android/build.gradle`
   - Άλλαξε το dependency να δείχνει στο GitHub release URL

---

## Επόμενα Βήματα

Αφού έχεις τα AAR files:
1. Upload στο GitHub releases
2. Update το `ffmpeg-kit-react-native/android/build.gradle`
3. Test με `eas build --platform android`
4. Profit! 🎉

---

## Notes

- Το build κάνει compile για 4 architectures: arm64-v8a, armeabi-v7a, x86, x86_64
- Το "https" package περιλαμβάνει: FFmpeg + gmp + gnutls
- LGPL 3.0 licensed - νόμιμο για commercial use
- Μέγεθος AAR: ~20-40MB (ανάλογα με architectures)
