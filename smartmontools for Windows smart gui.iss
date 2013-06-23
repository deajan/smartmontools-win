// GUI configuration page for smart options v6.1-2

[code]
procedure smartd_conf_Activate(Page: TWizardPage);
begin
end;
  
function smartd_conf_ShouldSkipPage(Page: TWizardPage): Boolean;
begin
  Result := False;
end;
  
function smartd_conf_BackButtonClick(Page: TWizardPage): Boolean;
begin
  Result := True;
end;
  
function smartd_conf_NextButtonClick(Page: TWizardPage): Boolean;
begin
  Result := True;
end;
  
procedure smartd_conf_CancelButtonClick(Page: TWizardPage; var Cancel, Confirm: Boolean);
begin
end;
  

function smartd_conf_CreatePage(PreviousPageId: Integer): Integer;
var
  Page: TWizardPage;
begin
  Page := CreateCustomPage(
    PreviousPageId,
    ExpandConstant('{cm:smartd_confCaption}'),
    ExpandConstant('{cm:smartd_confDescription}')
  );

  //// Radio buttons for hdd autodetection / manuallist
  guihddautodetection := TNewCheckListBox.Create(Page);
  guihddautodetection.Top := ScaleY(0);
  guihddautodetection.Width := ScaleX(170);
  guihddautodetection.Height := ScaleY(50);
  guihddautodetection.BorderStyle := bsNone;
  guihddautodetection.ParentColor := True;
  //guihddautodetection.MinItemHeight := WizardForm.TasksList.MinItemHeight;
  guihddautodetection.ShowLines := False;
  guihddautodetection.WantTabs := True;
  guihddautodetection.Parent := Page.Surface;
  guihddautodetection.AddRadioButton(ExpandConstant('{cm:hddautodetection}'), '', 0, hddautodetection, True, nil);
  guihddautodetection.AddRadioButton(ExpandConstant('{cm:hddmanuallist}'), '', 0, not hddautodetection, True, nil);
  guihddautodetection.TabOrder := 0;
  
  { guihddlist }
  guihddlist := TMemo.Create(Page);
  with guihddlist do
  begin
    Parent := Page.Surface;
    Left := ScaleX(186);
    Top := ScaleY(0);
    Width := ScaleX(211);
    Height := ScaleY(33);
    ScrollBars := ssVertical;
    TabOrder := 1;
    if (hddautodetection = false) then
      Text := Implode(hddlistexploded, #13#10)
    else
      Text := '/dev/csmi0,0  <--- example' + #13#10 + '/dev/csmi0,1';
  end;
  
  { guilongtesthour }
  guilongtesthour := TComboBox.Create(Page);
  with guilongtesthour do
  begin
    Parent := Page.Surface;
    Left := ScaleX(186);
    Top := ScaleY(32);
    Width := ScaleX(41);
    Height := ScaleY(21);
    TabOrder := 2;
    Text := '12';
    Items.Add('00');      Items.Add('01');      Items.Add('02');      Items.Add('03');
    Items.Add('04');      Items.Add('05');      Items.Add('06');      Items.Add('07');
    Items.Add('08');      Items.Add('09');      Items.Add('10');      Items.Add('11');
    Items.Add('12');      Items.Add('13');      Items.Add('14');      Items.Add('15');
    Items.Add('16');      Items.Add('17');      Items.Add('18');      Items.Add('19');
    Items.Add('20');      Items.Add('21');      Items.Add('22');      Items.Add('23');
  end;

    
  { LMonday }
  LMonday := TCheckBox.Create(Page);
  with LMonday do
  begin
    Parent := Page.Surface;
    Left := ScaleX(8);
    Top := ScaleY(56);
    Width := ScaleX(49);
    Height := ScaleY(17);
    Caption := ExpandConstant('{cm:mon}');
    Checked := False;
    TabOrder := 3;
    
  end;  
  { LTuesday }
  LTuesday := TCheckBox.Create(Page);
  with LTuesday do
  begin
    Parent := Page.Surface;
    Left := ScaleX(64);
    Top := ScaleY(56);
    Width := ScaleX(49);
    Height := ScaleY(17);
    Caption := ExpandConstant('{cm:tue}');
    Checked := False;
    TabOrder := 4;
  end;
  
  { LWednesday }
  LWednesday := TCheckBox.Create(Page);
  with LWednesday do
  begin
    Parent := Page.Surface;
    Left := ScaleX(120);
    Top := ScaleY(56);
    Width := ScaleX(49);
    Height := ScaleY(17);
    Caption := ExpandConstant('{cm:wed}');
    Checked := False;
    TabOrder := 5;
  end;
    
  { LThursday }
  LThursday := TCheckBox.Create(Page);
  with LThursday do
  begin
    Parent := Page.Surface;
    Left := ScaleX(176);
    Top := ScaleY(56);
    Width := ScaleX(49);
    Height := ScaleY(17);
    Caption := ExpandConstant('{cm:thu}');
    Checked := False;
    TabOrder := 6;
  end;
    
  { LFriday }
  LFriday := TCheckBox.Create(Page);
  with LFriday do
  begin
    Parent := Page.Surface;
    Left := ScaleX(232);
    Top := ScaleY(56);
    Width := ScaleX(65);
    Height := ScaleY(17);
    Caption := ExpandConstant('{cm:fri}');
    Checked := True;
    State := cbChecked;
    TabOrder := 7;
  end;
    
  { LSaturday }
  LSaturday := TCheckBox.Create(Page);
  with LSaturday do
  begin
    Parent := Page.Surface;
    Left := ScaleX(288);
    Top := ScaleY(56);
    Width := ScaleX(57);
    Height := ScaleY(17);
    Caption := ExpandConstant('{cm:sat}');
    Checked := False;
    TabOrder := 8;
  end;
    
  { LSunday }
  LSunday := TCheckBox.Create(Page);
  with LSunday do
  begin
    Parent := Page.Surface;
    Left := ScaleX(344);
    Top := ScaleY(56);
    Width := ScaleX(73);
    Height := ScaleY(17);
    Caption := ExpandConstant('{cm:sun}');
    Checked := False;
    TabOrder := 9;
  end;

  { guishorttesthour }
  guishorttesthour := TComboBox.Create(Page);
  with guishorttesthour do
  begin
    Parent := Page.Surface;
    Left := ScaleX(186);
    Top := ScaleY(80);
    Width := ScaleX(41);
    Height := ScaleY(21);
    TabOrder := 10;
    Text := '08';
    Items.Add('00');      Items.Add('01');      Items.Add('02');      Items.Add('03');
    Items.Add('04');      Items.Add('05');      Items.Add('06');      Items.Add('07');
    Items.Add('08');      Items.Add('09');      Items.Add('10');      Items.Add('11');
    Items.Add('12');      Items.Add('13');      Items.Add('14');      Items.Add('15');
    Items.Add('16');      Items.Add('17');      Items.Add('18');      Items.Add('19');
    Items.Add('20');      Items.Add('21');      Items.Add('22');      Items.Add('23');
  end;
    
  { SMonday }
  SMonday := TCheckBox.Create(Page);
  with SMonday do
  begin
    Parent := Page.Surface;
    Left := ScaleX(8);
    Top := ScaleY(104);
    Width := ScaleX(49);
    Height := ScaleY(17);
    Caption := ExpandConstant('{cm:mon}');
    Checked := True;
    State := cbChecked;
    TabOrder := 11;
  end;
    
  { STuesday }
  STuesday := TCheckBox.Create(Page);
  with STuesday do
  begin
    Parent := Page.Surface;
    Left := ScaleX(64);
    Top := ScaleY(104);
    Width := ScaleX(49);
    Height := ScaleY(17);
    Caption := ExpandConstant('{cm:tue}');
    Checked := True;
    State := cbChecked;
    TabOrder := 12;
  end;
    
  { SWednesday }
  SWednesday := TCheckBox.Create(Page);
  with SWednesday do
  begin
    Parent := Page.Surface;
    Left := ScaleX(120);
    Top := ScaleY(104);
    Width := ScaleX(49);
    Height := ScaleY(17);
    Caption := ExpandConstant('{cm:wed}');
    Checked := True;
    State := cbChecked;
    TabOrder := 13;
  end;
    
  { SThursday }
  SThursday := TCheckBox.Create(Page);
  with SThursday do
  begin
    Parent := Page.Surface;
    Left := ScaleX(176);
    Top := ScaleY(104);
    Width := ScaleX(49);
    Height := ScaleY(17);
    Caption := ExpandConstant('{cm:thu}');
    Checked := True;
    State := cbChecked;
    TabOrder := 14;
  end;
    
  { SFriday }
  SFriday := TCheckBox.Create(Page);
  with SFriday do
  begin
    Parent := Page.Surface;
    Left := ScaleX(232);
    Top := ScaleY(104);
    Width := ScaleX(49);
    Height := ScaleY(17);
    Caption := ExpandConstant('{cm:fri}');
    Checked := True;
    State := cbChecked;
    TabOrder := 15;
  end;
    
  { SSaturday }
  SSaturday := TCheckBox.Create(Page);
  with SSaturday do
  begin
    Parent := Page.Surface;
    Left := ScaleX(288);
    Top := ScaleY(104);
    Width := ScaleX(49);
    Height := ScaleY(17);
    Caption := ExpandConstant('{cm:sat}');
    Checked := True;
    State := cbChecked;
    TabOrder := 16;
  end;
    
  { SSunday }
  SSunday := TCheckBox.Create(Page);
  with SSunday do
  begin
    Parent := Page.Surface;
    Left := ScaleX(344);
    Top := ScaleY(104);
    Width := ScaleX(57);
    Height := ScaleY(17);
    Caption := ExpandConstant('{cm:sun}');
    Checked := True;
    State := cbChecked;
    TabOrder := 17;
  end;
  
  { guicheckhealth }
  guicheckhealth := TCheckBox.Create(Page);
  with guicheckhealth do
  begin
    Parent := Page.Surface;
    Left := ScaleX(8);
    Top := ScaleY(128);
    Width := ScaleX(121);
    Height := ScaleY(17);
    Caption := ExpandConstant('{cm:checkhealth}');
    Checked := checkhealth;
    TabOrder := 18;
  end;

  { guicheckataerrors }
  guicheckataerrors := TCheckBox.Create(Page);
  with guicheckataerrors do
  begin
    Parent := Page.Surface;
    Left := ScaleX(8);
    Top := ScaleY(144);
    Width := ScaleX(185);
    Height := ScaleY(17);
    Caption := ExpandConstant('{cm:checkataerrors}');
    Checked := checkataerrors;
    TabOrder := 19;
  end;
  
  { guireportselftesterrors }
  guireportselftesterrors := TCheckBox.Create(Page);
  with guireportselftesterrors do
  begin
    Parent := Page.Surface;
    Left := ScaleX(8);
    Top := ScaleY(160);
    Width := ScaleX(185);
    Height := ScaleY(17);
    Caption := ExpandConstant('{cm:reportselftesterrors}');
    Checked := reportselftesterrors;
    TabOrder := 20;
  end;
    
  { guicheckfailureusage }
  guicheckfailureusage := TCheckBox.Create(Page);
  with guicheckfailureusage do
  begin
    Parent := Page.Surface;
    Left := ScaleX(8);
    Top := ScaleY(176);
    Width := ScaleX(185);
    Height := ScaleY(17);
    Caption := ExpandConstant('{cm:checkfailureusage}');
    Checked := checkfailureusage;
    TabOrder := 21;
  end;
    
  { guireportcurrentpendingsect }
  guireportcurrentpendingsect := TCheckBox.Create(Page);
  with guireportcurrentpendingsect do
  begin
    Parent := Page.Surface;
    Left := ScaleX(192);
    Top := ScaleY(128);
    Width := ScaleX(217);
    Height := ScaleY(17);
    Caption := ExpandConstant('{cm:reportcurrentpendingsect}');
    Checked := reportcurrentpendingsect;
    TabOrder := 22;
  end;

  { guireportofflinependingsect }
  guireportofflinependingsect := TCheckBox.Create(Page);
  with guireportofflinependingsect do
  begin
    Parent := Page.Surface;
    Left := ScaleX(192);
    Top := ScaleY(144);
    Width := ScaleX(217);
    Height := ScaleY(17);
    Caption := ExpandConstant('{cm:reportofflinependingsect}');
    Checked := reportofflinependingsect;
    TabOrder := 23;
  end;
    
  { guitrackchangesusageprefail }
  guitrackchangesusageprefail := TCheckBox.Create(Page);
  with guitrackchangesusageprefail do
  begin
    Parent := Page.Surface;
    Left := ScaleX(192);
    Top := ScaleY(160);
    Width := ScaleX(217);
    Height := ScaleY(17);
    Caption := ExpandConstant('{cm:trackchangeusageprefail}');
    Checked := trackchangeusageprefail;
    TabOrder := 24;
  end;
    
  { guiignoretemperature }
  guiignoretemperature := TCheckBox.Create(Page);
  with guiignoretemperature do
  begin
    Parent := Page.Surface;
    Left := ScaleX(192);
    Top := ScaleY(176);
    Width := ScaleX(217);
    Height := ScaleY(17);
    Caption := ExpandConstant('{cm:ignoretemperature}');
    Checked := ignoretemperature;
    TabOrder := 25;
  end;

  
  { guipowermode }
  guipowermode := TComboBox.Create(Page);
  with guipowermode do
  begin
    Parent := Page.Surface;
    Left := ScaleX(8);
    Top := ScaleY(208);
    Width := ScaleX(145);
    Height := ScaleY(21);
    TabOrder := 26;
    Text := powermode;
    Items.Add('never');
    Items.Add('sleep');
    Items.Add('standby');
    Items.Add('idle');
  end;
    
  { guimaxskiptests }
  guimaxskiptests := TComboBox.Create(Page);
  with guimaxskiptests do
  begin
    Parent := Page.Surface;
    Left := ScaleX(192);
    Top := ScaleY(208);
    Width := ScaleX(33);
    Height := ScaleY(21);
    TabOrder := 27;
    Text := maxskiptests;
    Items.Add('1');  Items.Add('2');  Items.Add('3');  Items.Add('4');
    Items.Add('5');  Items.Add('6');  Items.Add('7');  Items.Add('8');
    Items.Add('9');  Items.Add('10'); Items.Add('11'); Items.Add('12');
    Items.Add('13'); Items.Add('14'); Items.Add('15'); Items.Add('16');
    Items.Add('17'); Items.Add('18'); Items.Add('19'); Items.Add('20');
    Items.Add('21'); Items.Add('22'); Items.Add('23'); Items.Add('24');
    Items.Add('25'); Items.Add('26'); Items.Add('27'); Items.Add('28');
    Items.Add('29'); Items.Add('30'); Items.Add('31');
  end;    


//////////////////////////////////////////////////////////// STATIC TEXT

  { statictext5 }
  statictext5 := TNewStaticText.Create(Page);
  with statictext5 do
  begin
    Parent := Page.Surface;
    Left := ScaleX(8);
    Top := ScaleY(192);
    Width := ScaleX(171);
    Height := ScaleY(14);
    Caption := ExpandConstant('{cm:powermode}');
  end;
    
  { statictext6 }
  statictext6 := TNewStaticText.Create(Page);
  with statictext6 do
  begin
    Parent := Page.Surface;
    Left := ScaleX(192);
    Top := ScaleY(192);
    Width := ScaleX(203);
    Height := ScaleY(14);
    Caption := ExpandConstant('{cm:maxskips}');
  end;
     
  { statictext7 }
  statictext7 := TNewStaticText.Create(Page);
  with statictext7 do
  begin
    Parent := Page.Surface;
    Left := ScaleX(232);
    Top := ScaleY(212);
    Width := ScaleX(65);
    Height := ScaleY(14);
    Caption := ExpandConstant('{cm:skippedtests}');
  end;

 { statictext1 }
  statictext1 := TNewStaticText.Create(Page);
  with statictext1 do
  begin
    Parent := Page.Surface;
    Left := ScaleX(8);
    Top := ScaleY(36);
    Width := ScaleX(95);
    Height := ScaleY(14);
    Caption := ExpandConstant('{cm:longtestat}');
    Font.Color := -16777208;
    Font.Height := ScaleY(-11);
    Font.Name := 'Tahoma';
    Font.Style := [fsBold];
    ParentFont := False;
  end;
    
  { statictext2 }
  statictext2 := TNewStaticText.Create(Page);
  with statictext2 do
  begin
    Parent := Page.Surface;
    Left := ScaleX(232);
    Top := ScaleY(36);
    Width := ScaleX(62);
    Height := ScaleY(14);
    Caption := ExpandConstant('{cm:honevery}');
    Font.Color := -16777208;
    Font.Height := ScaleY(-11);
    Font.Name := 'Tahoma';
    Font.Style := [fsBold];
    ParentFont := False;
  end;
   
  { statictext3 }
  statictext3 := TNewStaticText.Create(Page);
  with statictext3 do
  begin
    Parent := Page.Surface;
    Left := ScaleX(8);
    Top := ScaleY(84);
    Width := ScaleX(102);
    Height := ScaleY(14);
    Caption := ExpandConstant('{cm:shorttestat}');
    Font.Color := -16777208;
    Font.Height := ScaleY(-11);
    Font.Name := 'Tahoma';
    Font.Style := [fsBold];
    ParentFont := False;
  end;
    
  { statictext4 }
  statictext4 := TNewStaticText.Create(Page);
  with statictext4 do
  begin
    Parent := Page.Surface;
    Left := ScaleX(232);
    Top := ScaleY(84);
    Width := ScaleX(62);
    Height := ScaleY(14);
    Caption := ExpandConstant('{cm:honevery}');
    Font.Color := -16777208;
    Font.Height := ScaleY(-11);
    Font.Name := 'Tahoma';
    Font.Style := [fsBold];
    ParentFont := False;
  end;   
  
  with Page do
  begin
    OnActivate := @smartd_conf_Activate;
    OnShouldSkipPage := @smartd_conf_ShouldSkipPage;
    OnBackButtonClick := @smartd_conf_BackButtonClick;
    OnNextButtonClick := @smartd_conf_NextButtonClick;
    OnCancelButtonClick := @smartd_conf_CancelButtonClick;
  end;
 
  Result := Page.ID;
end;
