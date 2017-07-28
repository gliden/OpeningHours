program OpeningHours;

uses
  Vcl.Forms,
  OpeningHoursFrm in 'OpeningHoursFrm.pas' {Form2},
  OpeningHoursLib in '..\lib\OpeningHoursLib.pas',
  DayLib in '..\lib\DayLib.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TForm2, Form2);
  Application.Run;
end.
