param(
    [string]$Wsl,
    [string[]]$Skills
)

$SkillsPath = Join-Path $PSScriptRoot "..\skills"

if (-not (Test-Path $SkillsPath)) {
    Write-Error "Skills directory not found: $SkillsPath"
    exit 1
}

if ($PSBoundParameters.ContainsKey('Wsl')) {
    $Distro = $Wsl
    if (-not $Distro) {
        $DefaultLine = (wsl --list 2>$null) | Where-Object { $_ -match '\(Default\)' } | Select-Object -First 1
        if ($DefaultLine -match '^\s*(\S+)') {
            $Distro = $Matches[1]
        }
    }
    if (-not $Distro) {
        Write-Error "Could not determine WSL distro. Pass one explicitly: -Wsl Ubuntu"
        exit 1
    }
    $WslHome = (wsl -d $Distro -- bash -c 'echo $HOME') | Select-Object -First 1
    if (-not $WslHome) {
        Write-Error "Could not determine home directory for WSL distro '$Distro'"
        exit 1
    }
    $WslHome = $WslHome.Trim()
    $UnixPath = $WslHome -replace '^/', ''
    $TargetBase = "\\wsl$\$Distro\$UnixPath\.cursor\skills"
    Write-Host "Targeting WSL distro '$Distro': $TargetBase"
} else {
    $TargetBase = Join-Path $env:USERPROFILE ".cursor\skills"
}

$AllSkillFiles = Get-ChildItem -Path $SkillsPath -Recurse -Filter "SKILL.md"

if ($Skills.Count -gt 0) {
    $SkillFiles = $AllSkillFiles | Where-Object { $Skills -contains $_.Directory.Name }
    $Missing = $Skills | Where-Object { $n = $_; -not ($AllSkillFiles | Where-Object { $_.Directory.Name -eq $n }) }
    foreach ($m in $Missing) {
        Write-Warning "Skill not found: $m"
    }
} else {
    $SkillFiles = $AllSkillFiles
}

if ($SkillFiles.Count -eq 0) {
    Write-Host "No skills to install"
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
