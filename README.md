# RekordboxHelper
A set of helper tools for use when managing iTunes and rekordbox libraries on Windows.

## Description

Due to Pioneer rekordbox lacking many useful tools for keeping iTunes in sync with it and no programmable interface, the RekordboxHelper is a collection of tools to use with the rekordbox and iTunes XML outputs.

One of rekordbox's worst issues is it's case sensitive file descriptors, which on case-insensitive Windows causes duplicates in your collection.
Rekordbox also has no show duplicates function. (!) This script will keep you sane.

Another issue you may have if you're managing the library in iTunes is having more tracks in rekordbox than iTunes.
You can see which iTunes tracks aren't in rekordbox as they aren't imported, but which ones aren't in iTunes? I've got your back.

## Usage

1. In iTunes go to Edit > Preferences > Advanced > Tick "Share iTunes Library XML with other applications"
2. Dump the RekordboxHelper directory into your modules directory. Run ' $env:PSModulePath.Split(';')[0] ' to display it.
3. If you use default directories you wont need to update anything in the script.  
If not, update:
  - $iTunesLibraryDirectory = << YOUR ITUNES LIBRARY FOLDER >>
  - $RekordboxDirectory = << THE FOLDER YOU CHOOSE TO EXPORT YOUR REKORDBOX XML IN >>
  - $iTunesLibraryName = << YOUR ITUNES LIBRARY FILE NAME >>
  - $RekordboxFileName = << YOUR REKORDBOX XML FILE NAME >>
4. In rekordbox, choose File > Export Collection in xml format

### Now You're Set

Open PowerShell:

- To find duplicates, run Find-RekordboxDupes

```
PS C:\Users> Find-RekordboxDupes

Name                      Artist
----                      ------
Finally (DJ Meri Vox Mix) Kings Of Tomorrow ft. Julie Mcknight
Finally (DJ Meri Vox Mix) Kings Of Tomorrow ft. Julie Mcknight
```

- To find tracks in rekordbox but not in iTunes, run Compare-RekordboxiTunes

```
PS C:\Users> Compare-RekordboxiTunes

Name                        Artist
----                        ------
I Take You Out To Space (2007)                 The Mulder
Linda [Kenny Dope Remix]                       Martin Solveig Fea...
Deliverance (Tyken Vasaplatsen Remix)          Dj Nibc feat Karim...
```