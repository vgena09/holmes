unit MABOUT;

interface

uses
  Winapi.Windows, Winapi.Messages,
  System.SysUtils, System.Variants, System.Classes,
  Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.ExtCtrls, Vcl.StdCtrls;

type
  TFABOUT = class(TForm)
    BtnOk: TButton;
    Img: TImage;
    LCaption: TLabel;
    LVersion: TLabel;
    LAuthor: TLabel;
    LContact: TLabel;
    Bevel4: TBevel;
    Label1: TLabel;
    procedure FormCreate(Sender: TObject);
  private

  public

  end;

var
  FABOUT: TFABOUT;

implementation

uses FunConst, FunSys, FunInfo, FunIni;

{$R *.dfm}

procedure TFABOUT.FormCreate(Sender: TObject);
begin
    LVersion.Caption := 'Версия программы: '+GetProgProductVersion;
    LAuthor.Caption  := 'Автор идеи и разработчик:'+CH_NEW+
                        'Вертинский Геннадий Эдуардович'+CH_NEW+
                        '+375-29-325-20-30'+CH_NEW+
                        'gena09@mail.ru'+CH_NEW;
    LContact.Caption := 'Поддержка программы:'+CH_NEW+
                        Trim(ReadGlobalString(GINI_SET, GINI_SET_CONTACT, ''));
end;

end.
