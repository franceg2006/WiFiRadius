unit UDM;

interface

uses
  System.SysUtils, System.Classes, FireDAC.Stan.Intf, FireDAC.Stan.Option,
  FireDAC.Stan.Error, FireDAC.UI.Intf, FireDAC.Phys.Intf, FireDAC.Stan.Def,
  FireDAC.Stan.Pool, FireDAC.Stan.Async, FireDAC.Phys, FireDAC.Phys.FB,
  FireDAC.Phys.FBDef, FireDAC.VCLUI.Wait, Data.DB, FireDAC.Comp.Client,
  FireDAC.Stan.Param, FireDAC.DatS, FireDAC.DApt.Intf, FireDAC.DApt,
  FireDAC.Comp.DataSet;

type
  TDM = class(TDataModule)
    FDC_GradEAD: TFDConnection;
    FDQGradEAD: TFDQuery;
    DsGradEAD: TDataSource;
    FDC_Colegio: TFDConnection;
    FDQ_Colegio: TFDQuery;
    Ds_Colegio: TDataSource;
    FDC_GradPres: TFDConnection;
    FDQ_GradPres: TFDQuery;
    Ds_GradPres: TDataSource;
    FDC_PosEAD: TFDConnection;
    FDQ_PosEAD: TFDQuery;
    Ds_PosEAD: TDataSource;
    Ds_PosPresDdos: TDataSource;
    FDC_PosPresDdos: TFDConnection;
    FDQ_PosPresDdos: TFDQuery;
    FDC_PosPresCG: TFDConnection;
    FDQ_PosPresCG: TFDQuery;
    Ds_PosPresCG: TDataSource;
    FDQGradEADRGM: TWideStringField;
    FDQGradEADSENHA: TWideStringField;
    FDQ_ColegioCODIGO: TIntegerField;
    FDQ_ColegioSENHA: TStringField;
    FDQ_GradPresRGM: TStringField;
    FDQ_GradPresSENHA: TStringField;
    FDQ_PosEADRGM: TStringField;
    FDQ_PosEADSENHA: TStringField;
    FDQ_PosPresDdosRGM: TStringField;
    FDQ_PosPresDdosSENHA: TStringField;
    FDQ_PosPresCGRGM: TStringField;
    FDQ_PosPresCGSENHA: TStringField;
    FDC_GradPresCG: TFDConnection;
    FDQ_GradPresCG: TFDQuery;
    Ds_GradPresCG: TDataSource;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  DM: TDM;

implementation

{%CLASSGROUP 'Vcl.Controls.TControl'}

{$R *.dfm}

end.
