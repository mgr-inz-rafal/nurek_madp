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
	cmc_player = $2ab8;
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

var
	msx: TCMC;  
  dlist: word absolute 560;
  text_y: byte absolute 656;
  text_x: byte absolute 657;
  statuses: array[0..9] of ShortString = (
      'Status proncia: ' + ' EXPANSJA '*,
      'Status proncia: ' + ' KONTRAKCJA '*,
      'Osiagnales dno, kontraktuj!',
      'Na powierzchni tylko cierpienie...',
      'Osiagnieto limit krotkosci penisa',
      'Za dugi huj, kurcz sie',
      'Nie wolno wyjezdzac z planszy!',
      'Wykryto zagrozenie autolodem',
      'Smyrnieto kamien, to blad',
      'Dinojajco zaplodnione, amen!'
      );
  last_status: byte = -1;

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
    current_delay: BYTE;
    finish: BOOLEAN;
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
  current_delay := 20;
  finish := FALSE;
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

        chuj_p := chuj_p + 1;

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

procedure DrawJajca;
var
  i: BYTE;
  JX, JY, JSX, JSY: BYTE;
begin
  for i := 0 to 6 do
  begin
    JX := Random(100);
    JY := Random(70) + 15;
    JSX := Random(5) + 5;
    JSY := Random(10) + 5;
    SetColor(5-(i div 6 + 2));
    FillEllipse(JX, JY, JSX, JSY);
  end;
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

var
  g: Game;

begin
  InitGraph(7);

  dlist:=word(@dl_game);
  SetIntVec(iDLI, @dli_game);
  nmien:=%11000000;

  CursorOff;
  CHBAS := Hi(CHARSET_TILE_ADDRESS);

	msx.player:=pointer(cmc_player);
	msx.modul:=pointer(cmc_modul);  

	msx.init;

  // With OS
  asm {
    ldy <vbi_routine_os
    ldx >vbi_routine_os
    lda #7
    jsr SETVBV
  };


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



  g.Build;

  DrawNurek;
  DrawJajca;

  while not g.finish do
  begin
    case g.MoveChuj of
      Extracted: 
        begin
          ShowStatus(ST_EXPANSJA);
          g.DrawChuj;
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
          ShowStatus(ST_KAMIEN);
        end;
      HitJajco:
        begin
          ShowStatus(ST_JAJCO);
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

    if g.current_delay > 0 then
      Delay(g.current_delay);
  end;

end.


// MODUL = 2000-2ab7
// PLAYER = 2ab8-3279