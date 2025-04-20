param (
    [string]$Directory = ".",
    [string]$OldWord,
    [string]$NewWord
)

# 1. Replace text inside files
Get-ChildItem -Path $Directory -Recurse -File | ForEach-Object {
    $content = Get-Content $_.FullName
    $updated = $content -replace [regex]::Escape($OldWord), $NewWord
    if ($content -ne $updated) {
        Set-Content $_.FullName $updated
        Write-Host "Updated content: $($_.FullName)"
    }
}

# 2. Rename files
Get-ChildItem -Path $Directory -Recurse -File | Sort-Object FullName -Descending | ForEach-Object {
    if ($_.Name -like "*$OldWord*") {
        $newName = $_.Name -replace [regex]::Escape($OldWord), $NewWord
        $newPath = Join-Path $_.DirectoryName $newName
        Rename-Item -Path $_.FullName -NewName $newName
        Write-Host "Renamed file: $($_.FullName) -> $newPath"
    }
}

# 3. Rename directories (deepest first)
Get-ChildItem -Path $Directory -Recurse -Directory | Sort-Object Full


# .\r2.ps1 -Directory "path here" -OldWord "old" -NewWord "new"
