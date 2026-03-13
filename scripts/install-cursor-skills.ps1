$SkillsPath = Join-Path $PSScriptRoot "..\skills"
$TargetBase = Join-Path $env:USERPROFILE ".cursor\skills"

if (-not (Test-Path $SkillsPath)) {
    Write-Error "Skills directory not found: $SkillsPath"
    exit 1
}

$SkillFiles = Get-ChildItem -Path $SkillsPath -Recurse -Filter "SKILL.md"

if ($SkillFiles.Count -eq 0) {
    Write-Host "No skills found in $SkillsPath"
    exit 0
}

foreach ($SkillFile in $SkillFiles) {
    $SkillDir = $SkillFile.Directory
    $SkillName = $SkillDir.Name
    $TargetPath = Join-Path $TargetBase $SkillName

    New-Item -ItemType Directory -Force -Path $TargetPath | Out-Null
    Copy-Item -Path (Join-Path $SkillDir.FullName '*') -Destination $TargetPath -Recurse -Force
    Write-Host "Installed '$SkillName' to $TargetPath"
}

Write-Host "`nInstalled $($SkillFiles.Count) skill(s)"
