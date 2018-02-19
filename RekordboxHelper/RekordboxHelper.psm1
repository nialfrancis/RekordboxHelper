$iTunesLibraryDirectory = Join-Path $([environment]::getfolderpath("mydocuments")) "My Music\iTunes\"
$RekordboxDirectory = [environment]::getfolderpath("mydocuments")
$iTunesLibraryName = "iTunes Library.xml"
$RekordboxFileName = "rekordbox.xml"

$Script:rbxmlfile = Join-Path $RekordboxDirectory $RekordboxFileName
$Script:itxmlfile = Join-Path $iTunesLibraryDirectory $iTunesLibraryName

function LoadRBData {
    [xml]$rbxml = Get-Content -Path $rbxmlfile
    return $rbxml
}

function LoadITData {
    [xml]$itxml = Get-Content -Path $itxmlfile
    return $itxml
}

function ReplaceSymbols ($str) {
    return $str -replace "!",'%21' -replace '#','%23' -replace "$",'%24' -replace "&",'%26' -replace "'",'%27' -replace "\+",'%2B'
}

function Find-RekordboxDupes {
    $rbxml = LoadRBData

    $fns = $rbxml.DJ_PLAYLISTS.COLLECTION.TRACK.Location
    $fns = $fns | % { $_.ToLower() }
    $rbfiles = $rbfiles | Sort-Object

    $dupes = Compare-Object -ReferenceObject $fns -DifferenceObject $($fns | Select-Object -Unique)

    foreach ($item in $dupes.InputObject) {
        ($rbxml.DJ_PLAYLISTS.COLLECTION.TRACK | Where-Object {$_.Location -like $item}) | Select-Object -Property Name, Artist
    }
}

function Compare-RekordboxiTunes {
    $itxml = LoadITData
    $rbxml = LoadRBData

    # Gather iTunes files
    $itfiles = foreach ($trk in $itxml.plist.dict.dict.dict) {
        foreach ($el in $trk.string) {
            if ($el -match "file:") {
                $el
            }
        }
    }

    $itfiles = $itfiles | % { $_.ToLower() }
    $itfiles = foreach ($item in $itfiles) {
        ReplaceSymbols $item
    }

    $itfiles = $itfiles | Sort-Object

    # Gather rekordbox files
    $rbfiles = $rbxml.DJ_PLAYLISTS.COLLECTION.TRACK.Location
    $rbfiles = $rbfiles | % { $_.ToLower() }
    $rbfiles = foreach ($item in $rbfiles) {
        ReplaceSymbols $item
    }

    $rbfiles = $rbfiles | Sort-Object

    $diff = Compare-Object -ReferenceObject $itfiles -DifferenceObject $rbfiles

    foreach ($item in $diff.InputObject) {
        ($rbxml.DJ_PLAYLISTS.COLLECTION.TRACK | Where-Object {
            $(ReplaceSymbols $_.Location) -like $item
        }) | Select-Object -Property Name, Artist
    }
}