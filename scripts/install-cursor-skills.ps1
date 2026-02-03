$SkillsPath = Join-Path $PSScriptRoot "..\skills"
$TargetBase = Join-Path $env:USERPROFILE ".cursor\skills"

if (-not (Test-Path $SkillsPath)) {
    Write-Error "Skills directory not found: $SkillsPath"
    exit 1
}

$Skills = Get-ChildItem -Path $SkillsPath -Directory

if ($Skills.Count -eq 0) {
    Write-Host "No skills found in $SkillsPath"
    exit 0
}

foreach ($Skill in $Skills) {
    $TargetPath = Join-Path $TargetBase $Skill.Name
    
    if (Test-Path $TargetPath) {
        Remove-Item -Path $TargetPath -Recurse -Force
    }
    
    Copy-Item -Path $Skill.FullName -Destination $TargetPath -Recurse
    Write-Host "Installed '$($Skill.Name)' to $TargetPath"
}

Write-Host "`nInstalled $($Skills.Count) skill(s)"
