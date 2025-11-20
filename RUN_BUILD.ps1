# PowerShell script to run FFmpeg Kit Android build in Docker

Write-Host "================================" -ForegroundColor Green
Write-Host "FFmpeg Kit Android Build" -ForegroundColor Green
Write-Host "================================" -ForegroundColor Green
Write-Host ""

# Check if Docker is running
Write-Host "Checking Docker..." -ForegroundColor Yellow
docker info > $null 2>&1
if ($LASTEXITCODE -ne 0) {
    Write-Host "ERROR: Docker is not running!" -ForegroundColor Red
    Write-Host "Please start Docker Desktop and try again." -ForegroundColor Red
    exit 1
}
Write-Host "Docker is running!" -ForegroundColor Green
Write-Host ""

# Check if image exists
Write-Host "Checking if ffmpeg-kit-android image exists..." -ForegroundColor Yellow
docker images ffmpeg-kit-android:latest --format "{{.Repository}}" | Select-String "ffmpeg-kit-android" > $null
if ($LASTEXITCODE -ne 0) {
    Write-Host "ERROR: Docker image not found!" -ForegroundColor Red
    Write-Host "Please build the image first with:" -ForegroundColor Yellow
    Write-Host "  docker build -f Dockerfile.android -t ffmpeg-kit-android:latest ." -ForegroundColor Cyan
    exit 1
}
Write-Host "Image found!" -ForegroundColor Green
Write-Host ""

# Run the build
Write-Host "Starting FFmpeg Kit build..." -ForegroundColor Yellow
Write-Host "This will take 20-60 minutes depending on your CPU." -ForegroundColor Yellow
Write-Host ""

$sourcePath = "C:\Users\NewHive\Documents\Coding\www\Srapp\ffmpeg-kit"

docker run --rm `
    -v "${sourcePath}:/ffmpeg-kit" `
    -w /ffmpeg-kit `
    ffmpeg-kit-android:latest `
    /bin/bash -c "./build-android-https.sh"

if ($LASTEXITCODE -eq 0) {
    Write-Host ""
    Write-Host "================================" -ForegroundColor Green
    Write-Host "Build completed successfully!" -ForegroundColor Green
    Write-Host "================================" -ForegroundColor Green
    Write-Host ""
    Write-Host "AAR files location:" -ForegroundColor Yellow
    Write-Host "  $sourcePath\prebuilt\android-aar\" -ForegroundColor Cyan
    Write-Host ""

    # List AAR files
    $aarPath = Join-Path $sourcePath "prebuilt\android-aar"
    if (Test-Path $aarPath) {
        Get-ChildItem -Path $aarPath -Filter "*.aar" | ForEach-Object {
            Write-Host "  - $($_.Name) ($([math]::Round($_.Length / 1MB, 2)) MB)" -ForegroundColor Cyan
        }
    }
} else {
    Write-Host ""
    Write-Host "================================" -ForegroundColor Red
    Write-Host "Build failed!" -ForegroundColor Red
    Write-Host "================================" -ForegroundColor Red
    Write-Host "Check the error messages above." -ForegroundColor Yellow
    exit 1
}
