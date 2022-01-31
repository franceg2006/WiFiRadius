program SIS_WIFI;

uses
  Vcl.Forms,
  ufrmPrincipal in 'ufrmPrincipal.pas' {frmPrincipal},
  ufrmMenu in 'ufrmMenu.pas' {frmMenu},
  ufrmCadFuncionario in 'ufrmCadFuncionario.pas' {frmCadFuncionario},
  UDM_WiFi in 'UDM_WiFi.pas' {DM_WiFi: TDataModule},
  UDM in 'UDM.pas' {DM: TDataModule};

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TfrmMenu, frmMenu);
  Application.Run;
end.
