unit Unit1;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, StdCtrls, ExtCtrls,
  Menus, TAGraph, TASources, TATransformations, tcp_udpport, ISOTCPDriver,
  PLCBlock, PLCBlockElement, TagBit, HMILabel, HMICheckBox, TASeries, TAChartUtils;

type

  { TForm1 }

  TForm1 = class(TForm)
    Button1: TButton;
    Button2: TButton;
    Chart1: TChart;
    Chart1LineSeries1: TLineSeries;
    Chart1LineSeries4: TLineSeries;
    Chart1LineSeries5: TLineSeries;
    ChartAxisTransformations1: TChartAxisTransformations;
    ChartAxisTransformations1LinearAxisTransform1: TLinearAxisTransform;
    HMICheckBox1: THMICheckBox;
    HMICheckBox2: THMICheckBox;
    HMICheckBox3: THMICheckBox;
    HMICheckBox4: THMICheckBox;
    HMICheckBox5: THMICheckBox;
    HMILabel1: THMILabel;
    HMILabel2: THMILabel;
    ISOTCPDriver1: TISOTCPDriver;
    ListChartSource1: TListChartSource;
    ListChartSource5: TListChartSource;
    ListChartSource6: TListChartSource;
    MB: TPLCBlock;
    MB0: TPLCBlockElement;
    MB0_bit0: TTagBit;
    MB0_bit1: TTagBit;
    MB0_bit2: TTagBit;
    MB0_bit3: TTagBit;
    MB0_bit4: TTagBit;
    MB0_bit5: TTagBit;
    MB0_bit6: TTagBit;
    MB0_bit7: TTagBit;
    MB0_bit8: TTagBit;
    MB_: TPLCBlock;
    MB_100: TPLCBlockElement;
    Memo1: TMemo;
    MenuItem1: TMenuItem;
    MenuItem2: TMenuItem;
    PopupMenu1: TPopupMenu;
    TCP_UDPPort1: TTCP_UDPPort;
    Timer1: TTimer;
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure Chart1Click(Sender: TObject);
    procedure Chart1DragOver(Sender, Source: TObject; X, Y: Integer;
      State: TDragState; var Accept: Boolean);
    procedure Chart1MouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure FormCreate(Sender: TObject);
    procedure MenuItem1Click(Sender: TObject);
    procedure MenuItem2Click(Sender: TObject);
    procedure Timer1Timer(Sender: TObject);
  private

  public
    Function CheckFile(C_DNAME: string; C_FNAME: string; Debug_:TMemo):boolean;
    Function CheckDirectory(C_DNAME: string;Debug_:TMemo):boolean;
  end;

var
  Form1: TForm1;
  FileName_: string;
  Directory_:string;

implementation

{$R *.lfm}

{ TForm1 }

Function TForm1.CheckFile(C_DNAME: string; C_FNAME: string; Debug_:TMemo):boolean; //True=Error
var
  tfOut: TextFile;
begin
  result:= false;

  if(C_DNAME<>'')then
  if Not DirectoryExists(C_DNAME) Then
  begin
    {$I-}
    //{$I-} or {$IOCHECKS OFF}
    //{$I-} rewrite (f); {$I+}
    //if IOResult<>0 then begin Writeln ('Error opening file: "file.txt"'); exit; end;
    mkdir(C_DNAME);
    {$I+}
    if IOResult<>0 then
    begin
      Debug_.Append('Directory '+C_DNAME+' error occurred. Details: '+ EInOutError.ClassName);
      ShowMessage('Cannot create '+C_DNAME+' directory. Details: '+ EInOutError.ClassName);
      result:= true;
    end;
  end;

  if(C_FNAME<>'')then
  if DirectoryExists(C_DNAME) Then
  If Not FileExists(C_FNAME) Then
  begin
    AssignFile(tfOut, C_FNAME);
    {$I+}
    try
      rewrite(tfOut);
      CloseFile(tfOut);
    except
      on E: EInOutError do
      begin
        Debug_.Append('File '+C_FNAME+' handling error occurred. Details: '+ EInOutError.ClassName);
        showmessage('File '+C_FNAME+' handling error occurred. Details: '+ E.ClassName+ '/'+ E.Message);
        result:= true;
      end;
    end;
  end;

end;

Function TForm1.CheckDirectory(C_DNAME: string;Debug_:TMemo):boolean; //True=Error
var
  tfOut: TextFile;
begin
  result:= false;

  if(C_DNAME<>'')then
  if Not DirectoryExists(C_DNAME) Then
  begin
    {$I-}
    //{$I-} or {$IOCHECKS OFF}
    //{$I-} rewrite (f); {$I+}
    //if IOResult<>0 then begin Writeln ('Error opening file: "file.txt"'); exit; end;
    mkdir(C_DNAME);
    {$I+}
    if IOResult<>0 then
    begin
      Debug_.Append('Directory '+C_DNAME+' error occurred. Details: '+ EInOutError.ClassName);
      ShowMessage('Cannot create '+C_DNAME+' directory. Details: '+ EInOutError.ClassName);
      result:= true;
    end;
  end;

end;

procedure TForm1.Button1Click(Sender: TObject);
var
  i:integer;
begin
  TCP_UDPPort1.ExclusiveDevice:=True;
    for i := 0 to 1000 do
    begin
      application.ProcessMessages;
    end;
    TCP_UDPPort1.Active:=True;
end;

procedure TForm1.Button2Click(Sender: TObject);
var
  i:integer;
begin
  TCP_UDPPort1.Active:=false;
    for i := 0 to 1000 do
    begin
      application.ProcessMessages;
    end;
    TCP_UDPPort1.ExclusiveDevice:=false;
end;

procedure TForm1.Chart1Click(Sender: TObject);
begin
  Chart1.Tag :=1;
end;

procedure TForm1.Chart1DragOver(Sender, Source: TObject; X, Y: Integer;
  State: TDragState; var Accept: Boolean);
begin
  Chart1.Tag :=1;
end;

procedure TForm1.Chart1MouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  Chart1.Tag :=1;
end;

procedure TForm1.FormCreate(Sender: TObject);
begin

  Directory_:=FormatDateTime('MM YYYY',Now); FileName_:= Directory_+'\'+FormatDateTime('DD MM YYYY',Now)+'.CSV';
  if CheckDirectory(Directory_,Memo1) then begin Application.Terminate; end;

  Memo1.Append('Directory ='+Directory_);
  Memo1.Append('FileName ='+FileName_);

  Chart1.Tag:=0;
end;

procedure TForm1.MenuItem1Click(Sender: TObject);
var
  AC: TDoublePoint;
  AZ: TDoubleRect;
begin
  AC:=Chart1.LogicalExtent.a;
  AC.X:=AC.X-1;
  AC.Y:=AC.Y-1;
  AZ.a:=AC;
  AC:=Chart1.LogicalExtent.b;
  AC.X:=AC.X+1;
  AC.Y:=AC.Y+1;
  AZ.b:=AC;
  Chart1.LogicalExtent:=AZ;
end;

procedure TForm1.MenuItem2Click(Sender: TObject);
begin
  Chart1.Tag:=0;
end;

procedure TForm1.Timer1Timer(Sender: TObject);
var
  i:integer;
  //MaxRecordTime:integer;
  //Txt:String;
  fileout : TextFile;
  S_Name:string;
  File_OK:Boolean;

  MaxRecordTime:integer;
  Txt:String;
begin
  //if not TCP_UDPPort1.Active then exit;
  if (FormatDateTime('MM YYYY',Now)<>Directory_) then
  begin
    Directory_:=FormatDateTime('MM YYYY',Now); FileName_:= Directory_+'\'+FormatDateTime('DD MM YYYY',Now)+'.CSV';
  end;
  if CheckDirectory(Directory_,Memo1) then begin Application.Terminate; end;

  S_Name:=Directory_+'\'+FormatDateTime('DD MM YYYY',Now)+'.CSV';
  i:=0;
  File_OK:=True;

  try
    AssignFile(fileout, S_Name);
  except
    on E: EInOutError do
    begin
      //showmessage('AssignFile: '+E.ClassName+'/'+ E.Message+'/'+IntToStr(E.ErrorCode));
      File_OK:=False;
    end;
  end;

  //if File_OK then showmessage('File_OK=OK');
  //if not File_OK then showmessage('File_OK=not OK');
  //Timer3.Enabled:=False;

  while((File_OK = False) and (i<100)) do
  begin
    i:=i+1;
    S_Name:=Directory_+'\'+FormatDateTime('DD MM YYYY',Now)+'_'+IntToStr(i)+'.CSV';
    File_OK:=True;
    try
      AssignFile(fileout, S_Name);
    except
      on E: EInOutError do
      begin
        //showmessage('AssignFile: '+E.ClassName+'/'+ E.Message+'/'+IntToStr(E.ErrorCode));
        File_OK:=False;
      end;
    end;
  end;

   try
     Append(fileout);
   except
     //on E: EInOutError do
     //showmessage('Append: '+E.ClassName+'/'+ E.Message+'/'+IntToStr(E.ErrorCode));
     on E: EInOutError do
     try
       rewrite (fileout);
       writeln(fileout, 'Date,Time,Piovan Silo Actual[%],Silo 01 Actual[%],Silo 02 Actual[%],Rotary01(N2)[Start/Stop],Rotary01(N2)[Fault/NotFault]');
     except
       //on E: EInOutError do
       //showmessage('Append: '+E.ClassName+'/'+ E.Message+'/'+IntToStr(E.ErrorCode));
     end;
   end;

   try         //FloatToStr(Int(Random(1*10)))
     //writeln(fileout, FormatDateTime('DD/MM/YYYY',Now)+','+FormatDateTime('hh:nn:ss',Now)+','+FormatFloat('####0.00',DB3_DBD12.Value)+','+FormatFloat('####0.00',DB3_DBD30.Value)+','+FormatFloat('####0.00',DB24_DBD62.Value)+','+FloatToStr(Q1_7.Value)+','+FloatToStr(I7_0.Value));
     writeln(fileout, FormatDateTime('DD/MM/YYYY',Now)+','+FormatDateTime('hh:nn:ss',Now)+','+FormatFloat('####0.00',Int(Random(1*10)))+','+FormatFloat('####0.00',Int(Random(1*10)))+','+FormatFloat('####0.00',Int(Random(1*10)))+','+FloatToStr(Int(Random(1*10)))+','+FloatToStr(Int(Random(1*10))));
     CloseFile(fileout);
   except
     //on E: EInOutError do
     //showmessage('Append: '+E.ClassName+'/'+ E.Message+'/'+IntToStr(E.ErrorCode));
   end;

   Randomize();

MaxRecordTime:=60*60*12;
  if ListChartSource1.Count >= MaxRecordTime then
  begin
    for i:=0 to MaxRecordTime-2 do
    begin
      ListChartSource1.Item[i]^.Y:=ListChartSource1.Item[i+1]^.Y;
      ListChartSource1.Item[i]^.Text:=ListChartSource1.Item[i+1]^.Text;

      ListChartSource5.Item[i]^.Y:=ListChartSource5.Item[i+1]^.Y;
      ListChartSource5.Item[i]^.Text:=ListChartSource5.Item[i+1]^.Text;

      ListChartSource6.Item[i]^.Y:=ListChartSource6.Item[i+1]^.Y;
      ListChartSource6.Item[i]^.Text:=ListChartSource6.Item[i+1]^.Text;

    end;
    ListChartSource1.Delete(MaxRecordTime-1);
    ListChartSource5.Delete(MaxRecordTime-1);
    ListChartSource6.Delete(MaxRecordTime-1);
  end;


Txt:=FormatDateTime('hh',  Now)+':'+FormatDateTime('nn',  Now)+':'+FormatDateTime('ss',  Now);

if ListChartSource1.Count < MaxRecordTime then ListChartSource1.Add(ListChartSource1.Count,Int(Random(1*100)),Txt,clBlue);    //Chart1 Silo Piovan
    if ListChartSource5.Count < MaxRecordTime then ListChartSource5.Add(ListChartSource5.Count,Int(Random(1*100)),Txt,clOlive); //Chart1 Silo1
    if ListChartSource6.Count < MaxRecordTime then ListChartSource6.Add(ListChartSource6.Count,Int(Random(1*100)),Txt,clRed);   //Chart1 Silo2

If (ListChartSource1.Count>240) and (Chart1.Tag = 0) then
  begin
    Chart1.BottomAxis.Range.Max:=ListChartSource1.Count;
    //Chart1.BottomAxis.Range.UseMax:=True;
    Chart1.BottomAxis.Range.Min:=ListChartSource1.Count-240;
    //Chart1.BottomAxis.Range.UseMin:=True;
    Chart1.Extent.XMin:=ListChartSource1.Count-240;  Chart1.Extent.XMax:=ListChartSource1.Count;
  end;
  If (ListChartSource1.Count<=240) and (Chart1.Tag = 0) then
  begin
    if(ListChartSource1.Count<=60)then
    Chart1.BottomAxis.Range.Max:=60;
    if(ListChartSource1.Count>60)then
    Chart1.BottomAxis.Range.Max:=ListChartSource1.Count;
    Chart1.BottomAxis.Range.Min:=0;
    Chart1.Extent.XMin:=0;
    if(ListChartSource1.Count<=60)then
    Chart1.Extent.XMax:=60;
    if(ListChartSource1.Count>60)then
    Chart1.Extent.XMax:=ListChartSource1.Count;
  end;
end;

end.

