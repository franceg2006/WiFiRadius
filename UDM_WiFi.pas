unit UDM_WiFi;

interface

uses
  System.SysUtils, System.Classes, FireDAC.Stan.Intf, FireDAC.Stan.Option,
  FireDAC.Stan.Error, FireDAC.UI.Intf, FireDAC.Phys.Intf, FireDAC.Stan.Def,
  FireDAC.Stan.Pool, FireDAC.Stan.Async, FireDAC.Phys, FireDAC.Phys.MySQL,
  FireDAC.Phys.MySQLDef, FireDAC.VCLUI.Wait, FireDAC.Stan.Param, FireDAC.DatS,
  FireDAC.DApt.Intf, FireDAC.DApt, Data.DB, FireDAC.Comp.DataSet,
  FireDAC.Comp.Client;

type
  TDM_WiFi = class(TDataModule)
    dsGrupo: TDataSource;
    FDQGrupo: TFDQuery;
    FDQGrupousername: TStringField;
    FDQGrupogroupname: TStringField;
    FDQGrupopriority: TIntegerField;
    dsUserSenha: TDataSource;
    DsFunc: TDataSource;
    FDQFunc: TFDQuery;
    sqlRadusergroup: TFDCommand;
    sqlRadcheck: TFDCommand;
    sqlID: TFDQuery;
    sqlIDmaxid: TLongWordField;
    FDQUser_Senha: TFDQuery;
    FDQUser_Senhaid: TFDAutoIncField;
    FDQUser_Senhausername: TStringField;
    FDQUser_Senhaattribute: TStringField;
    FDQUser_Senhaop: TStringField;
    FDQUser_Senhavalue: TStringField;
    FDQFunccodigo: TIntegerField;
    FDQFuncnome: TStringField;
    FDQFunccpf: TStringField;
    FDQFuncsenha: TStringField;
    FDQFunctipo: TStringField;
    FDQFuncstatus: TStringField;
    FDQFuncrg: TStringField;
    FDQFuncendereco: TStringField;
    FDQFuncdata: TDateField;
    sqlCod_func: TFDQuery;
    sqlData: TFDQuery;
    FD_Connect_WiFi: TFDConnection;
    FDPhysMySQLDriverLink1: TFDPhysMySQLDriverLink;
    FD_conecta_WiFiII: TFDConnection;
    procedure FD_Connect_WiFiBeforeConnect(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  DM_WiFi: TDM_WiFi;

implementation

{%CLASSGROUP 'Vcl.Controls.TControl'}

{$R *.dfm}

procedure TDM_WiFi.FD_Connect_WiFiBeforeConnect(Sender: TObject);
begin
// antes de conectar
{  FDPhysMySQLDriverLink1.VendorLib :=
  ExtractFilePath(Application.ExeName)+ 'libmysql.dll';}

// ShowMessage(FDPhysMySQLDriverLink1.VendorLib);
end;

end.
