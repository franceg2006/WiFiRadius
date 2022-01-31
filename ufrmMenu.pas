unit ufrmMenu;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.Menus, Vcl.Imaging.pngimage,
  Vcl.ExtCtrls,midaslib;

type
  TfrmMenu = class(TForm)
    mm1: TMainMenu;
    mniCadFuncionrioProfessorVisitante1: TMenuItem;
    mniSais1: TMenuItem;
    mniRenovaAcessosAlunosFuncionrios1: TMenuItem;
    mniRenovaAcessosAlunosFuncionrios2: TMenuItem;
    img1: TImage;
    procedure mniCadFuncionrioProfessorVisitante1Click(Sender: TObject);
    procedure mniSais1Click(Sender: TObject);
    procedure mniRenovaAcessosAlunosFuncionrios2Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  frmMenu: TfrmMenu;

implementation

{$R *.dfm}

uses ufrmCadFuncionario, ufrmPrincipal;

procedure TfrmMenu.mniCadFuncionrioProfessorVisitante1Click(Sender: TObject);
begin
   try
      Application.CreateForm(TfrmCadFuncionario , frmCadFuncionario);
      frmCadFuncionario.ShowModal;
   finally
      frmCadFuncionario.Free;
   end;
end;

procedure TfrmMenu.mniRenovaAcessosAlunosFuncionrios2Click(Sender: TObject);
begin
  try
    Application.CreateForm(TfrmPrincipal , frmPrincipal);
    frmPrincipal.ShowModal;
  finally
    frmPrincipal.Free;
  end;
end;

procedure TfrmMenu.mniSais1Click(Sender: TObject);
begin
  Close;
end;

end.
