# Quick Start: Build FFmpeg Kit Android

Ο χρήστης έχει ήδη build-άρει το Docker image επιτυχώς! 🎉

## Τώρα, για να κάνεις build τα AAR files:

### Option 1: PowerShell (RECOMMENDED)

Άνοιξε **PowerShell** (όχι Git Bash) και τρέξε:

```powershell
cd "C:\Users\NewHive\Documents\Coding\www\Srapp\ffmpeg-kit"
.\RUN_BUILD.ps1
```

Αυτό θα:
- Ελέγξει αν το Docker τρέχει
- Ελέγξει αν το image υπάρχει
- Τρέξει το build (20-60 λεπτά)
- Δείξει που είναι τα AAR files

---

### Option 2: Manual Docker Command (PowerShell)

```powershell
cd "C:\Users\NewHive\Documents\Coding\www\Srapp\ffmpeg-kit"

docker run --rm `
    -v "C:\Users\NewHive\Documents\Coding\www\Srapp\ffmpeg-kit:/ffmpeg-kit" `
    -w /ffmpeg-kit `
    ffmpeg-kit-android:latest `
    /bin/bash -c "./build-android-https.sh"
```

**Σημείωση**: Το `` ` `` (backtick) είναι για line continuation στο PowerShell.

---

### Option 3: Git Bash (με fix)

Αν θέλεις να χρησιμοποιήσεις Git Bash, πρόσθεσε `MSYS_NO_PATHCONV=1`:

```bash
cd "/c/Users/NewHive/Documents/Coding/www/Srapp/ffmpeg-kit"

MSYS_NO_PATHCONV=1 docker run --rm \
    -v "/c/Users/NewHive/Documents/Coding/www/Srapp/ffmpeg-kit:/ffmpeg-kit" \
    -w /ffmpeg-kit \
    ffmpeg-kit-android:latest \
    /bin/bash -c "./build-android-https.sh"
```

---

## Μετά το Build

Τα AAR files θα είναι εδώ:
```
C:\Users\NewHive\Documents\Coding\www\Srapp\ffmpeg-kit\prebuilt\android-aar\
```

Θα βρεις κάτι σαν:
- `ffmpeg-kit-https-6.0-2.aar`

---

## Τι να κάνεις μετά

1. **Verify το AAR**:
   ```powershell
   # PowerShell
   Expand-Archive -Path "prebuilt\android-aar\ffmpeg-kit-*.aar" -DestinationPath "temp-aar" -Force
   Get-ChildItem -Path "temp-aar" -Recurse
   ```

2. **Upload στο GitHub releases**

3. **Update build.gradle** στο forked repo

---

## Troubleshooting

### "Docker is not running"
→ Άνοιξε Docker Desktop και περίμενε να ξεκινήσει

### "Image not found"
→ Rebuild το image:
```powershell
docker build -f Dockerfile.android -t ffmpeg-kit-android:latest .
```

### "Permission denied" on build-android-https.sh
→ Το script πρέπει να είναι executable. Fix:
```powershell
docker run --rm -v "C:\Users\NewHive\Documents\Coding\www\Srapp\ffmpeg-kit:/ffmpeg-kit" -w /ffmpeg-kit ffmpeg-kit-android:latest /bin/bash -c "chmod +x build-android-https.sh && ./build-android-https.sh"
```
