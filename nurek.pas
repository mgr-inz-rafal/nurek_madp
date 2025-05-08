//{$define romoff}
{$define basicoff}

uses crt, graph, math, joystick, cmc, atari;

const
  NurekData: array[0..607] of BYTE = (
    0,0,0,0,0,0,0,0,2,2,2,2,2,0,0,0,0,0,0,
    0,0,0,0,0,0,2,2,0,0,0,0,0,2,2,0,0,0,0,
    0,0,0,0,0,2,0,0,0,0,0,0,0,0,0,2,0,0,0,
    0,0,0,0,2,0,0,0,0,0,0,0,0,0,0,0,2,0,0,
    0,0,0,2,0,0,0,0,0,0,0,1,0,0,0,0,0,1,0,
    0,0,0,2,0,0,0,0,1,0,1,0,0,1,1,0,0,2,0,
    0,0,2,0,0,0,0,1,0,1,1,1,1,0,1,1,0,0,2,
    0,0,2,0,0,0,0,1,1,0,0,0,1,1,0,0,0,0,2,
    0,0,2,0,0,0,0,1,0,0,0,0,0,1,1,1,0,0,2,
    0,0,2,0,0,0,1,0,0,0,0,0,0,0,1,1,1,1,2,
    0,0,2,0,0,0,1,0,2,0,0,0,0,0,1,1,0,0,2,
    0,0,0,2,0,0,1,0,0,0,0,0,0,0,1,1,0,1,0,
    0,0,0,2,0,0,1,0,0,0,0,0,0,0,1,0,0,2,0,
    0,0,0,0,2,0,0,1,0,0,0,0,0,1,0,0,2,0,0,
    0,0,0,0,0,2,0,1,1,1,1,1,1,1,0,2,0,0,0,
    0,0,0,0,0,0,2,1,1,1,1,1,1,1,2,0,0,0,0,
    0,0,0,0,0,0,0,1,1,1,1,1,1,1,0,0,0,0,0,
    0,0,0,0,0,0,0,0,1,1,1,1,1,0,0,0,0,0,0,
    0,0,0,0,0,0,0,0,1,1,1,1,1,0,0,0,0,0,0,
    0,0,0,0,0,0,0,0,1,1,1,1,1,0,0,0,0,0,0,
    0,0,0,0,0,0,0,0,1,1,1,1,1,0,0,0,0,0,0,
    0,0,0,0,0,0,0,0,1,1,1,1,1,0,0,0,0,0,0,
    1,1,1,0,0,0,0,0,1,1,1,1,1,0,0,0,0,0,0,
    0,0,1,1,1,0,0,0,1,1,1,1,1,0,0,0,0,0,0,
    0,0,0,0,1,1,1,1,1,1,1,1,1,0,0,0,0,0,0,
    0,0,0,0,0,0,0,1,1,1,1,1,1,1,0,0,0,0,0,
    0,0,0,0,0,0,0,1,0,0,0,0,0,1,0,0,0,0,0,
    0,0,0,0,0,0,1,1,0,0,0,0,0,1,1,0,0,0,0,
    0,0,0,0,0,1,1,0,0,0,0,0,0,0,1,0,0,0,0,
    0,0,0,0,0,1,0,0,0,0,0,0,0,0,1,1,0,0,0,
    0,0,0,0,1,1,0,0,0,0,0,0,0,0,0,1,1,0,0,
    0,1,1,1,1,0,0,0,0,0,0,1,1,1,1,1,1,0,0
  );
  AngleStep: SINGLE = 0.008726646;
  ChujExtraction: BYTE = 0;
  ChujContraction: BYTE = 1;
  ChujBlocked: BYTE = 2;
	cmc_player = $2afb;
	cmc_modul = $2000;  
  ChujStartPos: BYTE = 140;
	dl_game: array [0..94] of byte =
	(
     $70, $70, $70,                                          
     %11110000,                                         

     $4d, $60, $b0,

     $0d, $0d, $0d, $0d, $0d, $0d, $0d, $0d, $0d, $0d,
     $0d, $0d, $0d, $0d, $0d, $0d, $0d, $0d, $0d, $0d,
     $0d, $0d, $0d, $0d, $0d, $0d, $0d, $0d, $0d,
     %10001101,
     $0d, $0d, $0d, $0d, $0d, $0d, $0d, $0d, $0d, $0d,
     $0d, $0d, $0d, $0d, $0d, $0d, $0d, $0d, $0d, $0d,
     $0d, $0d, $0d, $0d, $0d, $0d, $0d, $0d, $0d, 
     %10001101,
     $0d, $0d, $0d, $0d, $0d, $0d, $0d, $0d, $0d, $0d,
     $0d, $0d, $0d, $0d, $0d, $0d, $0d, $0d, 
     %10001101,

     $42, $60, $bf,
     $02, $02, $02,

     %01000001,                                         
     lo(word(@dl_game)), hi(word(@dl_game))
	);  
  
  //CHARSET_TILE_ADDRESS = $ac00;
  CHARSET_TILE_ADDRESS = $a800; // Higher mem is occupied (DL @ AFA2).

  ST_EXPANSJA = 0;
  ST_KONTRAKCJA = 1;
  ST_DNO = 2;
  ST_CIERPIENIE = 3;
  ST_KRUTKI = 4;
  ST_DUGI = 5;
  ST_PLANSZA = 6;
  ST_LODZIK = 7;
  ST_KAMIEN = 8;
  ST_JAJCO = 9;
  ST_KAMIEN_FINAL = 10;

var
	msx: TCMC;  
  dlist: word absolute 560;
  text_y: byte absolute 656;
  text_x: byte absolute 657;
  plansza: byte;
  rzydz: byte;
  punkty: word;
  statuses: array[0..10] of ShortString = (
      'Status proncia: ' + ' EXPANSJA '*,
      'Status proncia: ' + ' KONTRAKCJA '*,
      'Osi'#17'gn'#17''#123'e'#23' dno, kontraktuj!',
      'Na powierzchni tylko cierpienie...',
      'Osi'#17'gni'#4'to limit kr'#16'tko'#23'ci penisa',
      'Za dugi huj, kurcz si'#4'',
      'Nie wolno wyje'#24'd'#24'a'#22' z planszy!',
      'Jes zakas smyrania w'#123'asnego cia'#123'a',
      'Smyrni'#4'to kamie'#13', to b'#123''#17'd... Cofaj!',
      ' Dinojajco zap'#123'odnione, amen! '*,
      'Smyrni'#4'to kamie'#13', to b'#123''#17'd...!'
      );
  last_status: byte;
  just_hit_kamien: boolean;

{$r 'cmc_play.rc'}  
{$r 'charset.rc'}  

type
  ChujMoveOutcome = (Extracted, TooLong, TooShort, HitBottom, Contracted, Surfaced, OutOfAkwen, AutoBlow, HitKamien, HitJajco);

type
  Game = Object
    chuj_c: SINGLE;
    chuj_s: BYTE;
    chuj_p: WORD;
    chuj_history_x: array[0..299] of SINGLE;
    chuj_history_y: array[0..299] of SINGLE;
    chuj_history_a: array[0..299] of SINGLE;
    chuj_history_grid: array[0..79, 0..79] of BYTE;
    constructor Build;
    function MoveChuj: ChujMoveOutcome;
    procedure DrawChuj;
    procedure ChujLeft;
    procedure ChujRight;
    procedure ChujProstowac;
    function GetNibble(x, y: Byte): Byte;
    procedure SetNibble(x, y: Byte; value: Byte);
    procedure IncrementNibble(x, y: Byte);
    function DecrementNibble(x, y: Byte): BYTE;
  end;

function Game.GetNibble(x, y: Byte): Byte;
var
  index, offset: Byte;
begin
  index := x div 2;
  offset := x mod 2;
  
  if offset = 0 then
    Result := chuj_history_grid[index, y] and $0F
  else
    Result := (chuj_history_grid[index, y] shr 4) and $0F;
end;

procedure Game.SetNibble(x, y: Byte; value: Byte);
var
  index, offset: Byte;
begin
  index := x div 2;
  offset := x mod 2;
  value := value and $0F;
  
  if offset = 0 then
    chuj_history_grid[index, y] := (chuj_history_grid[index, y] and $F0) or value
  else
    chuj_history_grid[index, y] := (chuj_history_grid[index, y] and $0F) or (value shl 4);
end;

procedure Game.IncrementNibble(x, y: Byte);
var
  currentValue: Byte;
begin
  currentValue := Game.GetNibble(x, y);
  Game.SetNibble(x, y, currentValue + 1);
end;

function Game.DecrementNibble(x, y: Byte): BYTE;
var
  currentValue: Byte;
begin
  currentValue := Game.GetNibble(x, y);
  
  if currentValue > 0 then
  begin
    currentValue := currentValue - 1;
    Game.SetNibble(x, y, currentValue);
  end;
  
  Result := currentValue;
end;

constructor Game.Build();
begin
  chuj_c := 0;
  chuj_s := ChujExtraction;
  chuj_p := 0;
  chuj_history_x[chuj_p] := ChujStartPos;
  chuj_history_y[chuj_p] := 62;
  chuj_history_a[chuj_p] := DegToRad(single(270));
  FillChar(chuj_history_grid, SizeOf(chuj_history_grid), 0);
end;  

procedure DrawSummaryPunkty;
begin
  text_y := 1;
  text_x := 33;
  write(punkty, '   ');
end;

procedure Game.DrawChuj;
var
  chuj_x, chuj_y: BYTE;
begin
  chuj_x := Round(chuj_history_x[chuj_p]);
  chuj_y := Round(chuj_history_y[chuj_p]);

  case chuj_s of
    ChujExtraction:
      begin
        SetColor(1);
        Game.IncrementNibble(chuj_x, chuj_y);
      end;
    ChujContraction:
      begin
        SetColor(Byte(Game.DecrementNibble(chuj_x, chuj_y) > 0));
        Dec(chuj_p);
        Dec(punkty);
        DrawSummaryPunkty;
      end
  end;

  PutPixel(chuj_x, chuj_y);
end;

procedure Game.ChujLeft;
begin
  if chuj_s = ChujExtraction then
  begin
    chuj_c := chuj_c + AngleStep;
    if chuj_c > 0.38 then
      chuj_c := chuj_c - AngleStep;
  end;
end;

procedure Game.ChujRight;
begin
   if chuj_s = ChujExtraction then
   begin
    chuj_c := chuj_c - AngleStep;
    if chuj_c < -0.38 then
      chuj_c := chuj_c + AngleStep;
  end;
end;

procedure Game.ChujProstowac;
begin
  if chuj_c = 0 then
    Exit;
  if chuj_c > 0 then
  begin
    chuj_c := chuj_c - AngleStep;
    if chuj_c < 0 then
      chuj_c := 0;
  end;
  if chuj_c < 0 then
  begin
    chuj_c := chuj_c + AngleStep;
    if chuj_c > 0 then
      chuj_c := 0;
  end;
end;

function Game.MoveChuj: ChujMoveOutcome;
var
  chuj_x, chuj_y, chuj_a: SINGLE;
  pix: BYTE;
begin
  case chuj_s of
    ChujExtraction:
      begin
        if chuj_p = 299 then 
          Exit(ChujMoveOutcome(TooLong));

        chuj_x := chuj_history_x[chuj_p];
        chuj_y := chuj_history_y[chuj_p];
        chuj_a := chuj_history_a[chuj_p];

        chuj_x := chuj_x + sin(chuj_a);
        chuj_y := chuj_y + cos(chuj_a);
        chuj_a := chuj_a + chuj_c;

        if chuj_y > 79 then
          Exit(ChujMoveOutcome(HitBottom));

        if chuj_y < 0 then
          Exit(ChujMoveOutcome(Surfaced));

        if chuj_x < 0 then
        begin
          Exit(ChujMoveOutcome(OutOfAkwen));
        end;

        if chuj_x >= 140 then
          if chuj_y > 38 then
             Exit(ChujMoveOutcome(AutoBlow))
          else 
             if chuj_x > 159 then
              Exit(ChujMoveOutcome(OutOfAkwen));

        pix := GetPixel(Round(chuj_x), Round(chuj_y));
        if pix = 3 then 
          Exit(ChujMoveOutcome(HitKamien));
        if pix = 2 then 
          Exit(ChujMoveOutcome(HitJajco));

        Inc(chuj_p);
        Inc(punkty);
        DrawSummaryPunkty;

        chuj_history_x[chuj_p] := chuj_x;
        chuj_history_y[chuj_p] := chuj_y;
        chuj_history_a[chuj_p] := chuj_a;
   
        Exit(ChujMoveOutcome(Extracted));
      end;
    ChujContraction:
      begin
        if chuj_p = 0 then 
          Exit(ChujMoveOutcome(TooShort));

        chuj_x := chuj_history_x[chuj_p-1];
        chuj_y := chuj_history_y[chuj_p-1];
        chuj_a := chuj_history_a[chuj_p-1];

        Exit(ChujMoveOutcome(Contracted));
      end;
    ChujBlocked:
      begin
      end;
  end;
end;

procedure DrawNurek;
var
  i, j, c: BYTE;
begin
  for j := 0 to 31 do
    for i := 0 to 18 do
      begin
        c := NurekData[j * 19 + i];
        if c > 0 then PutPixel(i+140, j+40, c);
      end
end;

function IsVerticalCorrect(x: BYTE): BOOLEAN;
var i, c: BYTE;
begin
  for i := 0 to 79 do
  begin
    c := GetPixel(x, i);
    if c <> 3 then Exit(true);
  end;
  Result := false;
end;

procedure ClearJajca;
var x, y:  BYTE;
begin
  for x := 0 to 139 do
    for y := 0 to 79 do
      PutPixel(x, y, 0);
end;

function AreJajcaCorrect: BOOLEAN;
var x, y:  BYTE;
begin
  for x := 0 to 139 do
    begin
      if IsVerticalCorrect(x) = false then 
      begin
        ClearJajca;
        Exit(false);
      end;
    end;
  Result := true;
end;

procedure DrawJajca(plansza: byte);
var
  i: BYTE;
  JX, JY, JSX, JSY: BYTE;
begin
  for i := 0 to plansza + 5 do
  begin
    JX := Random(100);
    JY := Random(70) + 15;
    JSX := Random(5) + 5;
    JSY := Random(10) + 5;
    SetColor(5-(i div (plansza + 5) + 2));
    FillEllipse(JX, JY, JSX, JSY);
  end;
end;

procedure ScreenOff;assembler ;
asm {
  lda #0
  sta 559
};
end;

procedure ScreenBack;assembler ;
asm {
  lda #34
  sta 559
};
end;

procedure vbi_routine_os;interrupt;
begin
  msx.play;
  asm {
    jmp XITVBV
    };

  // This generates unnecessary RTI, there must be a better way to do it
end;

procedure vbi_routine_noos;interrupt;
begin
  // empty
end;

procedure DrawSummaryHeaders;
begin
  text_x := 2;
  text_y := 1;
  write('Plansza:'*, ' 00  ', 'Rzyd'#7':'*, ' @  ', 'Punkty:'*, ' (    ');
end;

procedure DrawSummaryRzydz;
begin
  text_y := 1;
  text_x := 22;
  if rzydz = -1 then
    write('-')
  else
    write(rzydz);
end;

procedure DrawSummaryPlansza;
begin
  text_y := 1;
  text_x := 11;
  if plansza < 10 then
    Inc(text_x);
  write(plansza);
end;

procedure DrawSummaryValues;
begin
  DrawSummaryPunkty;
  DrawSummaryRzydz;
  DrawSummaryPlansza;
end;

procedure ShowStatus(id: byte);
var
  s: string;
begin
  if id = last_status then
    Exit;
  last_status := id;
  text_x := 0;
  text_y := 3;
  write('                                       ');
  s := statuses[id];
  text_x := 20-Length(s) div 2;
  write(s);
end;


procedure dli_game;assembler;interrupt;
asm {
  pha

  lda vcount
  cmp #$63
  bne @+
  lda #$ed
  sta wsync
  sta COLBAK
  sta COLPF2
  lda #$00
  sta COLPF1
@

  cmp #$50
  bne @+
  lda #$96
  sta wsync
  sta COLBAK
@

  cmp #$32
  bne @+
  lda #$98
  sta wsync
  sta COLBAK
@

  cmp #$13
  bne @+
  lda #$9a
  sta wsync
  sta COLBAK
@

  pla
};

end;		

procedure InitGameLevel;
begin
  InitGraph(7);
  last_status := -1;
  ScreenOff;
  DrawSummaryHeaders;

  dlist:=word(@dl_game);
  SetIntVec(iDLI, @dli_game);
  nmien:=%11000000;

  CursorOff;
  CHBAS := Hi(CHARSET_TILE_ADDRESS);

  DrawNurek;
  DrawSummaryValues;

  asm {
    ldx #$BA
    ldy #$05
    lda #$1a
    sta $2C4
    stx $2C5
    sty $2C6
  };
  repeat DrawJajca(plansza) until AreJajcaCorrect;
  ScreenBack;
  just_hit_kamien := false;
end;

procedure MemPrint(address: word; s: String);
var
  i, c: byte;
begin
  for i := 1 to Length(s) do
  begin
    c := Byte(s[i]);
    Poke(address + (i-1), c);
  end;
end;

procedure StartScreen;
var
  s: String;
  d: byte;
begin
  InitGraph(2);
  CursorOff;
  CHBAS := Hi(CHARSET_TILE_ADDRESS);

  s := 'NUREK Z WIELKIM...'~;
  MemPrint($BE70+1, s);
  Delay(2500);

  d := 133;
  msx.song(0);
  Poke($BE70+40+6, Byte('s'~));
  Delay(d);
  Poke($BE70+40+7, 128+Byte('E'~));
  Delay(d);
  Poke($BE70+40+8, 128+Byte('r'~));
  Delay(d);
  Poke($BE70+40+9, Byte('c'~));
  Delay(d);
  Poke($BE70+40+10, 128+Byte('E'~));
  Delay(d);
  Poke($BE70+40+11, 128+Byte('m'~));
  Delay(d);
  Poke($BE70+40+12, Byte('!'~));
  Delay(2000);

  writeln('      Gra przeznaczona na zlot');
  writeln('         ',' GRAWITJAJCA 2025 '*);
  writeln;
  Delay(1000);
  write('Version post-zlotowa (MadPaskaloska)');

  repeat until strig0 = 0;
  Delay(200);

  InitGraph(0);
  asm {
    ldx #$0f
    ldy #$00
    stx $2C5
    sty $2C6
    sty 82
  };

  CursorOff;
  CHBAS := Hi(CHARSET_TILE_ADDRESS);

  gotoxy(3,0);
  writeln('Nurcy cz'#4'sto niezdrowo interesuj'#17' si'#4'');
  write('jajcami. Gdy wi'#4'c profesor Oble'#23'no, pra-');
  write('cownik WCHUJ (Wydzia'#123' Chemii Uniwersyte-');
  writeln('tu Jagiello'#13'skiego) wyczu'#123' na dnie Odry');
  write('w Krakowie dinozaurowe jajca natychmiast');
  write('podj'#17''#123' si'#4' pr'#16'b inseminacji. Pomusz mu w');
  writeln('tym delikatnie steruj'#17'c jego pa'#123'k'#17'.');
  writeln;
  writeln('  ',' Uwaga! Jajca dinozaur'#16'w s'#17' zielone! '*);
  writeln;
  writeln;
  writeln;
  writeln('                   Kod:  ','mgr in'*#24'. Rafa'#123''*);
  writeln('               Grafika:  ','mgr in'*#24'. Rafa'#123''*);
  writeln('                Muzyka:           ','Miker'*);
  writeln('Doradztwo jak schowa'#22'');
  writeln('    kursor i wy'#123''#17'czy'#22'');
  writeln('       ekran komputera:           ','lewiS'*);
  writeln;
  writeln;
  writeln;
  writeln('        Aby rozpocz'#17''#22' gr'#17' nale'#24'y');
  writeln('               wdusi'#22' fajer');
  
  repeat until strig0 = 0;
  msx.stop;
end;

procedure EndScreen;
begin
    InitGraph(0);
    asm {
      ldx #$0f
      ldy #$00
      stx $2C5
      sty $2C6
    };

    CursorOff;
    CHBAS := Hi(CHARSET_TILE_ADDRESS);
    writeln;
    writeln('Nurcy cz'#4'sto umieraj'#17'');
    writeln('   gdy swym chujem');
    writeln('   g'#123'az smyraj'#17'...');
    writeln;writeln;writeln;writeln;writeln;writeln;
    writeln('   kontynuacja rozgrywki jest mo'#24'liwa');
    writeln('       tylko po wci'#23'ni'#4'ciu fajer!');
    writeln;writeln;writeln;writeln;writeln;writeln;
    writeln('   ','Tw'#16'j wspania'#123'y wynik to:'*, ' ', punkty, ' ', 'pkt!'*);

    repeat until strig0 = 0;
end;

var
  g: Game;
  speed: Word;

begin
  Randomize;

	msx.player:=pointer(cmc_player);
	msx.modul:=pointer(cmc_modul);  
	msx.initnosong;

  // With OS
  asm {
    ldy <vbi_routine_os
    ldx >vbi_routine_os
    lda #7
    jsr SETVBV
  };

  while not false do
  begin
    StartScreen;

    punkty := 0;
    rzydz := 0;
    plansza := 15;

    InitGameLevel;

    // Without OS, but failed
    // GetIntVec(iVBLD, old_vbl);
    // SetIntVec(iVBLD, @vbi_routine_empty);

    // asm {
    //   SEI
    //   LDA #<vbi_routine
    //   STA $0222
    //   LDA #>vbi_routine
    //   STA $0223
    //   CLI
    // };

  //  repeat until keypressed;

      // ldy <vbi_routine
      // ldx >vbi_routine
      // lda #7
      // jsr SETVBV


    msx.stop;
    msx.song(1);

    g.Build;

    while not false do
    begin
      case g.MoveChuj of
        Extracted: 
          begin
            ShowStatus(ST_EXPANSJA);
            g.DrawChuj;
            if just_hit_kamien then
            begin
              just_hit_kamien := false;
              msx.song(1);
            end;
          end;
        Contracted:
          begin
            ShowStatus(ST_KONTRAKCJA);
            g.DrawChuj;
          end;
        HitBottom:
          begin
            ShowStatus(ST_DNO);
          end;
        Surfaced:
          begin
            ShowStatus(ST_CIERPIENIE);
          end;
        TooShort:
          begin
            ShowStatus(ST_KRUTKI);
          end;
        TooLong:
          begin
            ShowStatus(ST_DUGI);
          end;
        OutOfAkwen:
          begin
            ShowStatus(ST_PLANSZA);
          end;
        AutoBlow:
          begin
            ShowStatus(ST_LODZIK);
          end;
        HitKamien:
          begin 
            if not just_hit_kamien then
            begin
              if rzydz > 0 then
                ShowStatus(ST_KAMIEN)
              else
                ShowStatus(ST_KAMIEN_FINAL);
              just_hit_kamien := true;
              msx.stop;
              Delay(300);
              msx.song(2);
              Delay(1234);
              Dec(rzydz);
              DrawSummaryRzydz;
              Delay(1234);
              msx.stop;
              if rzydz = -1 then break;
            end;
          end;
        HitJajco:
          begin
            ShowStatus(ST_JAJCO);
            msx.stop;
            Delay(300);
            msx.song(3);
            Delay(4321);
            Inc(plansza);
            InitGameLevel;
            g.Build;
            msx.stop;
            msx.song(1);
          end;
      end;

      case joy_1 of
        joy_left: g.ChujLeft;
        joy_right: g.ChujRight;
      else
        g.ChujProstowac
      end;

      case strig0 of
        1: g.chuj_s := ChujExtraction;
        0: g.chuj_s := ChujContraction;
      end;

      if plansza <= 21 then
      begin
        speed := 100 - (plansza-1)*5;
        Delay(speed);
      end;
    end;

    EndScreen;

  end
end.


// MODUL = 2000-2ab7
// PLAYER = 2ab8-3279