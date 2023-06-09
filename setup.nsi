; setup.nsi
;
; This script is based on example1.nsi, but it remembers the directory, 
; has uninstall support and (optionally) installs start menu shortcuts.
;
; It will install setup.nsi into a directory that the user selects.
;
; See install-shared.nsi for a more robust way of checking for administrator rights.
; See install-per-user.nsi for a file association example.

;--------------------------------

; The name of the installer
Name "FishTrackerV2"

; The file to write
OutFile "FishTrackerV2.exe"

; Request application privileges for Windows Vista and higher
RequestExecutionLevel admin

; Build Unicode installer
Unicode True

; The default installation directory
InstallDir $PROGRAMFILES\FishTrackerV2

; Registry key to check for directory (so if you install again, it will 
; overwrite the old one automatically)
InstallDirRegKey HKLM "Software\FishTrackerV2" "Install_Dir"

;--------------------------------

; Pages

Page components
Page directory
Page instfiles

UninstPage uninstConfirm
UninstPage instfiles

;--------------------------------

; The stuff to install
Section "FishTrackerV2 (required)"

  SectionIn RO
  
  ; Set output path to the installation directory.
  SetOutPath $INSTDIR
  
  ; Put file there
  File /r "fish_tracker\*.*"
  
  ; Write the installation path into the registry
  WriteRegStr HKLM SOFTWARE\FishTrackerV2 "Install_Dir" "$INSTDIR"
  
  ; Write the uninstall keys for Windows
  WriteRegStr HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\FishTrackerV2" "DisplayName" "FishTrackerV2"
  WriteRegStr HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\FishTrackerV2" "UninstallString" '"$INSTDIR\uninstall.exe"'
  WriteRegDWORD HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\FishTrackerV2" "NoModify" 1
  WriteRegDWORD HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\FishTrackerV2" "NoRepair" 1
  WriteUninstaller "$INSTDIR\uninstall.exe"
  
SectionEnd

; Optional section (can be disabled by the user)
Section "Start Menu Shortcuts"

  CreateDirectory "$SMPROGRAMS\FishTrackerV2"
  CreateShortcut "$SMPROGRAMS\FishTrackerV2\FishTrackerV2.lnk" "$INSTDIR\fish_tracker.exe"

SectionEnd

;--------------------------------

; Uninstaller

Section "Uninstall"
  
  ; Remove registry keys
  DeleteRegKey HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\FishTrackerV2"
  DeleteRegKey HKLM SOFTWARE\FishTrackerV2

  ; Remove files and uninstaller
  Delete $INSTDIR\FishTrackerV2
  Delete $INSTDIR\uninstall.exe

  ; Remove shortcuts, if any
  Delete "$SMPROGRAMS\FishTrackerV2\*.lnk"

  ; Remove directories
  RMDir "$SMPROGRAMS\FishTrackerV2"
  RMDir /r "$INSTDIR"

SectionEnd
