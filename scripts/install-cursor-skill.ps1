param(
    [Parameter(Mandatory=$true)]
    [string]$SkillName
)

$SkillsPath = Join-Path $PSScriptRoot "..\skills"
$TargetPath = Join-Path $env:USERPROFILE ".cursor\skills\$SkillName"

$SkillFile = Get-ChildItem -Path $SkillsPath -Recurse -Filter "SKILL.md" |
    Where-Object { $_.Directory.Name -eq $SkillName } |
    Select-Object -First 1

if (-not $SkillFile) {
    Write-Error "Skill not found: $SkillName"
    exit 1
}

$SourcePath = $SkillFile.Directory.FullName

New-Item -ItemType Directory -Force -Path $TargetPath | Out-Null
Copy-Item -Path (Join-Path $SourcePath '*') -Destination $TargetPath -Recurse -Force
Write-Host "Installed '$SkillName' to $TargetPath"
