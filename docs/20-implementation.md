# 2.実装

## 課題1

```
EXE1 START
     ;; GR2に1, GR3に8を入れる
     ;; GR2に1, GR3に8を入れる
     LAD GR2,1 ; GR2 <- 1
     LAD GR3,8 ; GR3 <- 8

;;   サブルーチンCALC
     CALL CALC
     RET

CALC PUSH 0,GR2 ;;GR2を退避
     SLA GR2,1  ;; GR2を10倍する処理
     ST GR2,WK
     SLA GR2,2
     ADDA GR2,WK
     ;; GR2+GR3の処理
     LAD GR0,0
     ADDA GR0,GR2
     ADDA GR0,GR3
     ;; GR4,5を戻す
     POP GR2
     RET
WK   DS 1
     END
```

## 課題2

```
EXE2 START
     LAD GR1,6
     CALL CALC
     RET
CALC PUSH 0,GR2
     LD GR2,GR1
     SLA GR2,1
     SUBA GR2,=1 
     LD GR0,=0
LOOP ADDA GR0,GR2
     SUBA GR2,=2
     JPL LOOP
     POP GR2
     RET
     END
```

## 課題3

```
EXE3 START
     LAD GR1,30 ;; M
     LAD GR2,84 ;; N
     CALL CALC
     RET

CALC PUSH 0,GR3  ;; 作業領域確保  WKM
     PUSH 0,GR4  ;;             WKN             
     LD GR3,GR1  ;; MをWKMにコピー
     LD GR4,GR2  ;; NをWKNにコピー
     LAD GR0,0   ;;0でリセット
FIVE CPA GR3,GR4 ;;(>)...
     JZE TEN     ;; 等しければ10
     JPL NINE    ;; WKM > WKNであれば 9
     ;;;elsif 引き算
     SUBA GR4,GR3
     JUMP FIVE

     RET

NINE SUBA GR3,GR4
     JUMP FIVE

TEN LD GR0,GR4
     ;; 作業領域の復元
     POP GR4
     POP GR3
     RET
     END
```

## 課題4

```
EXE4  START
      LAD GR1,-3 ;; M
      LAD GR2,2 ;; N
      CALL MULT
      RET

;; 掛け算サブルーチン
MULT  PUSH 0,GR1  ;; オリジナルの値待避
      PUSH 0,GR2
      PUSH 0,GR6  ;; wkM 作業領域確保  WKM
      PUSH 0,GR7  ;; wkN             WKN             
      LD GR6,GR1  ;; MをWKMにコピー
      LD GR7,GR2  ;; NをWKNにコピー
      LAD GR0,0   ;; 0でリセット
FIVE  LAD GR1,1   ;; GR1に1
      AND GR1,GR7 ;; GR1 &= GRwkN
      JZE EIGHT   ;; 前述の演算結果が0であれば8に
      ADDA GR0,GR6 ;; GR0+=GRwkM
EIGHT SLA GR6,1     ;; GRwkM <<= 1
      SRA GR7,1     ;; GRwkN >>= 1
      JNZ FIVE    ;; GRwkMがノンゼロであればもどる
      ;;;;; ワーキングメモリの解放
      POP GR7      
      POP GR6
      POP GR2
      POP GR1
      RET
;; サブルーチンここまで
      END

```

## 課題5

```
EXE5  START
      LAD GR1,3 ;; x
      LAD GR2,4 ;; y
      CALL POW
      RET

;; 冪乗サブルーチン
;;    基数(x)    : GR1
;;    冪数(y)    : GR2
;;    カウンタ(y) : GR5 初期値y(GR2)

POW   PUSH 0,GR5  ;; カウンタレジスタ待避
      PUSH 0,GR1  ;; オリジナルの値待避
      PUSH 0,GR2 
      LD GR5,GR2  ;; カウンタ <- y
      LD GR2,GR1  ;; GR2(N) <- x
      LAD GR1,1   ;; GR1(M) <- 1
FOUR  CALL MULT   ;; GR0 = GR1
      LD GR1,GR0  ;; GR1(M) = MULTの結果
      SUBA GR5,=1 ;; カウンタ(GR5)を1減らす
      JPL FOUR    ;; カウンタ>0であれば4にジャンプ
      ;; 退避した値を戻す
     
      POP GR2      
      POP GR1
      POP GR5
      RET
;; ここまで

;; 掛け算サブルーチン
MULT  PUSH 0,GR1  ;; オリジナルの値待避
      PUSH 0,GR2
      PUSH 0,GR6  ;; wkM 作業領域確保  WKM
      PUSH 0,GR7  ;; wkN             WKN             
      LD GR6,GR1  ;; MをWKMにコピー
      LD GR7,GR2  ;; NをWKNにコピー
      LAD GR0,0   ;; 0でリセット
FIVE  LAD GR1,1   ;; GR1に1
      AND GR1,GR7 ;; GR1 &= GRwkN
      JZE EIGHT   ;; 前述の演算結果が0であれば8に
      ADDA GR0,GR6 ;; GR0+=GRwkM
EIGHT SLA GR6,1     ;; GRwkM <<= 1
      SRA GR7,1     ;; GRwkN >>= 1
      JNZ FIVE    ;; GRwkMがノンゼロであればもどる
      ;;;;; ワーキングメモリの解放
      POP GR7      
      POP GR6
      POP GR2
      POP GR1
      RET
;; サブルーチンここまで
      END
```

