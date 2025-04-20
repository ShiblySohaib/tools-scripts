# Prompt for inputs
$Directory = Read-Host "Enter the target directory (default is current directory)"
if (-not $Directory) { $Directory = "." }  # Use current directory if no input

$OldWord = Read-Host "Enter the word to be replaced"
if (-not $OldWord) {
    Write-Host "Old word cannot be empty. Exiting script." -ForegroundColor Red
    exit
}

$NewWord = Read-Host "Enter the replacement word"
if (-not $NewWord) {
    Write-Host "New word cannot be empty. Exiting script." -ForegroundColor Red
    exit
}

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
Get-ChildItem -Path $Directory -Recurse -Directory | Sort-Object FullName -Descending | ForEach-Object {
    if ($_.Name -like "*$OldWord*") {
        $newName = $_.Name -replace [regex]::Escape($OldWord), $NewWord
        $newPath = Join-Path $_.Parent.FullName $newName
        Rename-Item -Path $_.FullName -NewName $newPath
        Write-Host "Renamed directory: $($_.FullName) -> $newPath"
    }
}
