program GbSet;

uses
  Forms,
  MainUnit in 'MainUnit.pas' {fmrOptions},
  uFunc in 'uFunc.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.Title := 'GunBound Options - GunProtect';
  Application.CreateForm(TfmrOptions, fmrOptions);
  Application.Run;
end.
