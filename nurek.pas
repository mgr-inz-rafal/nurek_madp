//{$define romoff}
{$define basicoff}

Uses crt, graph, math, joystick, cmc, atari;

Const 
  BONUS_MULTIPLIER: BYTE = 97;
  COLOR_KAMIEN: BYTE = 3;
  COLOR_JAJCO: BYTE = 2;
  TOTAL_MAXIMUM_JAJEC: BYTE = 66;
  SUMMARY_Y: BYTE = 2;
  KOMPENSACJA_Y: BYTE = 1;
  NurekData: array[0..607] Of BYTE = (
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
  dl_game: array [0..96] Of byte = 
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
                                    $02, $10, $02, $10, $02,

                                    %01000001,
                                    lo(word(@dl_game)), hi(word(@dl_game))
                                   );

  //CHARSET_TILE_ADDRESS = $ac00;
  CHARSET_TILE_ADDRESS = $a800;
  // Higher mem is occupied (DL @ AFA2).
  MUTACJA_MARKER_START = $BF60+15+2+40;
  MUTACJA_MARKER_END = MUTACJA_MARKER_START+20+1;
  //MUTACJA_MARKER_END = MUTACJA_MARKER_START+1+1;

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
  ST_TRANZYCJA = 11;

Var 
  jajca: array[0..TOTAL_MAXIMUM_JAJEC] Of cardinal;
  msx: TCMC;
  dlist: word absolute 560;
  text_y: byte absolute 656;
  text_x: byte absolute 657;
  plansza: byte;
  rzydz: byte;
  punkty: cardinal;
  bonus: cardinal;
  stracono: boolean;
  mutacja_za: Word;
  mutacja_marker: Word;
  current_dinojajco: Byte;
  mutacja_vbi_counter: Byte;
  statuses: array[0..11] Of ShortString = (
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
                                           'Smyrni'#4'to kamie'#13', to b'#123''#17'd...!',
                                           'Dokonuj'#4' tranzycji...'
                                          );
  last_status: byte;
  just_hit_kamien: boolean;

{$r 'cmc_play.rc'}
{$r 'charset.rc'}

Type 
  ChujMoveOutcome = (Extracted, TooLong, TooShort, HitBottom, Contracted, Surfaced, OutOfAkwen, AutoBlow, HitKamien, HitJajco);

Type 
  Game = Object
    chuj_c: SINGLE;
    chuj_s: BYTE;
    chuj_p: WORD;
    chuj_history_x: array[0..299] Of SINGLE;
    chuj_history_y: array[0..299] Of SINGLE;
    chuj_history_a: array[0..299] Of SINGLE;
    chuj_history_grid: array[0..79, 0..79] Of BYTE;
    constructor Build;
    Function MoveChuj: ChujMoveOutcome;
    Procedure DrawChuj;
    Procedure ChujLeft;
    Procedure ChujRight;
    Procedure ChujProstowac;
    Function GetNibble(x, y: Byte): Byte;
    Procedure SetNibble(x, y: Byte; value: Byte);
    Procedure IncrementNibble(x, y: Byte);
    Function DecrementNibble(x, y: Byte): BYTE;
  End;

Function Game.GetNibble(x, y: Byte): Byte;

Var 
  index, offset: Byte;
Begin
  index := x Div 2;
  offset := x Mod 2;

  If offset = 0 Then
    Result := chuj_history_grid[index, y] And $0F
  Else
    Result := (chuj_history_grid[index, y] shr 4) And $0F;
End;

Procedure Game.SetNibble(x, y: Byte; value: Byte);

Var 
  index, offset: Byte;
Begin
  index := x Div 2;
  offset := x Mod 2;
  value := value And $0F;

  If offset = 0 Then
    chuj_history_grid[index, y] := (chuj_history_grid[index, y] And $F0) Or value
  Else
    chuj_history_grid[index, y] := (chuj_history_grid[index, y] And $0F) Or (value shl 4);
End;

Procedure Game.IncrementNibble(x, y: Byte);

Var 
  currentValue: Byte;
Begin
  currentValue := Game.GetNibble(x, y);
  Game.SetNibble(x, y, currentValue + 1);
End;

Function Game.DecrementNibble(x, y: Byte): BYTE;

Var 
  currentValue: Byte;
Begin
  currentValue := Game.GetNibble(x, y);

  If currentValue > 0 Then
    Begin
      currentValue := currentValue - 1;
      Game.SetNibble(x, y, currentValue);
    End;

  Result := currentValue;
End;

Function PackJajcoToCardinal(x, y, sx, sy: BYTE): Cardinal;
Begin
  PackJajcoToCardinal := (x shl 24) Or (y shl 16) Or (sx shl 8) Or sy;
End;

Procedure UnpackCardinalToJajco(value: Cardinal; Var x, y, sx, sy: BYTE);
Begin
  x  := (value shr 24) And $FF;
  y  := (value shr 16) And $FF;
  sx := (value shr 8) And $FF;
  sy := value And $FF;
End;

constructor Game.Build();
Begin
  chuj_c := 0;
  chuj_s := ChujExtraction;
  chuj_p := 0;
  chuj_history_x[chuj_p] := ChujStartPos;
  chuj_history_y[chuj_p] := 62;
  chuj_history_a[chuj_p] := DegToRad(single(270));
  FillChar(chuj_history_grid, SizeOf(chuj_history_grid), 0);
End;

Procedure DrawSummaryKompensacja;
Begin
  text_y := KOMPENSACJA_Y;
  text_x := 1;
  write('Mutajca jajca: [^^^^^^^^^^^^^^^^^^^^^]')
End;

Procedure DrawSummaryMaszBonus;
Begin
  text_y := KOMPENSACJA_Y;
  text_x := 1;
  write('                                      ');
  text_y := KOMPENSACJA_Y;
  text_x := 1;
  write('    Bonus ', bonus, ' za brak uszczerbku');
End;

Procedure DrawSummaryNieMaszBonusu;
Begin
  text_y := KOMPENSACJA_Y;
  text_x := 1;
  write('                                      ');
  text_y := KOMPENSACJA_Y;
  text_x := 1;
  write('   Nie ma bonusu, bo by'#123' uszczerbek   ');
End;

Procedure DrawSummaryBrakKompensacji;
Begin
  text_y := KOMPENSACJA_Y;
  text_x := 1;
  write('Brak uszczerbku, brak planowej mutacji');
End;

Procedure DrawSummaryPunkty;
Begin
  text_y := SUMMARY_Y;
  text_x := 33;
  write(punkty, '  ');
End;

Procedure Game.DrawChuj;

Var 
  chuj_x, chuj_y: BYTE;
Begin
  chuj_x := Round(chuj_history_x[chuj_p]);
  chuj_y := Round(chuj_history_y[chuj_p]);

  Case chuj_s Of 
    ChujExtraction:
                    Begin
                      SetColor(1);
                      Game.IncrementNibble(chuj_x, chuj_y);
                    End;
    ChujContraction:
                     Begin
                       SetColor(Byte(Game.DecrementNibble(chuj_x, chuj_y) > 0));
                       Dec(chuj_p);
                       Dec(punkty);
                       DrawSummaryPunkty;
                     End
  End;

  PutPixel(chuj_x, chuj_y);
End;

Procedure Game.ChujLeft;
Begin
  If chuj_s = ChujExtraction Then
    Begin
      chuj_c := chuj_c + AngleStep;
      If chuj_c > 0.38 Then
        chuj_c := chuj_c - AngleStep;
    End;
End;

Procedure Game.ChujRight;
Begin
  If chuj_s = ChujExtraction Then
    Begin
      chuj_c := chuj_c - AngleStep;
      If chuj_c < -0.38 Then
        chuj_c := chuj_c + AngleStep;
    End;
End;

Procedure Game.ChujProstowac;
Begin
  If chuj_c = 0 Then
    Exit;
  If chuj_c > 0 Then
    Begin
      chuj_c := chuj_c - AngleStep;
      If chuj_c < 0 Then
        chuj_c := 0;
    End;
  If chuj_c < 0 Then
    Begin
      chuj_c := chuj_c + AngleStep;
      If chuj_c > 0 Then
        chuj_c := 0;
    End;
End;

Function Game.MoveChuj: ChujMoveOutcome;

Var 
  chuj_x, chuj_y, chuj_a: SINGLE;
  pix: BYTE;
Begin
  Case chuj_s Of 
    ChujExtraction:
                    Begin
                      If chuj_p = 299 Then
                        Exit(ChujMoveOutcome(TooLong));

                      chuj_x := chuj_history_x[chuj_p];
                      chuj_y := chuj_history_y[chuj_p];
                      chuj_a := chuj_history_a[chuj_p];

                      chuj_x := chuj_x + sin(chuj_a);
                      chuj_y := chuj_y + cos(chuj_a);
                      chuj_a := chuj_a + chuj_c;

                      If chuj_y > 79 Then
                        Exit(ChujMoveOutcome(HitBottom));

                      If chuj_y < 0 Then
                        Exit(ChujMoveOutcome(Surfaced));

                      If chuj_x < 0 Then
                        Begin
                          Exit(ChujMoveOutcome(OutOfAkwen));
                        End;

                      If chuj_x >= 140 Then
                        If chuj_y > 38 Then
                          Exit(ChujMoveOutcome(AutoBlow))
                      Else
                        If chuj_x > 159 Then
                          Exit(ChujMoveOutcome(OutOfAkwen));

                      pix := GetPixel(Round(chuj_x), Round(chuj_y));
                      If pix = 3 Then
                        Exit(ChujMoveOutcome(HitKamien));
                      If pix = 2 Then
                        Exit(ChujMoveOutcome(HitJajco));

                      Inc(chuj_p);
                      Inc(punkty);
                      DrawSummaryPunkty;

                      chuj_history_x[chuj_p] := chuj_x;
                      chuj_history_y[chuj_p] := chuj_y;
                      chuj_history_a[chuj_p] := chuj_a;

                      Exit(ChujMoveOutcome(Extracted));
                    End;
    ChujContraction:
                     Begin
                       If chuj_p = 0 Then
                         Exit(ChujMoveOutcome(TooShort));

                       chuj_x := chuj_history_x[chuj_p-1];
                       chuj_y := chuj_history_y[chuj_p-1];
                       chuj_a := chuj_history_a[chuj_p-1];

                       Exit(ChujMoveOutcome(Contracted));
                     End;
    ChujBlocked:
                 Begin
                 End;
  End;
End;

Procedure DrawNurek;

Var 
  i, j, c: BYTE;
Begin
  For j := 0 To 31 Do
    For i := 0 To 18 Do
      Begin
        c := NurekData[j * 19 + i];
        If c > 0 Then PutPixel(i+140, j+40, c);
      End
End;

// function IsVerticalCorrect(x: BYTE): BOOLEAN;
// var i, c: BYTE;
// begin
//   for i := 0 to 79 do
//   begin
//     c := GetPixel(x, i);
//     if c <> 3 then Exit(true);
//   end;
//   Result := false;
// end;

// procedure ClearJajca;
// var x, y:  BYTE;
// begin
//   for x := 0 to 139 do
//     for y := 0 to 79 do
//       PutPixel(x, y, 0);
// end;

// function AreJajcaCorrect: BOOLEAN;
// var x, y:  BYTE;
// begin
//   for x := 0 to 139 do
//     begin
//       if IsVerticalCorrect(x) = false then 
//       begin
//         ClearJajca;
//         Exit(false);
//       end;
//     end;
//   Result := true;
// end;

Function MaxJajcaCount(plansza: BYTE): BYTE;

Var 
  max_jajca: BYTE;
Begin
  max_jajca := plansza + 5;
  If max_jajca > TOTAL_MAXIMUM_JAJEC Then
    max_jajca := TOTAL_MAXIMUM_JAJEC;
  Result := max_jajca;
End;

Procedure CalculateJajca(plansza: byte);

Var 
  i: BYTE;
  JX, JY, JSX, JSY: BYTE;
Begin
  current_dinojajco := 0;
  For i := 0 To MaxJajcaCount(plansza) Do
    Begin
      JX := Random(100);
      JY := Random(70) + 15;
      JSX := Random(5) + 5;
      JSY := Random(10) + 5;
      jajca[i] := PackJajcoToCardinal(JX, JY, JSX, JSY);
    End;
End;

Procedure DrawJajco(i: BYTE; c: BYTE; slow: boolean);

Var 
  JX, JY, JSX, JSY: BYTE;
  ii, limit: byte;
Begin
  UnpackCardinalToJajco(jajca[i], JX, JY, JSX, JSY);
  SetColor(c);
  If slow Then
    Begin
      If JSX > JSY Then limit := JSY
      Else limit := JSX;
      For ii := 0 To limit Do
        FillEllipse(JX, JY, ii, ii);
    End;
  FillEllipse(JX, JY, JSX, JSY);
End;

Procedure DrawJajca(plansza: byte);

Var 
  i: BYTE;
  c: BYTE;
Begin
  For i := 0 To MaxJajcaCount(plansza) Do
    Begin
      If i = current_dinojajco Then
        c := COLOR_JAJCO
      Else
        c := COLOR_KAMIEN;
      DrawJajco(i, c, false);
    End;
End;


Procedure ScreenOff;
assembler ;
asm {
  lda #0
  sta 559
};
End;

Procedure ScreenBack;
assembler ;
asm {
  lda #34
  sta 559
};
End;

Procedure vbi_routine_os;
interrupt;
Begin
  Inc(mutacja_vbi_counter);
  msx.play;
  asm {
    jmp XITVBV
    };

  // This generates unnecessary RTI, there must be a better way to do it
End;

Procedure vbi_routine_noos;
interrupt;
Begin
  // empty
End;

Procedure DrawSummaryHeaders;
Begin
  text_x := 2;
  text_y := SUMMARY_Y;
  write('Plansza:'*, ' 00  ', 'Rzyd'#7':'*, ' @  ', 'Punkty:'*, ' (    ');
End;

Procedure DrawSummaryRzydz;
Begin
  text_y := SUMMARY_Y;
  text_x := 22;
  If rzydz = -1 Then
    write('-')
  Else
    write(rzydz);
End;

Procedure DrawSummaryPlansza;
Begin
  text_y := SUMMARY_Y;
  text_x := 11;
  If plansza < 10 Then
    Inc(text_x);
  write(plansza);
End;

Procedure DrawSummaryValues;
Begin
  DrawSummaryPunkty;
  DrawSummaryRzydz;
  DrawSummaryPlansza;
End;

Procedure ShowStatus(id: byte);

Var 
  s: string;
Begin
  If id = last_status Then
    Exit;
  last_status := id;
  text_x := 0;
  text_y := 3;
  write('                                       ');
  s := statuses[id];
  text_x := 20-Length(s) Div 2;
  write(s);
End;

Procedure Mutation;
Begin
  msx.stop;
  ShowStatus(ST_TRANZYCJA);
  Delay(1000);
  DrawJajco(current_dinojajco, COLOR_KAMIEN, true);
  Delay(100);
  Inc(current_dinojajco);
  If current_dinojajco > MaxJajcaCount(plansza) Then
    current_dinojajco := 0;
  DrawJajco(current_dinojajco, COLOR_JAJCO, true);
End;

Procedure dli_game;
assembler;
interrupt;
asm
{
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
}
;

End;

Procedure InitGameLevel;
Begin
  InitGraph(7);
  last_status := -1;
  ScreenOff;
  DrawSummaryHeaders;
  DrawSummaryBrakKompensacji;

  dlist := word(@dl_game);
  SetIntVec(iDLI, @dli_game);
  nmien := %11000000;

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
  //  repeat DrawJajca(plansza) until AreJajcaCorrect;
  CalculateJajca(plansza);
  DrawJajca(plansza);
  ScreenBack;
  just_hit_kamien := false;
End;

Procedure MemPrint(address: word; s: String);

Var 
  i, c: byte;
Begin
  For i := 1 To Length(s) Do
    Begin
      c := Byte(s[i]);
      Poke(address + (i-1), c);
    End;
End;

Procedure StartScreen;

Var 
  s: String;
  d: byte;
Begin
  InitGraph(2);
  CursorOff;
  CHBAS := Hi(CHARSET_TILE_ADDRESS);

  s := 'NUREK Z WIELKIM...'~;
  MemPrint($BE70+1, s);
  Delay(1500);

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
  Delay(701);

  text_x := 8;
  text_y := 0;
  writeln('Gra przeznaczona na zlot');
  text_x := 11;
  text_y := 1;
  writeln(' GRAWITJAJCA 2025 '*);
  Delay(500);
  text_x := 1;
  text_y := 3;
  write('Version 5 post-zlotowa (MadPaskaloska)');

  Repeat
  Until strig0 = 0;
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
  writeln('        Aby rozpocz'#17''#22' gr'#4' nale'#24'y');
  writeln('               wdusi'#22' fajer');

  Repeat
  Until strig0 = 0;
  msx.stop;
End;

Procedure InitMutacja;
Begin
  mutacja_za := Random(7) + 8;
  stracono := true;
  mutacja_vbi_counter := 0;
  mutacja_marker := MUTACJA_MARKER_START;
  DrawSummaryKompensacja;
End;

Procedure HandleMutacja;
Begin
  If Not stracono Then Exit;
  If mutacja_vbi_counter > 69 Then
    Begin;
      mutacja_vbi_counter := 0;
      Poke(mutacja_marker, 124);
      Inc(mutacja_marker);
      If mutacja_marker = MUTACJA_MARKER_END Then
        Begin
          Mutation;
          msx.song(1);
          InitMutacja;
        End;
    End;
End;

Procedure EndScreen;
Begin
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
  writeln;
  writeln;
  writeln;
  writeln;
  writeln;
  writeln;
  writeln('   kontynuacja rozgrywki jest mo'#24'liwa');
  writeln('       tylko po wci'#23'ni'#4'ciu fajer!');
  writeln;
  writeln;
  writeln;
  writeln;
  writeln;
  writeln;
  writeln('   ','Tw'#16'j wspania'#123'y wynik to:'*, ' ', punkty, ' ', 'pkt!'*);
  writeln('   ',' zgromadzonych na planszy nr '*, ' ', plansza);

  Repeat
  Until strig0 = 0;
End;

Var 
  g: Game;
  speed: Word;
  ilicz_wlodzimierz: Word;

Begin
  Randomize;

  msx.player := pointer(cmc_player);
  msx.modul := pointer(cmc_modul);
  msx.initnosong;

  // With OS
  asm {
    ldy <vbi_routine_os
    ldx >vbi_routine_os
    lda #7
    jsr SETVBV
  };

  While Not false Do
    Begin
      StartScreen;

      punkty := 0;
      rzydz := 9;
      plansza := 1;
      stracono := false;
      mutacja_marker := MUTACJA_MARKER_START;

      //InitMutacja;

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

      While Not false Do
        Begin
          If PEEK(754) = 28 Then
            Begin
              msx.stop;
              Poke(754, 255);
              break;
            End;
          // if PEEK(754) = 28 then begin 
          //   Mutation;
          // end;
          atract := 0;
          Case g.MoveChuj Of 
            Extracted:
                       Begin
                         ShowStatus(ST_EXPANSJA);
                         g.DrawChuj;
                         HandleMutacja;
                         If just_hit_kamien Then
                           Begin
                             just_hit_kamien := false;
                             msx.song(1);
                           End;
                       End;
            Contracted:
                        Begin
                          ShowStatus(ST_KONTRAKCJA);
                          g.DrawChuj;
                        End;
            HitBottom:
                       Begin
                         ShowStatus(ST_DNO);
                       End;
            Surfaced:
                      Begin
                        ShowStatus(ST_CIERPIENIE);
                      End;
            TooShort:
                      Begin
                        ShowStatus(ST_KRUTKI);
                      End;
            TooLong:
                     Begin
                       ShowStatus(ST_DUGI);
                     End;
            OutOfAkwen:
                        Begin
                          ShowStatus(ST_PLANSZA);
                        End;
            AutoBlow:
                      Begin
                        ShowStatus(ST_LODZIK);
                      End;
            HitKamien:
                       Begin
                         If Not just_hit_kamien Then
                           Begin
                             If rzydz > 0 Then
                               ShowStatus(ST_KAMIEN)
                             Else
                               msx.stop;
                             ShowStatus(ST_KAMIEN_FINAL);
                             just_hit_kamien := true;
                             Delay(300);
                             msx.song(2);
                             Delay(1234);
                             Dec(rzydz);
                             DrawSummaryRzydz;
                             Delay(1234);
                             If Not stracono Then InitMutacja;
                             msx.stop;
                             If rzydz = -1 Then break;
                           End;
                       End;
            HitJajco:
                      Begin
                        ShowStatus(ST_JAJCO);
                        msx.stop;
                        Delay(300);
                        msx.song(3);
                        If Not stracono Then
                          Begin
                            bonus := BONUS_MULTIPLIER * plansza;
                            punkty := punkty + bonus;
                            DrawSummaryMaszBonus;
                            DrawSummaryPunkty;
                          End
                        Else DrawSummaryNieMaszBonusu;
                        For ilicz_wlodzimierz := g.chuj_p Downto 0 Do
                          Begin
                            SetColor(COLOR_JAJCO);
                            PutPixel(Round(g.chuj_history_x[ilicz_wlodzimierz]), Round(g.chuj_history_y[ilicz_wlodzimierz]));
                            Delay(9);
                          End;
                        asm {
              pha
              lda #$BA
              sta $2C4
              pla
            };
                        Delay(1234);
                        stracono := false;
                        Inc(plansza);
                        InitGameLevel;
                        g.Build;
                        msx.stop;
                        msx.song(1);
                      End;
          End;

          Case joy_1 Of 
            joy_left: g.ChujLeft;
            joy_right: g.ChujRight;
            Else
              g.ChujProstowac
          End;

          Case strig0 Of 
            1: g.chuj_s := ChujExtraction;
            0: g.chuj_s := ChujContraction;
          End;

          If plansza <= 21 Then
            Begin
              speed := 100 - (plansza-1)*5;
              Delay(speed);
            End;
        End;

      EndScreen;

    End
End.


// MODUL = 2000-2ab7
// PLAYER = 2ab8-3279
