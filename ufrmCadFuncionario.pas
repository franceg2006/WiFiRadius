unit ufrmCadFuncionario;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.ExtCtrls, Vcl.ImgList,
  Data.DB, Vcl.Grids, Vcl.DBGrids, Vcl.ComCtrls, Vcl.Mask, Datasnap.DBClient,
  Vcl.DBCtrls, Data.FMTBcd, Data.SqlExpr, System.ImageList, FireDAC.Stan.Intf,
  FireDAC.Stan.Option, FireDAC.Stan.Error, FireDAC.Stan.Param, FireDAC.DatS,
  FireDAC.Phys.Intf, FireDAC.DApt.Intf, FireDAC.Stan.Async, FireDAC.Comp.Client,
  FireDAC.DApt, FireDAC.Comp.DataSet;

type
  TfrmCadFuncionario = class(TForm)
    ilimagem32: TImageList;
    pnl1: TPanel;
    spl1: TSplitter;
    btnSair: TButton;
    btnInserir: TButton;
    btnCancelar: TButton;
    btnSalvar: TButton;
    btnDeletar: TButton;
    btnEditar: TButton;
    pgcBuscaAluno: TPageControl;
    tstBusca: TTabSheet;
    dbgrd1: TDBGrid;
    pnl6: TPanel;
    lblabel2: TLabel;
    edt2: TEdit;
    edt3: TEdit;
    tstCadastro: TTabSheet;
    dsFuncionario: TDataSource;
    lbl1: TLabel;
    dbedtcodigo: TDBEdit;
    lbl2: TLabel;
    dbedtnome: TDBEdit;
    lbl3: TLabel;
    dbedtcpf: TDBEdit;
    lbl4: TLabel;
    dbedtsenha: TDBEdit;
    lbl7: TLabel;
    dbedtrg: TDBEdit;
    lbl8: TLabel;
    dbedtendereco: TDBEdit;
    lbl9: TLabel;
    dbedtdatahora: TDBEdit;
    dbrgrptipo: TDBRadioGroup;
    dbrgrpstatus: TDBRadioGroup;
    lblabel53: TLabel;
    dsUserSenha: TDataSource;
    dsGrupo: TDataSource;
    sqlRadcheck: TFDQuery;
    sqlRadusergroup: TFDQuery;
    procedure FormCreate(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure edt2Change(Sender: TObject);
    procedure edt3Change(Sender: TObject);
    procedure btnInserirClick(Sender: TObject);
    procedure btnEditarClick(Sender: TObject);
    procedure btnCancelarClick(Sender: TObject);
    procedure btnSalvarClick(Sender: TObject);
    procedure btnDeletarClick(Sender: TObject);
    procedure Botoes;
    procedure btnSairClick(Sender: TObject);
    procedure ApagaRegistro(cod_user : integer);
    procedure dbgrd1DblClick(Sender: TObject);
    procedure Bloqueia(status : Boolean);
  private
  sql_func : string;
  edit : string; // N=> NOVO CADASTRO, E=> EDITA CADASTRO, B=> BLOQUEIA ACESSO (APAGA DADOS DAS TABELAS DE ACESSO)
    { Private declarations }
  public
    { Public declarations }
  end;

var
  frmCadFuncionario: TfrmCadFuncionario;

implementation

{$R *.dfm}

uses UDM_WiFi;

procedure TfrmCadFuncionario.btnCancelarClick(Sender: TObject);
begin
  dsFuncionario.DataSet.Cancel;
  Botoes;
  Bloqueia(False);
end;

procedure TfrmCadFuncionario.btnDeletarClick(Sender: TObject);
begin
  // apagar os acessos nas outras tabelas
  if ((dsFuncionario.DataSet.State <> dsInsert)or(dsFuncionario.DataSet.State <> dsEdit)) then
  begin
    if MessageDlg('Tem certeza que deseja excluir as Informa??es?', TMsgDlgType.mtConfirmation,
    [TMsgDlgBtn.mbYes, TMsgDlgBtn.mbNo], 0) = mrYes then
    begin
      ApagaRegistro(dsFuncionario.DataSet.FieldByName('codigo').AsInteger);
      dsFuncionario.DataSet.Delete;
    end
    else
    begin
      messagedlg('Opera??o Cancelada !',mtInformation,[mbOK],0);
    end;
  end;
  Botoes;
  Bloqueia(False);
end;

procedure TfrmCadFuncionario.btnEditarClick(Sender: TObject);
begin
  pgcBuscaAluno.ActivePage := tstCadastro;
  if (dsFuncionario.DataSet.State <> dsInactive) then
  begin
    dsFuncionario.DataSet.Edit;
  end;
  edit := 'E'; // para n?o gerar novo codigo de funcion?rio
  Botoes;
  Bloqueia(True);
  dbedtnome.SetFocus;
end;

procedure TfrmCadFuncionario.btnInserirClick(Sender: TObject);
begin
  pgcBuscaAluno.ActivePage := tstCadastro;
  if (DM_WiFi.FDQFunc.State = dsInactive) then
  begin
    DM_WiFi.FDQFunc.Open;
  end;
  DM_WiFi.FDQFunc.Append;
  edit := 'N'; // gera novo codigo para funcionario
  Botoes;
  Bloqueia(True);
  dbedtnome.SetFocus;
end;

procedure TfrmCadFuncionario.btnSairClick(Sender: TObject);
begin
  Close;
end;

procedure TfrmCadFuncionario.btnSalvarClick(Sender: TObject);
var id, cod_func : Integer;
begin
  //bloquear ou n?o usuario
  if DM_WiFi.FDQFunc.FieldByName('status').AsString = 'B' then
    edit := 'B';

  // salvar os Acessos nas outras tabelas
  if ((DM_WiFi.FDQFunc.State = dsInsert) or (DM_WiFi.FDQFunc.State = dsEdit)) then
  begin
    try
      DM_WiFi.sqlData.Close;
      DM_WiFi.sqlData.Open;
      DM_WiFi.FDQFunc.FieldByName('data').AsDateTime := DM_WIFI.sqlData.FieldByName('data').Value;

      if edit = 'N' then // s? entra se for criado um funcion?rio novo ( para n?o alterar o codigo e duplicar registro no bd )
      begin
        DM_WiFi.sqlCod_func.Close;
        DM_WiFi.sqlCod_func.Open;
        cod_func := DM_WiFi.sqlCod_func.FieldByName('codigo').AsInteger+1;
        dsFuncionario.DataSet.FieldByName('codigo').AsInteger := cod_func;

        DM_WiFi.sqlID.Close;
        DM_WiFi.sqlID.Open;
        id := DM_WiFi.sqlIDmaxid.AsInteger+1;

        try
          //insere GRUPO
          if dsGrupo.DataSet.State = dsInactive then
             dsGrupo.DataSet.Open;

          dsGrupo.DataSet.Insert;
          DM_WiFi.FDQGrupo.FieldByName('username').AsString := IntToStr(cod_func);
          DM_WiFi.FDQGrupo.FieldByName('groupname').AsString := 'wireless';
          DM_WiFi.FDQGrupo.FieldByName('priority').AsString := '1';
          dsGrupo.DataSet.Post;
        except
          messagedlg('Erro ao salvar dados, erro: Grupo 01015 !',mterror,[mbOK],0);
        end;

        try
          // Insere usuario
          if DM_WiFi.FDQUser_Senha.State = dsInactive then
            DM_WiFi.FDQUser_Senha.Open;

          dsUserSenha.DataSet.Insert;
          DM_WiFi.FDQUser_Senha.FieldByName('id').AsInteger := id;
          DM_WiFi.FDQUser_Senha.FieldByName('username').AsString := IntToStr(cod_func);
          DM_WiFi.FDQUser_Senha.FieldByName('attribute').AsString := 'Cleartext-Password';
          DM_WiFi.FDQUser_Senha.FieldByName('op').AsString := ':=';
          DM_WiFi.FDQUser_Senha.FieldByName('value').AsString := dsFuncionario.DataSet.FieldByName('senha').AsString;
          dsUserSenha.DataSet.Post;
        except
          messagedlg('Erro ao salvar dados, erro: usu?rio 01019 !',mterror,[mbOK],0);
        end;

      end
      else if edit = 'E' then  // edita um registro
      begin
        cod_func := DM_WiFi.FDQFunc.FieldByName('codigo').AsInteger;

        // por ser um procedimento de Edi??o, ? necess?rio apagar as informa??es das 2 tabelas do banco e criar novamente
        ApagaRegistro(cod_func);

        DM_WiFi.sqlID.Close;
        DM_WiFi.sqlID.Open;
        id := DM_WiFi.sqlIDmaxid.AsInteger+1;

        try
          //insere GRUPO
          if dsGrupo.DataSet.State = dsInactive then
             dsGrupo.DataSet.Open;

          dsGrupo.DataSet.Insert;
          DM_WiFi.FDQGrupo.FieldByName('username').AsString := IntToStr(cod_func);
          DM_WiFi.FDQGrupo.FieldByName('groupname').AsString := 'wireless';
          DM_WiFi.FDQGrupo.FieldByName('priority').AsString := '1';
          dsGrupo.DataSet.Post;
        except
          messagedlg('Erro ao salvar dados, erro: Grupo 01015 !',mterror,[mbOK],0);
        end;

        try
          // Insere usuario
          if DM_WiFi.FDQUser_Senha.State = dsInactive then
            DM_WiFi.FDQUser_Senha.Open;

          dsUserSenha.DataSet.Insert;
          DM_WiFi.FDQUser_Senha.FieldByName('id').AsInteger := id;
          DM_WiFi.FDQUser_Senha.FieldByName('username').AsString := IntToStr(cod_func);
          DM_WiFi.FDQUser_Senha.FieldByName('attribute').AsString := 'Cleartext-Password';
          DM_WiFi.FDQUser_Senha.FieldByName('op').AsString := ':=';
          DM_WiFi.FDQUser_Senha.FieldByName('value').AsString := dsFuncionario.DataSet.FieldByName('senha').AsString;
          dsUserSenha.DataSet.Post;
        except
          messagedlg('Erro ao salvar dados, erro: usu?rio 01019 !',mterror,[mbOK],0);
        end;
      end
      else if edit = 'B' then // bloqueia acesso 'B'
      begin
        cod_func := DM_WiFi.FDQFunc.FieldByName('codigo').AsInteger;
        // apaga registro da tabela de acesso
        ApagaRegistro(cod_func);
      end;

      DM_WiFi.FDQFunc.Post;

      messagedlg('Gravado com Sucesso!',mtinformation,[mbOK],0);
    except
      messagedlg('N?o foi possivel salvar os dados!',mterror,[mbOK],0);
    end;
    DM_WiFi.FDQFunc.Refresh;
  end;
  Botoes;
  Bloqueia(False);
end;

procedure TfrmCadFuncionario.dbgrd1DblClick(Sender: TObject);
begin
  pgcBuscaAluno.ActivePage := tstCadastro;
end;

procedure TfrmCadFuncionario.edt2Change(Sender: TObject);
begin
  if edt2.Text <> '' then
  begin
    DM_WiFi.FDQFunc.Close;
    DM_WiFi.FDQFunc.SQL.Clear;
    DM_WiFi.FDQFunc.SQL.CommaText := sql_func +' where nome like '''+'%'+edt2.Text+'%'+''''
                                                         +' order by nome';
    DM_WiFi.FDQFunc.Open;
  end;
end;

procedure TfrmCadFuncionario.edt3Change(Sender: TObject);
begin
   if edt3.Text <> '' then
   begin
    DM_WiFi.FDQFunc.Close;
    DM_WiFi.FDQFunc.SQL.Clear;
    DM_WiFi.FDQFunc.SQL.CommaText := sql_func +' where cpf like '''+'%'+edt3.Text+'%'+''''
                                                         +' order by cpf';
    DM_WiFi.FDQFunc.Open;
   end;
end;

procedure TfrmCadFuncionario.FormCreate(Sender: TObject);
begin
{  Self.dmConectaWIFI := TdmConectaWIFI.Create(nil);
  dsFuncionario.DataSet := Self.dmConectaWIFI.cdsFunc;
  dsUserSenha.DataSet := Self.dmConectaWIFI.cdsUserSenha;
  dsGrupo.DataSet := Self.dmConectaWIFI.cdsGrupo;}
  DM_WIFI := TDM_WIFI.Create(Self);
  Self.dsFuncionario.DataSet := DM_WIFI.FDQFunc;
  Self.dsGrupo.DataSet := DM_WiFi.FDQGrupo;
  Self.dsUserSenha.DataSet := DM_WiFi.FDQUser_Senha;

end;

procedure TfrmCadFuncionario.FormShow(Sender: TObject);
begin
  pgcBuscaAluno.ActivePage := tstBusca;
  sql_func := DM_WiFi.FDQFunc.SQL.CommaText;
  DM_WiFi.FDQFunc.Open;
  Botoes;
  edt2.SetFocus;
  Bloqueia(False);
end;

procedure TfrmCadFuncionario.Botoes; // trata o status dos Botoes
begin
    // compara com as 'variaveis de acesso' se o usuario tem permiss?o
    if (DM_WiFi.FDQFunc.State = dsInsert) then
    begin
      btnInserir.Enabled := False;
      btnEditar.Enabled := False;
      btnDeletar.Enabled := False;
      btnSalvar.Enabled := True;
      btnCancelar.Enabled := True;
    end
    else if (DM_WiFi.FDQFunc.State = dsEdit) then
    begin
      btnInserir.Enabled := False;
      btnDeletar.Enabled := False;
      btnSalvar.Enabled := True;
      btnCancelar.Enabled := True;
      btnEditar.Enabled := False;
    end
    else if (DM_WiFi.FDQFunc.State = dsBrowse) then
    begin
      btnInserir.Enabled := True;
      btnEditar.Enabled := True;
      btnDeletar.Enabled := True;
      btnSalvar.Enabled := False;
      btnCancelar.Enabled := False;
    end
    else if (DM_WiFi.FDQFunc.State = dsInactive) then
    begin
      btnInserir.Enabled := True;
      btnEditar.Enabled := True;
      btnDeletar.Enabled := True;
      btnSalvar.Enabled := False;
      btnCancelar.Enabled := False;
    end;
end;

procedure TfrmCadFuncionario.ApagaRegistro(cod_user: Integer);
begin
  // procedimento para apagar o usuario das tabelas 'radcheck' e 'radusergroup'

  //radchek
  sqlRadcheck.SQL.CommaText := 'DELETE FROM radcheck '
                                      +' where username = '+IntToStr(cod_user);
  sqlRadcheck.ExecSQL(True);

  // radusergroup
  sqlRadusergroup.SQL.CommaText := 'DELETE FROM radusergroup '
                          +' where username = '+IntToStr(cod_user);
  sqlRadusergroup.ExecSQL(True);


end;


procedure TfrmCadFuncionario.Bloqueia(status: Boolean);
begin
  dbedtnome.Enabled := status;
  dbedtcpf.Enabled := status;
  dbedtsenha.Enabled := status;
  dbedtrg.Enabled := status;
  dbedtendereco.Enabled := status;
  dbrgrptipo.Enabled := status;
  dbrgrpstatus.Enabled := status;
end;

end.
