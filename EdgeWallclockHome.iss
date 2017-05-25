[Setup]
AppName=Edge Wallclock Homepage
AppVerName=Edge Wallclock Homepage
AppPublisher=Rob ^_^
DefaultDirName={pf}\Internet Explorer\Homepages
DefaultGroupName=IE Extensions
WizardImageFile=setupsplash.bmp
WizardImageBackColor=clWhite
WizardSmallImageFile=setupsmall.bmp
UserInfoPage=false
WindowResizable=false
WindowVisible=false
BackColor2=clWhite
UsePreviousUserInfo=false
AllowUNCPath=false
AppVersion=1.0.1
AppCopyright=Rob
Compression=zip/9
MinVersion=5.0
ChangesAssociations=false
RestartIfNeededByRun=false
UninstallDisplayName=Uninstall Edge Wallclock for Internet Explorer
PrivilegesRequired=none
UpdateUninstallLogAppName=false
OutputBaseFilename=EdgeWallclock
SolidCompression=true
ExtraDiskSpaceRequired=0
UsePreviousSetupType=false
UsePreviousAppDir=true
UsePreviousGroup=true
DisableProgramGroupPage=true
DisableDirPage=true
SetupIconFile=edgewallclock.ico
AlwaysRestart=false
CreateUninstallRegKey=false
[Files]
; Source Files
Source: EdgeWallClockHome.htm; DestDir: {app}; Flags: ignoreversion overwritereadonly
Source: EdgeNeon.png; DestDir: {app}; Flags: ignoreversion
Source: brick_bk.jpg; DestDir: {app}; Flags: ignoreversion
Source: ticker.js; DestDir: {app}; Flags: ignoreversion
Source: edgewallclock.ico; DestDir: {app}; Flags: ignoreversion uninsneveruninstall
[Registry]




[Icons]
Name: {group}\HomePages\Uninstall Edge Wallclock Homepage; Filename: {uninstallexe}
;Name: {userfavorites}\Links\Homepages
Name: {userfavorites}\Homepages\Edge Wallclock Homepage; Filename: {app}\EdgeWallClockHome.htm; IconFilename: {app}\edgewallclock.ico

[Code]
var
  HomePageOptions: TInputOptionWizardPage;
  chkMakeHome: TCheckBox;
  chkDesktop: TCheckBox;


procedure InitializeWizard;
begin

  { Create the pages }

  HomePageOptions := CreateInputOptionPage(wpInfoBefore,'Homepage Setup Options', 'Select your Homepage Installation Options Here..','', False, False);

  chkMakeHome := TCheckBox.Create(HomePageOptions);
  chkMakeHome.Top := ScaleY(8);
  chkMakeHome.Width := HomePageOptions.SurfaceWidth;
  chkMakeHome.Height := ScaleY(17);
  chkMakeHome.Caption := 'Make this My Homepage.';
  chkMakeHome.Checked := True;
  chkMakeHome.Parent := HomePageOptions.Surface;

  chkDesktop := TCheckBox.Create(HomePageOptions);
  chkDesktop.Top := chkMakeHome.top + chkMakeHome.Height + ScaleY(8);
  chkDesktop.Width := HomePageOptions.SurfaceWidth;
  chkDesktop.Height := ScaleY(17);
  chkDesktop.Caption := 'Create Desktop shortcut.';
  chkDesktop.Checked := True;
  chkDesktop.Parent := HomePageOptions.Surface;


end;

function NextButtonClick(CurPageID: Integer): Boolean;
var
  I: Integer;
begin
  { Validate certain pages before allowing the user to proceed }
    Result := True;
end;

function UpdateReadyMemo(Space, NewLine, MemoUserInfoInfo, MemoDirInfo, MemoTypeInfo,
  MemoComponentsInfo, MemoGroupInfo, MemoTasksInfo: String): String;
var
  S: String;
begin
  { Fill the 'Ready Memo' with the normal settings and the custom settings }
	S := '';
	if chkMakeHome.Checked = true then
		S := S + Space + 'Make this my Homepage now.' + NewLine;
	if chkDesktop.Checked = true then
		S := S + Space + 'Create Desktop shortcut.' + NewLine;

  Result := S;
end;
// Write the registry keys here.

procedure DoPostInstall();
var
	filename: String;
begin
	if chkMakeHome.Checked = true then
	begin
		filename := ExpandConstant('{app}') + '\EdgeWallClockHome.htm';
		RegWriteStringValue(HKEY_CURRENT_USER, 'Software\Microsoft\Internet Explorer\Main','Start Page', filename);
	end;
	if chkDesktop.Checked = true then
	begin
		CreateShellLink(ExpandConstant('{userdesktop}\Edge Wallclock Homepage.lnk'),
		'Edge Wallclock Homepage',
		ExpandConstant('{app}\EdgeWallClockHome.htm'),
		'',
		'',
		ExpandConstant('{app}\edgewallclock.ico'),
		0,
		SW_SHOWNORMAL);
	end;

end;

procedure CurStepChanged(CurStep: TSetupStep);
begin
  if CurStep = ssPostInstall then
    DoPostInstall();
end;

procedure CurUninstallStepChanged(CurUninstallStep: TUninstallStep);
var
	filename: String;
	buf: String;
	ans: Boolean;
begin
  case CurUninstallStep of
    usUninstall:
	begin
		filename := ExpandConstant('{app}') + '\IEEdgeWpaper.html';
		if RegQueryStringValue(HKEY_CURRENT_USER,'Software\Microsoft\Internet Explorer\Main','Start Page', buf)then
		begin
			if buf = filename then
			begin
				RegWriteStringValue(HKEY_CURRENT_USER, 'Software\Microsoft\Internet Explorer\Main','Start Page', 'about:Tabs');
			end;
		end;
		ans :=DeleteFile (ExpandConstant('{userdesktop}\Edge Wallclock Homepage.lnk'));
	end;
    usPostUninstall:
	end;
end;
