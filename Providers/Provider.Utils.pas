unit Provider.Utils;

interface

procedure WriteLNColor(Text: String; Color: Word);

implementation

uses Winapi.Windows;

procedure WriteLNColor(Text: String; Color: Word);
var
  ConsoleHandle : THandle;
  BufInfo : TConsoleScreenBufferInfo;
begin

  ConsoleHandle := TTextRec(Output).Handle;

  GetConsoleScreenBufferInfo( ConsoleHandle, BufInfo );

  SetConsoleTextAttribute(ConsoleHandle, FOREGROUND_INTENSITY or Color);

  WriteLN(Text);

  SetConsoleTextAttribute(ConsoleHandle, BufInfo.wAttributes);


end;

end.
