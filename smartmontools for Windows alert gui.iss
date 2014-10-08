// GUI configuration page for alert options for v6.3-1

[code]
procedure mail_options_Activate(Page: TWizardPage);
begin
end;
  
function mail_options_ShouldSkipPage(Page: TWizardPage): Boolean;
begin
  Result := False;
end;
  
function mail_options_BackButtonClick(Page: TWizardPage): Boolean;
begin
  Result := True;
end;
  
function mail_options_NextButtonClick(Page: TWizardPage): Boolean;
begin
  Result := True;
end;
  
procedure mail_options_CancelButtonClick(Page: TWizardPage; var Cancel, Confirm: Boolean);
begin
end;


function mail_options_CreatePage(PreviousPageId: Integer): Integer;
var
  Page: TWizardPage;
begin
  Page := CreateCustomPage(
    PreviousPageId,
    ExpandConstant('{cm:mail_optionsCaption}'),
    ExpandConstant('{cm:mail_optionsDescription}')
  );

/////////////////////////////////////////////////////////////// INPUT BOXES

  { guiwarningmessage }
  guiwarningmessage := TMemo.Create(Page);
  with guiwarningmessage do
  begin
    Parent := Page.Surface;
    Left := ScaleX(8);
    Top := ScaleY(18);
    Width := ScaleX(400);
    Height := ScaleY(48);
    ScrollBars := ssVertical;
    TabOrder := 1;
    Text := warningmessage;
    Enabled := IsComponentSelected('core\service\localsupport') or IsComponentSelected('core\service\mailsupport');
  end;

  { guilocalmessages }
  guilocalmessages := TCheckBox.Create(Page);
  with guilocalmessages do
  begin
    Parent := Page.Surface;
    Left := ScaleX(8);
    Top := ScaleY(70);
    Width := ScaleX(200);
    Height := ScaleY(17);
    Caption := ExpandConstant('{cm:localmessages}');
    Checked := (localmessages or IsComponentSelected('core\service\localsupport'))
    TabOrder := 1;
    Enabled := IsComponentSelected('core\service\localsupport');
  end;

  { guikeepfirstlog }
  guikeepfirstlog := TCheckBox.Create(Page);
  with guikeepfirstlog do
  begin
    Parent := Page.Surface;
    Left := ScaleX(224);
    Top := ScaleY(70);
    Width := ScaleX(200);
    Height := ScaleY(17);
    Caption := Expandconstant('{cm:keepfirstlog}');
    Checked := keepfirstlog;
    TabOrder := 2;
  end;

  { guisourcemail }
  guisourcemail := TEdit.Create(Page);
  with guisourcemail do
  begin
    Parent := Page.Surface;
    Left := ScaleX(24);
    Top := ScaleY(104);
    Width := ScaleX(169);
    Height := ScaleY(21);
    TabOrder := 3;
    Text := sourcemail;
    Enabled := IsComponentSelected('core\service\mailsupport');
  end;

  { guidestinationmail }
  guidestinationmail := TEdit.Create(Page);
  with guidestinationmail do
  begin
    Parent := Page.Surface;
    Left := ScaleX(24);
    Top := ScaleY(144);
    Width := ScaleX(169);
    Height := ScaleY(21);
    TabOrder := 4;
    Text := destinationmail;
    Enabled := IsComponentSelected('core\service\mailsupport');
  end;
  
  { guismtpserver }
  guismtpserver := TEdit.Create(Page);
  with guismtpserver do
  begin
    Parent := Page.Surface;
    Left := ScaleX(24);
    Top := ScaleY(184);
    Width := ScaleX(129);
    Height := ScaleY(21);
    TabOrder := 5;
    Text := smtpserver;
    Enabled := IsComponentSelected('core\service\mailsupport');
  end;

  { guismtpport }
  guismtpport := TEdit.Create(Page);
  with guismtpport do
  begin
    Parent := Page.Surface;
    Left := ScaleX(155);
    Top := ScaleY(184);
    Width := ScaleX(38);
    Height := ScaleY(21);
    TabOrder := 6;
    Text := smtpport;
    Enabled := IsComponentSelected('core\service\mailsupport');
  end;

  { guisecurity }
  guisecurity := TComboBox.Create(Page);
  with guisecurity do
  begin
    Parent := Page.Surface;
    Left := ScaleX(224);
    Top := ScaleY(104);
    Width := ScaleX(169);
    Height := ScaleY(21);
    TabOrder := 7;
    Text := security;
    Items.Add('none');
    Items.Add('tls');
    Items.Add('ssl');
    Enabled := IsComponentSelected('core\service\mailsupport');
  end;
  
  { guismtpserveruser }
  guismtpserveruser := TEdit.Create(Page);
  with guismtpserveruser do
  begin
    Parent := Page.Surface;
    Left := ScaleX(224);
    Top := ScaleY(144);
    Width := ScaleX(169);
    Height := ScaleY(21);
    TabOrder := 8;
    Text := smtpserveruser;
    Enabled := IsComponentSelected('core\service\mailsupport');
  end;
  
  { guismtpserverpass }
  guismtpserverpass := TPasswordEdit.Create(Page);
  with guismtpserverpass do
  begin
    Parent := Page.Surface;
    Left := ScaleX(224);
    Top := ScaleY(184);
    Width := ScaleX(169);
    Height := ScaleY(21);
    TabOrder := 9;
    Text := smtpserverpass;
    Enabled := IsComponentSelected('core\service\mailsupport');
  end;
  
  { guicompresslogs }
  guicompresslogs := TCheckBox.Create(Page);
  with guicompresslogs do
  begin
    Parent := Page.Surface;
    Left := ScaleX(24);
    Top := ScaleY(208);
    Width := ScaleX(250);
    Height := ScaleY(17);
    Caption := ExpandConstant('{cm:compresslogs}');
    Checked := compresslogs;
    TabOrder := 10;
    Enabled := IsComponentSelected('core\service\mailsupport');
  end;
  
  { guiselectmailer }
  guiselectmailer := TComboBox.Create(Page);
  with guiselectmailer do
  begin
    Parent := Page.Surface;
    Left := ScaleX(200);
    Top := ScaleY(209);
    Width := ScaleX(70);
    Height := ScaleY(21);
    TabOrder := 7;
    Text := mailer;
    Items.Add('mailsend');
    Items.Add('sendemail');
    Enabled := IsComponentSelected('core\service\mailsupport');
  end;
      
  { guisendtestmessage }
  guisendtestmessage := TButton.Create(Page);
  with guisendtestmessage do
  begin
    Parent := Page.Surface;
    Left := ScaleX(274);
    Top := ScaleY(208);
    Width := ScaleX(120);
    Height := ScaleY(23);
    Caption := ExpandConstant('{cm:sendtestmessage}');
    TabOrder := 11;
    OnClick := @SendTest;
    Enabled := IsComponentSelected('core\service\mailsupport');
  end;

/////////////////////////////////////////////////////////////// STATIC TEXT

  { statictext107 }
  statictext107 := TNewStaticText.Create(Page);
  with statictext107 do
  begin
    Parent := Page.Surface;
    Left := ScaleX(8);
    Top := ScaleY(0);
    Width := ScaleX(166);
    Height := ScaleY(14);
    Caption := ExpandConstant('{cm:warningmessagecustom}');
    Enabled := IsComponentSelected('core\service\mailsupport') or IsComponentSelected('core\service\localsupport');
  end;

  { statictext106 }
  statictext106 := TNewStaticText.Create(Page);
  with statictext106 do
  begin
    Parent := Page.Surface;
    Left := ScaleX(224);
    Top := ScaleY(168);
    Width := ScaleX(166);
    Height := ScaleY(14);
    Caption := ExpandConstant('{cm:smtpserverpass}');
    Enabled := IsComponentSelected('core\service\mailsupport');
  end;
  
  { statictext105 }
  statictext105 := TNewStaticText.Create(Page);
  with statictext105 do
  begin
    Parent := Page.Surface;
    Left := ScaleX(224);
    Top := ScaleY(128);
    Width := ScaleX(142);
    Height := ScaleY(14);
    Caption := ExpandConstant('{cm:smtpserveruser}');
    Enabled := IsComponentSelected('core\service\mailsupport');
  end;
    
  { statictext101 }
  statictext101 := TNewStaticText.Create(Page);
  with statictext101 do
  begin
    Parent := Page.Surface;
    Left := ScaleX(24);
    Top := ScaleY(88);
    Width := ScaleX(102);
    Height := ScaleY(14);
    Caption := ExpandConstant('{cm:sourcemailaddress}');
    Enabled := IsComponentSelected('core\service\mailsupport');
  end;
    
  { statictext103 }
  statictext103 := TNewStaticText.Create(Page);
  with statictext103 do
  begin
    Parent := Page.Surface;
    Left := ScaleX(24);
    Top := ScaleY(168);
    Width := ScaleX(40);
    Height := ScaleY(14);
    Caption := ExpandConstant('{cm:smtpserver}');
    Enabled := IsComponentSelected('core\service\mailsupport');
  end;

  { statictextport }
  statictextport := TNewStaticText.Create(Page);
  with statictextport do
  begin
    Parent := Page.Surface;
    Left := ScaleX(155);
    Top := ScaleY(168);
    Width := ScaleX(40);
    Height := ScaleY(14);
    Caption := ExpandConstant('{cm:smtpport}');
    Enabled := IsComponentSelected('core\service\mailsupport');
  end;
    
  { statictext102 }
  statictext102 := TNewStaticText.Create(Page);
  with statictext102 do
  begin
    Parent := Page.Surface;
    Left := ScaleX(24);
    Top := ScaleY(128);
    Width := ScaleX(123);
    Height := ScaleY(14);
    Caption := ExpandConstant('{cm:destinationmailaddress}');
    Enabled := IsComponentSelected('core\service\mailsupport');
  end;
  
  { statictextmailer }
  statictextmailer := TNewStaticText.Create(Page);
  with statictextmailer do
  begin
    Parent := Page.Surface;
    Left := ScaleX(166);
    Top := ScaleY(212);
    Width := ScaleX(123);
    Height := ScaleY(14);
    Caption := 'Mailer';
    Enabled := IsComponentSelected('core\service\mailsupport');
  end;
    
  { statictext104 }
  statictext104 := TNewStaticText.Create(Page);
  with statictext104 do
  begin
    Parent := Page.Surface;
    Left := ScaleX(224);
    Top := ScaleY(88);
    Width := ScaleX(18);
    Height := ScaleY(14);
    Caption := ExpandConstant('{cm:security}');;
    //Font.Color := -16777208;
    //Font.Height := ScaleY(-11);
    //Font.Name := 'Tahoma';
    //ParentFont := False;
    Enabled := IsComponentSelected('core\service\mailsupport');
  end;

    
  
  with Page do
  begin
    OnActivate := @mail_options_Activate;
    OnShouldSkipPage := @mail_options_ShouldSkipPage;
    OnBackButtonClick := @mail_options_BackButtonClick;
    OnNextButtonClick := @mail_options_NextButtonClick;
    OnCancelButtonClick := @mail_options_CancelButtonClick;
  end;
  
  Result := Page.ID;
end;
  
// Wizard exeuction hook
//procedure InitializeWizard();
//begin
//  if (WizardSilent = false) then
//  begin
//    smartd_conf_CreatePage(wpInfoAfter);
//    mail_options_CreatePage(wpInfoAfter);
//  end;
//end;