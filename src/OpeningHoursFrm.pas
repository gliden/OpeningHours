unit OpeningHoursFrm;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, OpeningHoursLib;

type
  TForm2 = class(TForm)
    Button1: TButton;
    Memo1: TMemo;
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure Button1Click(Sender: TObject);
  private
    { Private-Deklarationen }
    hourList: TOpeningList;
    procedure SetUp;
  public
    { Public-Deklarationen }
  end;

var
  Form2: TForm2;

implementation

uses
  DayLib;

{$R *.dfm}

procedure TForm2.Button1Click(Sender: TObject);
begin
  Memo1.Text := hourList.ToSmallList;
end;

procedure TForm2.FormCreate(Sender: TObject);
begin
  hourList := TOpeningList.Create;
  SetUp;
end;

procedure TForm2.FormDestroy(Sender: TObject);
begin
  hourList.Free;
end;

procedure TForm2.SetUp;
var
  i: Integer;
begin
  for i := 1 to 5 do
  begin
    hourList.Add(TDay.IndexToDay(i), StrToTime('08:00'), StrToTime('12:30'));
    if i <> 3 then hourList.Add(TDay.IndexToDay(i), StrToTime('13:00'), StrToTime('18:00'));
  end;
  hourList.Add(TDay.Saturday, StrToTime('10:00'), StrToTime('14:00'));
  hourList.Add(TDay.Sunday, StrToTime('10:00'), StrToTime('14:00'));
end;

end.
