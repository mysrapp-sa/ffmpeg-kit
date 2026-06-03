# FFmpeg Kit Maven Repository

This directory contains a Maven repository hosting the FFmpeg Kit HTTPS AAR files for Android.

## Usage

Add this repository to your `build.gradle`:

```gradle
repositories {
    maven {
        url 'https://raw.githubusercontent.com/MySRApp-SA/ffmpeg-kit/main/maven'
    }
}

dependencies {
    implementation 'com.arthenica:ffmpeg-kit-https:6.0.2'
}
```

## Structure

```
maven/
  com/
    arthenica/
      ffmpeg-kit-https/
        maven-metadata.xml
        6.0.2/
          ffmpeg-kit-https-6.0.2.aar
          ffmpeg-kit-https-6.0.2.pom
          ffmpeg-kit-https-6.0.2.aar.md5
          ffmpeg-kit-https-6.0.2.aar.sha1
          ffmpeg-kit-https-6.0.2.pom.md5
          ffmpeg-kit-https-6.0.2.pom.sha1
```

## Package Information

- **Group ID**: `com.arthenica`
- **Artifact ID**: `ffmpeg-kit-https`
- **Version**: `6.0.2`
- **Packaging**: AAR
- **License**: LGPL 3.0

## Included Libraries

- FFmpeg 6.0
- GnuTLS (for HTTPS support)
- GMP (for cryptography)
- Nettle (for cryptography)

## Architectures

- arm64-v8a (64-bit ARM)
- armeabi-v7a (32-bit ARM)
- armeabi-v7a-neon (32-bit ARM with NEON)

## License

LGPL 3.0 - See [LICENSES.md](../../LICENSES.md) for full details.
