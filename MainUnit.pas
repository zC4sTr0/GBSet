unit MainUnit;
(*
##################################################################################
GunBound Options - GunProtect v2.0
Original Name: GbSet.exe
Desenvolvido pela equipe GunProtect - www.GunProtect.com.br
Exclusivamente para o GunBound GitzWC
Todos os direitos reservados.
Somente está autorizado a modificar a sourcecode o pessoal do GitzWC
Os demais devem pedir autorização para
rizzo@gunprotect.com.br ou c4str0@gunprotect.com.br ou em nosso fórum
2018-2019 - www.gunprotect.com.br
##################################################################################
*)
interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ComCtrls, StdCtrls, ExtCtrls, XPMan, Registry, inifiles, uFunc,  ShellApi,
  Buttons, pngimage, JvExControls, JvSlider, JvExExtCtrls, JvImage,
  JvExStdCtrls, JvRadioButton, JvExtComponent, JvPanel;

type
  TfmrOptions = class(TForm)
    imgBgPT: TImage;
    imgBgES: TImage;
    imgBgEN: TImage;
    imgClose: TJvImage;
    imgMinimize: TJvImage;
    sldrDK: TJvSlider;
    sldrMusic: TJvSlider;
    sldrEffect: TJvSlider;
    sldrNotification: TJvSlider;
    sldrEMOT: TJvSlider;
    imgWM: TImage;
    pnlGraphics: TJvPanel;
    rbFull: TRadioButton;
    rbLow: TRadioButton;
    rbNoBG: TRadioButton;
    pnlWM: TJvPanel;
    rbinActive: TRadioButton;
    rbActive: TRadioButton;
    pnlLanguageConfirm: TJvPanel;
    imgConfirmEN: TJvImage;
    imgConfirmPT: TJvImage;
    imgGPSITE: TJvImage;
    rbPT: TRadioButton;
    rbES: TRadioButton;
    rbEN: TRadioButton;
    tmrRepaint: TTimer;
    imgCaptionBar: TImage;
    procedure FormCreate(Sender: TObject);
    procedure imgGPSITEClick(Sender: TObject);
    procedure imgConfirmPTClick(Sender: TObject);
    procedure imgConfirmENClick(Sender: TObject);
    procedure rbESClick(Sender: TObject);
    procedure rbENClick(Sender: TObject);
    procedure rbPTClick(Sender: TObject);
    procedure imgMinimizeClick(Sender: TObject);
    procedure imgCloseClick(Sender: TObject);
    procedure SaveSettings;
    procedure tmrRepaintTimer(Sender: TObject);
    procedure imgCaptionBarMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
  private
    { Private declarations }


  public
    { Public declarations }
  end;

var
  fmrOptions: TfmrOptions;
  gbReg:  TRegistry;
  gbIni:  TIniFile;
  windMode: Integer;
  key32,  key64,  realKey,
  location, isActive:  String;
  toTerminate:  boolean;
  timerloop:cardinal;

implementation

{$R *.dfm}
{$J+}


function IsWow64Process: Boolean;
type
  TIsWow64Process = function(hProcess: THandle; var Wow64Process: Boolean): Boolean; stdcall;
var
  DLL: THandle;
  pIsWow64Process: TIsWow64Process;
const
  Called: Boolean = False;
  IsWow64: Boolean = False;
begin
  if (Not Called) then // only check once
  begin
    DLL := LoadLibrary('kernel32.dll');
    if (DLL <> 0) then
    begin
      pIsWow64Process := GetProcAddress(DLL, 'IsWow64Process');
      if (Assigned(pIsWow64Process)) then
      begin
        pIsWow64Process(GetCurrentProcess, IsWow64);
      end;
      Called := True; // avoid unnecessary loadlibrary
      FreeLibrary(DLL);
    end;
  end;
  Result := IsWow64;
end;
{$J-}

function ReadIni(StrIniPath : pchar; StrSection : pchar; StrItem : pchar; StrDefault : pchar) : String;
var
RetAmount : Integer;
StrTemp : String;
StrRet : string;
begin
  SetLength(StrTemp,50);
  RetAmount := GetPrivateProfileString(StrSection, StrItem, StrDefault, pchar(StrTemp), 50, StrIniPath);
  StrRet    := Copy(StrTemp,1,RetAmount);
  Result    := StrRet;
end;

procedure TfmrOptions.FormCreate(Sender: TObject);
var
idioma          :integer;
BackgroundValue : Array [0..0] of byte;
Effect3DValue   : Array [0..0] of byte;
EffectUseValue  : Array [0..0] of byte;
begin
  try
    OutputDebugStringA('GunProtect] GunBound Options v2.2');
    timerloop:=0;
    if  not isElevated  then
      begin
        MessageBox(0,'Esse programa precisa ser executado como administrador.'+#13+#10+
                     'Execute o launcher como administrador e tente novamente!','GunBound Options - GunProtect',mb_IconError);
        Application.Terminate;
      end;
   gbIni :=  TIniFile.Create(ExtractFilePath(Application.ExeName)+'GitzConfig.ini');
   isActive  :=  gbIni.ReadString('Config','WindowMode','');
    if  isActive  = '1' then
    rbActive.Checked  :=  True  else
    rbinActive.Checked  :=  True;
   idioma := StrToInt(pchar(ReadIni(PChar(ExtractFilePath(ParamStr(0)) + 'GitzConfig.ini'), 'Config', 'Idioma', '0')));
  if (idioma=1) then
    begin
      rbpt.checked := true;
    end else
    begin
      if (idioma=2) then
      begin
        rbes.checked := true;
        imgBgES.Visible:=true;
        imgBgPT.Visible:= false;
      end else begin
          rben.checked := true;
          imgBgEN.Visible:= true;
          imgBgPT.Visible:= false;
          imgConfirmEN.Visible:=true;
       end;
    end;
   Key32 :=  'Software\SysLink\GunBoundWC';
    Key64 :=  'Software\Wow6432Node\SysLink\GunBoundWC';
    OutputDebugStringA('THIS PROGRAM IS MADE BY GUNPROTECT');

    gbReg :=  TRegistry.Create;
     with  gbReg do
    begin
      RootKey :=  HKEY_LOCAL_MACHINE;
        if  KeyExists(Key32) then
          begin
            RealKey :=  Key32;
          end else
          begin
            RealKey :=  Key64;
          end;
        OpenKey(realKey,  false);

        OutputDebugStringA('www.gunprotect.com.br');

      if  not ValueExists('DK Volume')  then WriteInteger('DK Volume',  600);


      if  not ValueExists('Notification Volume')  then WriteInteger('Notification Volume',1000);

      if  not ValueExists('Emots Volume')  then   WriteInteger('Emots Volume',600);

        sldrDK.Position     :=  (ReadInteger('DK Volume'));
        sldrNotification.Position :=  (ReadInteger('Notification Volume'));
        sldrEMOT.Position  :=  (ReadInteger('Emots Volume'));

        sldrEffect.Position :=  ReadInteger('EffectVolume');
        sldrMusic.Position  :=  ReadInteger('MusicVolume');

     if ReadBinaryData('Background',BackgroundValue,1) <= 0 then
     MessageDlg('GunProtect GBSet Error:' + #13+#10+ (SysErrorMessage(GetLastError)),mtError,[mbOk],0);

     if ReadBinaryData('Effect3D',Effect3DValue,1) <= 0 then
     MessageDlg('GunProtect GBSet Error:' + #13+#10+ (SysErrorMessage(GetLastError)),mtError,[mbOk],0);

     if  ReadBinaryData('EffectUse',EffectUseValue,1) <= 0 then
     MessageDlg('GunProtect GBSet Error:' + #13+#10+ (SysErrorMessage(GetLastError)),mtError,[mbOk],0);

     if BackgroundValue[0] = 0 then
      rbNoBG.Checked:=True
     else begin
       if EffectUseValue[0] = 0 then
         rbLow.Checked := True
       else
       rbFull.Checked:=true
     end;

      OpenKey('SOFTWARE\Microsoft\FTH', true);
      WriteInteger('Enabled',0);
    end;
  finally
    gbIni.Free;
    gbReg.Free;
    tmrRepaint.enabled := true;
  end;
end;
function IntToAnsiStr(X: Integer; Width: Integer = 0): AnsiString;
begin
   Str(X: Width, Result);
end;
procedure TfmrOptions.SaveSettings;
var
  zero:array[0..3]of byte;
  idioma: integer;
begin
 gbReg :=  TRegistry.Create;
  with  gbReg do
    begin
      RootKey :=  HKEY_LOCAL_MACHINE;
      if  KeyExists(Key32)  then
      OpenKey('Software\SysLink\GunBoundWC',false)  else
      OpenKey('Software\Wow6432Node\SysLink\GunBoundWC',false);
      zero[0] :=  $00;
      zero[1] :=  $01;
      zero[2] :=  $02;
      zero[3] :=  $03;
        if  rbFull.checked  then
          begin
            WriteBinaryData('Background', zero[1], 1 );
            WriteBinaryData('Effect3D', zero[3], 1);
            WriteBinaryData('EffectUse', zero[1], 1);
         end;
        if  rbLow.Checked then
          begin
            WriteBinaryData('Background', zero[1], 1 );
            WriteBinaryData('Effect3D', zero[2], 1);
            WriteBinaryData('EffectUse', zero[0], 1);
         end;
        if  rbNoBG.Checked then
          begin
            WriteBinaryData('Background', zero[0], 1 );
            WriteBinaryData('Effect3D', zero[3], 1);
            WriteBinaryData('EffectUse', zero[1], 1);
         end;

      WriteInteger('EffectVolume',sldrEffect.Position);
      WriteInteger('MusicVolume',sldrMusic.Position);
      WriteInteger('DK Volume',sldrDK.Position);
      WriteInteger('Notification Volume',sldrNotification.Position);
      WriteInteger('Emots Volume',sldrEmot.Position);
      Location  :=  ReadString('Location');
      Free;
    end;
  try
    gbIni :=  TIniFile.Create(Location+'\GitzConfig.ini');
        if  rbActive.Checked  then
          windMode  :=  1 else
          windMode  :=  0;
          if rbpt.Checked then begin
          idioma :=1;
           end else begin
            if rbes.Checked then begin
              idioma := 2;
            end else idioma := 3;
          end;
          gbIni.WriteInteger('Config','WindowMode',windMode);
          gbIni.WriteInteger('Config','Idioma',idioma);

    if  windMode  = 1 then
      begin
            if  FileExists('ddraw.dll') then
        DeleteFile('ddraw.dll');
      RenameFile('gitzwindowmode.dll','ddraw.dll');
      end else
      begin
      if  FileExists('ddraw.dll') then
        DeleteFile('ddraw.dll');
      end;

  finally
    gbIni.Free;
  end;
 end;

procedure TfmrOptions.imgGPSITEClick(Sender: TObject);
begin
ShellExecute(0,'open','www.gunprotect.com.br',nil,nil,0);
end;

procedure TfmrOptions.imgConfirmPTClick(Sender: TObject);
begin
  SaveSettings;
  if rbPT.Checked then begin
   if Messagedlg (('As configurações foram salvas, deseja fechar o aplicativo?'), mtConfirmation,[mbyes,mbno],0)=mryes then
   Application.Terminate;
  end else begin
      if Messagedlg (('Los ajustes del GunBound ha sido guardados, desea cerrar la aplicación?'), mtConfirmation,[mbyes,mbno],0)=mryes then
       Application.Terminate;
  end;
end;

procedure TfmrOptions.imgConfirmENClick(Sender: TObject);
begin
  SaveSettings;
  if Messagedlg (('Your GunBound settings have been updated! Do you want to exit the application?'), mtConfirmation,[mbyes,mbno],0)=mryes then
  Application.Terminate;
end;

procedure TfmrOptions.rbESClick(Sender: TObject);
begin
  imgBgES.Visible:=true;
  imgBgPT.Visible:= false;
  imgBgEN.Visible:= false;
  imgConfirmPT.Visible := True;
  imgConfirmEN.visible := false;
  tmrRepaint.enabled := true;
end;

procedure TfmrOptions.rbENClick(Sender: TObject);
begin
  imgBgEN.Visible:= true;
  imgBgES.Visible:=false;
  imgBgPT.Visible:= false;
  imgConfirmEN.visible := True;
  imgConfirmPT.Visible := false;
  tmrRepaint.enabled := true;
end;

procedure TfmrOptions.rbPTClick(Sender: TObject);
begin
 imgBgPT.Visible:= true;
 imgBgEN.Visible:= false;
 imgBgES.Visible:= false;
   imgConfirmPT.Visible := True;
  imgConfirmEN.visible := false;
 tmrRepaint.enabled := true;
end;

procedure TfmrOptions.imgMinimizeClick(Sender: TObject);
begin
  Application.Minimize;
end;

procedure TfmrOptions.imgCloseClick(Sender: TObject);
begin
  Application.Terminate;
end;

procedure TfmrOptions.tmrRepaintTimer(Sender: TObject);
begin
 if timerloop<5 then begin
  pnlGraphics.BringToFront;
  pnlGraphics.Update;
  pnlGraphics.Repaint;
  pnlLanguageConfirm.BringToFront;
  pnlLanguageConfirm.Update;
  pnlLanguageConfirm.Repaint;
  pnlWM.BringToFront;
  pnlWM.Update;
  pnlWM.Repaint;
  timerloop := timerloop+1;
 end else begin
   timerloop :=0;
   tmrRepaint.enabled := false;
 end;
end;

procedure TfmrOptions.imgCaptionBarMouseDown(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
const
  sc_DragMove = $F012;
begin
  ReleaseCapture;
  Perform( wm_SysCommand, sc_DragMove, 0 );
end;

end.

