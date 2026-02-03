param(
    [Parameter(Mandatory=$true)]
    [string]$SkillName
)

$SourcePath = Join-Path $PSScriptRoot "..\skills\$SkillName"
$TargetPath = Join-Path $env:USERPROFILE ".cursor\skills\$SkillName"

if (-not (Test-Path $SourcePath)) {
    Write-Error "Skill not found: $SourcePath"
    exit 1
}

if (Test-Path $TargetPath) {
    Remove-Item -Path $TargetPath -Recurse -Force
}

Copy-Item -Path $SourcePath -Destination $TargetPath -Recurse
Write-Host "Installed '$SkillName' to $TargetPath"
