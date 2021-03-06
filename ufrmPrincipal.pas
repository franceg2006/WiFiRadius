unit ufrmPrincipal;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls,
  Vcl.Grids, Vcl.DBGrids, Data.DB, DBClient, Vcl.ComCtrls, Vcl.ExtCtrls,
  Vcl.ImgList, System.ImageList, diagnostics, System.Notification;

type
  TfrmPrincipal = class(TForm)
    prb: TProgressBar;
    dsFuncionario: TDataSource;
    btn1: TButton;
    il1: TImageList;
    pb1: TProgressBar;
    NotificationCenter1: TNotificationCenter;
    dsGradPresencial: TDataSource;
    dsPosEad: TDataSource;
    dsPosPresencial: TDataSource;
    dsPosPresencialCG: TDataSource;
    Label1: TLabel;
    dsGradEAD: TDataSource;
    dsGradPreseCG: TDataSource;
    procedure FormCreate(Sender: TObject);
    procedure Banco01;
    procedure Banco02;
    procedure Banco03;
    procedure Banco04;
    procedure Banco05;
    procedure Banco06;
    procedure Banco07;//carrega os Funcionários e Visitantes
    procedure ApagaBanco;
    procedure btn1Click(Sender: TObject);

  private
  SW: TStopwatch;
  procedure Notificar(Mensagem: String);

    { Private declarations }
  public
    { Public declarations }
  end;

var
  frmPrincipal: TfrmPrincipal;


implementation

{$R *.dfm}

uses ufrmMenu, UDM_WiFi, UDM;


procedure TfrmPrincipal.FormCreate(Sender: TObject);
begin

   DM := TDM.Create(Self);
   Self.dsGradEAD.DataSet := DM.FDQGradEAD;
   Self.dsGradPresencial.DataSet := DM.FDQ_GradPres;
   Self.dsGradPreseCG.DataSet := DM.FDQ_GradPresCG;
   Self.dsPosPresencial.DataSet := DM.FDQ_PosPresDdos;
   Self.dsPosPresencialCG.DataSet := DM.FDQ_PosPresCG;
   Self.dsPosEad.DataSet := DM.FDQ_PosEAD;


// Banco WIFI
   DM_WIFI := TDM_WIFI.Create(Self);
   Self.dsFuncionario.DataSet := DM_WIFI.FDQFunc;



   SW := TstopWatch.Create;

end;


procedure TfrmPrincipal.Notificar(Mensagem :String);
var
 Notificacao : TNotification;
begin
 Notificacao := TNotification.Create;
 Notificacao.Title := 'Sicronizador';
 Notificacao.AlertBody := Mensagem;
 NotificationCenter1.PresentNotification(Notificacao);
 Notificacao.Free;
end;

procedure TfrmPrincipal.ApagaBanco;
begin
  try
    DM_WiFi.sqlRadcheck.Execute;
    DM_WIFI.sqlRadusergroup.Execute;
  except
    ShowMessage('Um erro foi Detectado! ');
  end;
end;

procedure TfrmPrincipal.btn1Click(Sender: TObject);
begin
  prb.Min := 0;
  prb.Max := 7;

 ApagaBanco;  // deleta radcheck e radusergroup


  try
    Banco01;
    prb.Position := prb.Position + 1;
  except
    ShowMessage('Erro Banco 01 - Graduaçăo EAD');
  end;


  try
    Banco02;
    prb.Position := prb.Position +1;
  except
    ShowMessage('Erro Banco 02 - Graduaçăo Presencial Ddos');
 end;



  try
    Banco03;
    prb.Position := prb.Position +1;
  except
    ShowMessage('Erro Banco 03 - Graduaçăo Presencial CG');
  end;


  try
    Banco04;
    prb.Position := prb.Position +1;
  except
    ShowMessage('Erro Banco 04 - Pós EAD Ddos');
  end;


  try
    Banco05;
    prb.Position := prb.Position +1;
  except
    ShowMessage('Erro Banco 05 - Pós Presencial Ddos');
  end;

  try
    Banco06;
    prb.Position := prb.Position +1;
  except
    ShowMessage('Erro Banco 06 - Pós Presencial CG');
  end;

  try
    Banco07;
    prb.Position := prb.Position +1;
  except
    ShowMessage('Erro Banco 07 - Funcionarios e Professores');
  end;

  prb.Max := 0;

end;



//***********************Grad EAD

procedure TfrmPrincipal.Banco01;
var id : integer;
begin


   if dsGradEAD.DataSet.State = dsInactive then
   Begin
    dsGradEAD.DataSet.Open;
   End;


  pb1.Position := 0;
  pb1.Max := dsGradEAD.DataSet.RecordCount;
  Application.ProcessMessages;



   DM_WiFi.sqlId.Close;
   DM_WiFi.sqlId.Open;
   id := DM_WIFI.sqlIDmaxid.AsInteger+1;


  if DM_WiFi.dsGrupo.DataSet.State = dsInactive then
  begin
    DM_WiFi.dsGrupo.DataSet.Open;
  end;

  if DM_WiFi.dsUserSenha.DataSet.State = dsInactive then
  begin
    DM_WiFi.dsUserSenha.DataSet.Open
  end;

  try
    dsGradEAD.DataSet.First;
    while not dsGradEAD.DataSet.Eof do
    begin
      //insere GRUPO
      DM_WiFi.dsGrupo.DataSet.Insert;
      DM_WIFI.FDQGrupo.FieldByName('username').AsString := dsGradEAD.DataSet.FieldByName('rgm').AsString;
      DM_WIFI.FDQGrupo.FieldByName('groupname').AsString := 'wireless';
      DM_WIFI.FDQGrupo.FieldByName('priority').AsString := '1';
      DM_WiFi.dsGrupo.DataSet.Post;

      // Insere usuario
      DM_WiFi.dsUserSenha.DataSet.Insert;
      DM_WIFI.FDQUser_Senha.FieldByName('id').AsInteger := id;
      DM_WIFI.FDQUser_Senha.FieldByName('username').AsString := dsGradEAD.DataSet.FieldByName('rgm').AsString;
      DM_WIFI.FDQUser_Senha.FieldByName('attribute').AsString := 'Cleartext-Password';
      DM_WIFI.FDQUser_Senha.FieldByName('op').AsString := ':=';
      DM_WIFI.FDQUser_Senha.FieldByName('value').AsString := dsGradEAD.DataSet.FieldByName('senha').AsString;
      DM_WiFi.dsUserSenha.DataSet.Post;
      Label1.Caption := 'Banco 1 - Graduaçăo EAD';


      dsGradEAD.DataSet.Next;
      pb1.Position := pb1.Position + 1;
      inc(id); // := id+1;
      Application.ProcessMessages;
    end;
   except
    ShowMessage('Um erro foi Detectado! Graduaçăo EAD ');
  end;
end;

//*********************Grad Presencial Ddos

procedure TfrmPrincipal.Banco02;
var id : Integer;
begin

  if dsGradPresencial.DataSet.State = dsInactive then
   Begin
    dsGradPresencial.DataSet.Open;
   End;


  pb1.Position := 0;
  pb1.Max := dsGradPresencial.DataSet.RecordCount;
  Application.ProcessMessages;


     DM_WiFi.sqlID.Close;
     DM_WIFI.sqlID.Open;
     id := DM_WIFI.sqlIDmaxid.AsInteger+1;

  if DM_WiFi.dsGrupo.DataSet.State = dsInactive then
  begin
    DM_WiFi.dsGrupo.DataSet.Open;
  end;

  if DM_WiFi.dsUserSenha.DataSet.State = dsInactive then
  begin
    DM_WiFi.dsUserSenha.DataSet.Open
  end;

  try
    dsGradPresencial.DataSet.First;
    while not dsGradPresencial.DataSet.Eof do
    begin

      //insere GRUPO
      DM_WiFi.dsGrupo.DataSet.Insert;
      DM_WIFI.FDQGrupo.FieldByName('username').AsString := dsGradPresencial.DataSet.FieldByName('rgm').AsString;
      DM_WIFI.FDQGrupo.FieldByName('groupname').AsString := 'wireless';
      DM_WIFI.FDQGrupo.FieldByName('priority').AsString := '1';
      DM_WiFi.dsGrupo.DataSet.Post;


      //Insere usuario
      DM_WiFi.dsUserSenha.DataSet.Insert;
      DM_WIFI.FDQUser_Senha.FieldByName('id').AsInteger := id;
      DM_WIFI.FDQUser_Senha.FieldByName('username').AsString := dsGradPresencial.DataSet.FieldByName('rgm').AsString;
      DM_WIFI.FDQUser_Senha.FieldByName('attribute').AsString := 'Cleartext-Password';
      DM_WIFI.FDQUser_Senha.FieldByName('op').AsString := ':=';
      DM_WIFI.FDQUser_Senha.FieldByName('value').AsString := dsGradPresencial.DataSet.FieldByName('senha').AsString;
      DM_WiFi.dsUserSenha.DataSet.Post;
      Label1.Caption := 'Banco 2 - Presencial Dourados';

      dsGradPresencial.DataSet.Next;
      pb1.Position := pb1.Position + 1;
      Application.ProcessMessages;
      inc(id); // := id+1;
    end;
  except
      ShowMessage('Um erro foi Detectado! - Presencial Dourados ');
  end;
end;


//*******************************Presencial CG

procedure TfrmPrincipal.Banco03;
var id : integer;
    rgmt :string;
begin


 if dsGradPreseCG.DataSet.State = dsInactive then
   Begin
    dsGradPreseCG.DataSet.Open;
   End;


  pb1.Position := 0;
  pb1.Max := dsGradPreseCG.DataSet.RecordCount;
  Application.ProcessMessages;


  DM_WIFI.sqlID.Close;
  DM_WIFI.sqlID.Open;
  id := DM_WIFI.sqlIDmaxid.AsInteger+1;


  if DM_WiFi.dsGrupo.DataSet.State = dsInactive then
  begin
    DM_WiFi.dsGrupo.DataSet.Open;
  end;

  if DM_WiFi.dsUserSenha.DataSet.State = dsInactive then
  begin
    DM_WiFi.dsUserSenha.DataSet.Open
  end;

   try
    dsGradPreseCG.DataSet.First;

    while not dsGradPreseCG.DataSet.Eof do
    begin
      //insere GRUPO
      DM_WiFi.dsGrupo.DataSet.Insert;
//      DM_WIFI.FDQGrupo.FieldByName('username').AsString := dsGradPreseCG.DataSet.FieldByName('rgm').Value;
      DM_WIFI.FDQGrupo.FieldByName('username').AsString := StringReplace(dsGradPreseCG.DataSet.FieldByName('rgm').AsString,'.','',[rfReplaceAll]);
      DM_WIFI.FDQGrupo.FieldByName('groupname').AsString := 'wireless';
      DM_WIFI.FDQGrupo.FieldByName('priority').AsString := '1';
      DM_WiFi.dsGrupo.DataSet.Post;

      // Insere usuario
      DM_WiFi.dsUserSenha.DataSet.Insert;
      DM_WIFI.FDQUser_Senha.FieldByName('id').AsInteger := id;
//      DM_WIFI.FDQUser_Senha.FieldByName('username').AsString := dsGradPreseCG.DataSet.FieldByName('rgm').AsString;
      DM_WIFI.FDQUser_Senha.FieldByName('username').AsString := StringReplace(dsGradPreseCG.DataSet.FieldByName('rgm').AsString,'.','',[rfReplaceAll]);
      DM_WIFI.FDQUser_Senha.FieldByName('attribute').AsString := 'Cleartext-Password';
      DM_WIFI.FDQUser_Senha.FieldByName('op').AsString := ':=';
      DM_WIFI.FDQUser_Senha.FieldByName('value').AsString := dsGradPreseCG.DataSet.FieldByName('senha').AsString;
      DM_WiFi.dsUserSenha.DataSet.Post;
      Label1.Caption := 'Banco 3 - Presencial CG';

      dsGradPreseCG.DataSet.Next;
      pb1.Position := pb1.Position + 1;
      Application.ProcessMessages;
      inc(id);  // := id+1;
     end;
    except
      ShowMessage('Um erro foi Detectado! - Presencial CG ');
   end;
 end;


//*************************Pós em EAD

procedure TfrmPrincipal.Banco04;
var id : Integer;
begin

   if dsPosEad.DataSet.State = dsInactive then
   Begin
    dsPosEad.DataSet.Open;
   End;


  pb1.Position := 0;
  pb1.Max := dsPosEad.DataSet.RecordCount;
  Application.ProcessMessages;

  DM_WIFI.sqlID.Close;
  DM_WIFI.sqlID.Open;
  id := DM_WIFI.sqlIDmaxid.AsInteger+1;

  if DM_WiFi.dsGrupo.DataSet.State = dsInactive then
  begin
    DM_WiFi.dsGrupo.DataSet.Open;
  end;

  if DM_WiFi.dsUserSenha.DataSet.State = dsInactive then
  begin
    DM_WiFi.dsUserSenha.DataSet.Open
  end;

  try
    dsPosEad.DataSet.First;
    while not dsPosEad.DataSet.Eof do
    begin
      //insere GRUPO
      DM_WiFi.dsGrupo.DataSet.Insert;
      DM_WIFI.FDQGrupo.FieldByName('username').AsString := dsPosEad.DataSet.FieldByName('rgm').AsString;
      DM_WIFI.FDQGrupo.FieldByName('groupname').AsString := 'wireless';
      DM_WIFI.FDQGrupo.FieldByName('priority').AsString := '1';
      DM_WiFi.dsGrupo.DataSet.Post;

      // Insere usuario
      DM_WiFi.dsUserSenha.DataSet.Insert;
      DM_WIFI.FDQUser_Senha.FieldByName('id').AsInteger := id;
      DM_WIFI.FDQUser_Senha.FieldByName('username').AsString := dsPosEad.DataSet.FieldByName('rgm').AsString;
      DM_WIFI.FDQUser_Senha.FieldByName('attribute').AsString := 'Cleartext-Password';
      DM_WIFI.FDQUser_Senha.FieldByName('op').AsString := ':=';
      DM_WIFI.FDQUser_Senha.FieldByName('value').AsString := dsPosEad.DataSet.FieldByName('senha').AsString;
      DM_WiFi.dsUserSenha.DataSet.Post;
      Label1.Caption := 'Banco 4 - Pós EAD';

      dsPosEad.DataSet.Next;
      pb1.Position := pb1.Position + 1;
      inc(id); // := id+1;
      Application.ProcessMessages;
    end;
  except
    ShowMessage('Um erro foi Detectado! - Pós EAD ');
  end;
end;

//****************Pós presencial

procedure TfrmPrincipal.Banco05;
var id : Integer;
begin

 if dsPosPresencial.DataSet.State = dsInactive then
   Begin
    dsPosPresencial.DataSet.Open;
   End;


  pb1.Position := 0;
  pb1.Max := dsPosPresencial.DataSet.RecordCount;
  Application.ProcessMessages;



  DM_WIFI.sqlID.Close;
  DM_WIFI.sqlID.Open;
  id := DM_WIFI.sqlIDmaxid.AsInteger+1;


  if DM_WiFi.dsGrupo.DataSet.State = dsInactive then
  begin
    DM_WiFi.dsGrupo.DataSet.Open;
  end;

  if DM_WiFi.dsUserSenha.DataSet.State = dsInactive then
  begin
    DM_WiFi.dsUserSenha.DataSet.Open
  end;

  try
    dsPosPresencial.DataSet.First;
    while not dsPosPresencial.DataSet.Eof do
    begin
      //insere GRUPO
      DM_WiFi.dsGrupo.DataSet.Insert;
      DM_WIFI.FDQGrupo.FieldByName('username').AsString := dsPosPresencial.DataSet.FieldByName('rgm').AsString;
      DM_WIFI.FDQGrupo.FieldByName('groupname').AsString := 'wireless';
      DM_WIFI.FDQGrupo.FieldByName('priority').AsString := '1';
      DM_WiFi.dsGrupo.DataSet.Post;

      // Insere usuario
      DM_WiFi.dsUserSenha.DataSet.Insert;
      DM_WIFI.FDQUser_Senha.FieldByName('id').AsInteger := id;
      DM_WIFI.FDQUser_Senha.FieldByName('username').AsString := dsPosPresencial.DataSet.FieldByName('rgm').AsString;
      DM_WIFI.FDQUser_Senha.FieldByName('attribute').AsString := 'Cleartext-Password';
      DM_WIFI.FDQUser_Senha.FieldByName('op').AsString := ':=';
      DM_WIFI.FDQUser_Senha.FieldByName('value').AsString := dsPosPresencial.DataSet.FieldByName('senha').AsString;
      DM_WiFi.dsUserSenha.DataSet.Post;
      Label1.Caption := 'Banco 5 - Pós Presencial';

      dsPosPresencial.DataSet.Next;
      pb1.Position := pb1.Position + 1;
      inc(id); // := id+1;
      Application.ProcessMessages;
    end;
  except
    ShowMessage('Um erro foi Detectado! - Pós Presencial ');
  end;
end;

//**********************Pós presencial CG

procedure TfrmPrincipal.Banco06;
var id : Integer;
begin

   if dsPosPresencialCG.DataSet.State = dsInactive then
   Begin
    dsPosPresencialCG.DataSet.Open;
   End;


  pb1.Position := 0;
  pb1.Max := dsPosPresencialCG.DataSet.RecordCount;
  Application.ProcessMessages;

  DM_WIFI.sqlID.Close;
  DM_WIFI.sqlID.Open;
  id := DM_WIFI.sqlIDmaxid.AsInteger+1;


  if DM_WiFi.dsGrupo.DataSet.State = dsInactive then
  begin
    DM_WiFi.dsGrupo.DataSet.Open;
  end;

  if DM_WiFi.dsUserSenha.DataSet.State = dsInactive then
  begin
    DM_WiFi.dsUserSenha.DataSet.Open
  end;

  try
    dsPosPresencialCG.DataSet.First;
    while not dsPosPresencialCG.DataSet.Eof do
    begin
      //insere GRUPO
      DM_WiFi.dsGrupo.DataSet.Insert;
//      DM_WIFI.FDQGrupo.FieldByName('username').AsString := dsPosPresencialCG.DataSet.FieldByName('rgm').AsString;
      DM_WIFI.FDQGrupo.FieldByName('username').AsString := StringReplace(dsPosPresencialCG.DataSet.FieldByName('rgm').AsString,'.','',[rfReplaceAll]);
      DM_WIFI.FDQGrupo.FieldByName('groupname').AsString := 'wireless';
      DM_WIFI.FDQGrupo.FieldByName('priority').AsString := '1';
      DM_WiFi.dsGrupo.DataSet.Post;

      // Insere usuario
      DM_WiFi.dsUserSenha.DataSet.Insert;
      DM_WIFI.FDQUser_Senha.FieldByName('id').AsInteger := id;
//      Self.dmConectaWIFI.cdsUserSenha.FieldByName('username').AsString := dsPosPresencialCG.DataSet.FieldByName('rgm').AsString;
      DM_WIFI.FDQUser_Senha.FieldByName('username').AsString := StringReplace(dsPosPresencialCG.DataSet.FieldByName('rgm').AsString,'.','',[rfReplaceAll]);
      DM_WIFI.FDQUser_Senha.FieldByName('attribute').AsString := 'Cleartext-Password';
      DM_WIFI.FDQUser_Senha.FieldByName('op').AsString := ':=';
      DM_WIFI.FDQUser_Senha.FieldByName('value').AsString := dsPosPresencialCG.DataSet.FieldByName('senha').AsString;
      DM_WiFi.dsUserSenha.DataSet.Post;
      Label1.Caption := 'Banco 6 - Pós Presencia CG';

      dsPosPresencialCG.DataSet.Next;
      pb1.Position := pb1.Position + 1;
      Application.ProcessMessages;
      inc(id); // := id + 1;
    end;
  except
    ShowMessage('Um erro foi Detectado! - Pós Presencial CG ');
  end;
end;


procedure TfrmPrincipal.Banco07;// Professores, Funcionários e Visitantes
var id : Integer;
begin
  id:=0;

  if DM_WiFi.DsFunc.DataSet.State = dsInactive then
   Begin
    DM_WiFi.DsFunc.DataSet.Open;
   End;




  DM_WIFI.sqlID.Close;
  DM_WIFI.sqlID.Open;
  id := DM_WIFI.sqlIDmaxid.AsInteger+1;

  if DM_WiFi.dsGrupo.DataSet.State = dsInactive then
  begin
    DM_WiFi.dsGrupo.DataSet.Open;
  end;


  if DM_WiFi.dsUserSenha.DataSet.State = dsInactive then
  begin
    DM_WiFi.dsUserSenha.DataSet.Open
  end;

  DM_WiFi.DsFunc.DataSet.First;

  while not DM_WiFi.DsFunc.DataSet.Eof do
  begin
    if DM_WiFi.DsFunc.DataSet.FieldByName('status').AsString = 'A' then
    begin
      if DM_WiFi.DsFunc.DataSet.FieldByName('tipo').AsString <> 'V' then // Professor e Funcionario se năo for visitante
      begin
        try
          //insere GRUPO
          DM_WiFi.dsGrupo.DataSet.Insert;
          DM_WIFI.FDQGrupo.FieldByName('username').AsString := IntToStr(DM_WiFi.DsFunc.DataSet.FieldByName('codigo').AsInteger);
          DM_WIFI.FDQGrupo.FieldByName('groupname').AsString := 'wireless';
          DM_WIFI.FDQGrupo.FieldByName('priority').AsString := '1';
          DM_WiFi.dsGrupo.DataSet.Post;
        except
          messagedlg('Erro ao salvar dados, erro: Grupo 01020 !',mterror,[mbOK],0);
        end;

        try
          // Insere usuario
          DM_WiFi.dsUserSenha.DataSet.Insert;
          DM_WIFI.FDQUser_Senha.FieldByName('id').AsInteger := id;
          DM_WIFI.FDQUser_Senha.FieldByName('username').AsString := IntToStr(DM_WiFi.DsFunc.DataSet.FieldByName('codigo').AsInteger);
          DM_WIFI.FDQUser_Senha.FieldByName('attribute').AsString := 'Cleartext-Password';
          DM_WIFI.FDQUser_Senha.FieldByName('op').AsString := ':=';
          DM_WIFI.FDQUser_Senha.FieldByName('value').AsString := DM_WiFi.DsFunc.DataSet.FieldByName('senha').AsString;
          DM_WiFi.dsUserSenha.DataSet.Post;

          inc(id);
//          dsUserSenha.DataSet.Close;
          Label1.Caption := 'Banco 7 - Funcionários/Professores';
         except
          messagedlg('Erro ao salvar dados, erro: usuário 01021 !',mterror,[mbOK],0);
        end;
      end

      else if DM_WiFi.DsFunc.DataSet.FieldByName('tipo').AsString = 'V' then // Visitante se for visitante
      begin
        DM_WIFI.sqlData.Close;
        DM_WIFI.sqlData.Open;

        begin
          try
            //insere GRUPO
            DM_WiFi.dsGrupo.DataSet.Insert;
            DM_WIFI.FDQGrupo.FieldByName('username').AsString := IntToStr(DM_WiFi.DsFunc.DataSet.FieldByName('codigo').AsInteger);
            DM_WIFI.FDQGrupo.FieldByName('groupname').AsString := 'wireless';
            DM_WIFI.FDQGrupo.FieldByName('priority').AsString := '1';
            DM_WiFi.dsGrupo.DataSet.Post;

  //          dsGrupo.DataSet.Close;
          except
            messagedlg('Erro ao salvar dados, erro: Grupo 01020 !',mterror,[mbOK],0);
          end;

          try
            // Insere usuario
            DM_WiFi.dsUserSenha.DataSet.Insert;
            DM_WIFI.FDQUser_Senha.FieldByName('id').AsInteger := id;
            DM_WIFI.FDQUser_Senha.FieldByName('username').AsString := IntToStr(DM_WiFi.DsFunc.DataSet.FieldByName('codigo').AsInteger);
            DM_WIFI.FDQUser_Senha.FieldByName('attribute').AsString := 'Cleartext-Password';
            DM_WIFI.FDQUser_Senha.FieldByName('op').AsString := ':=';
            DM_WIFI.FDQUser_Senha.FieldByName('value').AsString := DM_WiFi.DsFunc.DataSet.FieldByName('senha').AsString;
            DM_WiFi.dsUserSenha.DataSet.Post;
            inc(id);
    //        dsUserSenha.DataSet.Close;
            Label1.Caption := 'Banco 7 - Visitantes';

          except
            messagedlg('Erro ao salvar dados, erro: usuário 01021 !',mterror,[mbOK],0);
          end;
        end;
      end;
    end;
    DM_WiFi.DsFunc.DataSet.Next;
  end;
  ShowMessage('Fim do processo de atualizaçăo!!!!');
end;

end.
