#lang br

(require "parser-f.rkt" "tokenizer-f.rkt" brag/support)

(define quine #<<HERE
10s: 10s FR As R Ks As FR 2s FR 2d Ad Ks As FR 2s R Ks 2s FR As R Ks 3h 2h FR 5h 8h FR Ah Ah 5h FR As 10s FR R Ac Jd As FR As Jd 10s FR As R Ks
HERE
  )

(define bf #<<HERE
>cells
0s: 0c, Js, 0h > Move to 0c as starting deck, initilize 0 with 0h
As: 0h > initialize 1 with 0h

>functions
0c: 4d, F, Ad, Jd > new start, take data input
    >If code index = code size, stop
    1c 0c, F, 2c, F,> load if results
    4d, Jh > get code size
    R, 3d, F, 0s Ks > copy code size to 3d 
    F, 2d, F, 0c, R Ks > copy code index to here
    >code size F code index< F Ad Qs > code size = code index equivilant
    >0c, F, 2c, F, (index=size)< Qh
    >0c or 2c< F, 0c, R Ks > copy 2c onto here if code index is less than code size

    >else
    >Look at current code character
    >If character between 43 and 46 inclusive
    >    or equal to 61 or 62
    >    do nothing
    > else if equal to 91
    >    place copy of index on holder deck
    > else if equal to 93
    >    get copy of top arg of holder deck
    >    place copy of index on top of (top arg) deck
    >    move top arg to deck (code index)
    > else
    >    delete code character at index
    >    index = index - 1
    >    code size = code size - 1
    > end if
    > index = index + 1
    > loop to top
    >end if
    
    >Ac, F, 0c, R Ks > copy Case function onto 0c

Ac: >If code index = code size, stop
    1c 0c, F, 2c F> load if results
    2d, F, 0c, F 0h, Ks > move code index here
    >code index,< F, As, F, As, Qc > code index + 1
    F, R, 2d, F, 0s, Ks > copy code index + 1 to 2d
    F 3d, F, 0c, R Ks > copy code size to here
    >index F code size< F Ad Qs > code index = code size equivilant
    >0c, F, 2c, F, (index=size)< Qh
    >0c or 2c< F, 0c, R Ks > copy 2c onto here if code index is less than code size

2c: Ac, F, 3c, F > load if
    4d, F, 0c, F, 2d, F, 0c, F, R Ks, Ks > copy cur char onto 0c
    >cur char< F, 4h 3h, F, Ac Qs> lesser of 43 and cur char
    >result< F, 4h 3h, F, Ah, Qs > greater or equal to 43
    F,
    4d, F, 0c, F, 2d, F, 0c, F, R Ks, Ks > copy cur char onto 0c
    >cur char< F, 4h 6h, F, As Qs> greater of 46 and cur char
    >result< F, 4h 6h, F, Ah, Qs > less than or equal to 46
    >greater or equal 43< >F< >less or equal 46< F, Ac Qs> AND
    >Ac, F, 3c,< >Ad or 0d< Qh > if cur char is between, Ac, else 3c
    >Ac or 3c< F, 0c, R, Ks > copy Ac or 3c onto 0c

3c: 4c, F, 5c, F, > load if
    4d, F, 0c, F, 2d, F, 0c, F, R Ks, Ks > copy cur char onto 0c
    F, 9h 1h, F, Ah, Qs > cur char == 91
    >4c, F, 5c, F,< >91 or 0d< Qh > if cur char == 91 4c, else 5c
    >4c or 5c< F, 0c, R, Ks > copy 4c or 5c onto 0c

4c: 2d, F 0c, R Ks > copy code index to 0c
    F, Ah Qd > index to hearts
    F, R, 5d, F 0h Ks> move heart index to 5d
    Ac, F, 0c, R Ks > copy Ac onto 0c

5c: 6c, F, 7c, F, > load if
    4d, F, 0c, F, 2d, F, 0c, F, R Ks, Ks > copy cur char onto 0c
    F, 9h 3h, F, Ah, Qs > cur char == 93
    >6c, F, 7c, F,< >93 or 0d< Qh > if cur char == 93 6c, else 7c
    >6c or 7c< F, 0c, R, Ks > copy 6c or 7c onto 0c

6c: 5d, F, > load
    2d, F, 0c, R, Ks F, Ah, Qd > copy index to hearts
    >5d, F, index hearts< F, 0s, Ks > copy top 5d onto deck [index hearts]
    2d, F, 0c, R, Ks F, Ah, Qd > copy index to hearts
    F, R,
    5d, F, 0c, F, 0h Ks > move top 5d to 0c
    >F, R< >top 5d< F, 0h, Ks > copy index hearts to deck [top 5d]
    Ac, F, 0c, R Ks > copy Ac onto 0c

7c: Ac, F, 8c, F, > load if
    4d, F, 0c, F, 2d, F, 0c, F, R Ks, Ks > copy cur char onto 0c
    F, 6h 0h, F, Ah, Qs > cur char == 60
    >Ac, F, 8c, F,< >61 or 0d< Qh > if cur char == 61 Ac, else 8c
    >Ac or 8c< F, 0c, R, Ks > copy Ac or 8c onto 0c

8c: Ac, F, 9c, F, > load if
    4d, F, 0c, F, 2d, F, 0c, F, R Ks, Ks > copy cur char onto 0c
    F, 6h 2h, F, Ah, Qs > cur char == 62
    >Ac, F, 9c, F,< >62 or 0d< Qh > if cur char == 62 Ac, else 9c
    >Ac or 9c< F, 0c, R, Ks > copy Ac or 9c onto 0c

9c: 4d, F, R, > load deletion
    2d, F, 0c, R Ks > copy code index
    >index< F, Ah, Qd > turn index to hearts 
    >4d, F, R,< >index h< Ks > delete cur char
    2d, F, 0c, F, 0h, Ks > move code index 0c
    >index< F, As, F, Ac, Qc > index - 1
    F, R, 2d, F, 0h, Ks > move index - 1 to 2d
    3d, F, 0c, F 0h, Ks > move code size 0c
    >index< F, As, F, Ac, Qc > size - 1
    F, R, 3d, F, 0h, Ks > move size - 1 to 3d
    Ac, F, 0c, R Ks > copy Ac onto 0c

1c 0c: 2d, R, 0h Ks > delete code index
       Ac > -1
       R, 2d, F, 0h, Ks > set code index = -1
       1c 1c F, 0c, R Ks > copy 11c onto 0c

1c 1c: >If code index = code size, stop
       0c, F, 1c 2c F > load if results
       2d, F, 0c, F 0h, Ks > move code index here
       >code index,< F, As, F, As, Qc > code index + 1
       F, R, 2d, F, 0s, Ks > copy code index + 1 to 2d
       F 3d, F, 0c, R Ks > copy code size to here
       >index F code size< F Ad Qs > code index = code size equivilant
       >0c, F, 1c 2c, F, (index=size)< Qh
       >0c or 1c 2c< F, 0c, R Ks > copy 2c onto here if code index is less than code size

1c 2c: 4d, F, 0c, F, 2d, F, 0c, F, R Ks, Ks > copy cur char onto 0c
       F, Ac, Qd > turn cur char to clubs
       >cur char as deck,< F, 0c, R, Ks > copy cur char deck onto 0c
       >cur char happens<
       1c 1c F, 0c, R, Ks > copy 11c onto 0c

4c 3c: > + > 43
       0d, F, 0c, R, Ks > copy cell index to 0c
       >cell index,< F, 0c, F, 0h, Ks > move cell index [data] to 0c
       >cur data< F, As, F, As, Qs > cur-data++
       R, > load move
       0d, F, 0c, R, Ks > copy cell index to 0c
       >R, cell-index,< F, 0h, Ks > move top of R to cell index

4c 4c: > , > 44
       5d, F, 6d, R, Ks > copy 5d onto 6d
       5d, R, R, Ks > delete 5d
       5d, F, Ad, Jd > input data onto 5d
       6d, F, 5d, R, Ks > copy 6d onto 5d
       6d, R, R, Ks > delete 6d
       0d, F, 0c, R, Ks > copy cell index to 0c
       >cell index< R, R, Ks > delete cell [index]
       5d, F, > load
       0d, F, 0c, R, Ks > copy cell index to 0c
       >5d, F, cell-index< F, 0h, Ks > move top 5d to cell [index]

4c 5c: > - > 45
       0d, F, 0c, R, Ks > copy cell index to 0c
       >cell index,< F, 0c, F, 0h, Ks > move cell index [data] to 0c
       >cur data< F, As, F, Ac, Qs > cur-data--
       R, > load move
       0d, F, 0c, R, Ks > copy cell index to 0c
       >R, cell-index,< F, 0h, Ks > move top of R to cell index

4c 6c: > . > 46
       0d, F, 0c, R, Ks > copy cell index to 0c
       >cell index< F, 0c, F, 0h, Ks > move cell [index] to 0c
       >cur data< F, Ah, Qh > turn cur-data to heart
       R, > load
       0d, F, 0c, R, Ks > copy cell index to 0c
       >R, cell index,< F, 0h, Ks > move top of Stack to cell index
       0d, F, 0c, R, Ks > copy cell index to 0c
       F, Ac, Jd > print cell index

6c 0c: > < > 60
       0d, F, 0c, F, 0h, Ks > move cell index to 0c
       F, As, F, Ac, Qs > cell index--
       R, 0d, F, 0h, Ks > move top stack onto 0d
       >F, R, 0c, F, As, Ks > copy top stack onto 0c

6c 2c: > > > 62
       0d, F, 0c, F, 0h, Ks > move cell index to 0c
       F, As, F, As, Qs > cell index++
       R, 0d, F, 0h, Ks > move top stack onto 0d
       6c 3c, F, 6c 4c, F,> load if
       0d, F, 0c, F, R, Ks > Copy cell index to 0c
       F, 1d, F, 0c, F, R, Ks > Copy max cell index to 0c
       >cell index, F, max cell,< F, Ad, Qs > max cell = cell index?
       >6c 3c, F, 6c 4c, F, max=index< Qh > if max=index -63, else -64
       >-63 or -64< F, 0c, R, Ks > Copy 63 or 64 onto 0c

6c 3c: 1d, F, 0c, F, 0h, Ks > move max cell index to 0c
       F, As, F, As, Qc > max cell++
       R, 1d, F 0h, Ks > move new max cell to 1d
       0h, R, > load
       1d, F, 0c, R, Ks > copy max cell to 0c
       >R, max cell< F, 0h, Ks > move 0h from stack to max-cell
       

9c 1c: > [ > 91
       9c 2c F, 9c 0c F,
       0d, F, 0c, R, Ks > get copy of cell index
       >cell index< F, 0c, R, Ks > get value at deck [cell index]
       >value< F, 0s, F, Ad Qs > is value = 0
       >9c 2c F, 9c 0c F, val=0< Qh > if so, 92c, else 90
       F, 0c, R Ks > copy either 92c or 90c onto 0c

9c 2c: 2d, F, 0c, F 0h, Ks > move code index to 0c
       >code index< F, Ah Qd > hearted
       >[ key< F, 0c, R, Ks > get value at deck [code index]
       F, As, F, As, Qs > add 1
       R, 2d, F, 0h, Ks > set code index to resulting number

9c 3c: > ] > 93
       9c 5c F, 9c 4c F,
       0d, F, 0c, R, Ks > get copy of cell index
       >cell index< F, 0c, R, Ks > get value at deck [cell index]
       >value< F, 0s, F, Ad Qs > is value = 0
       >9c 5c F, 9c 4c F, val=0< Qh > if so, 95c, else 94c
       F, 0c, R Ks > copy either 95c or 94c onto 0c

9c 4c: 2d, F, 0c, F 0h, Ks > move code index to 0c
       >code index< F, Ah Qd > hearted
       >[ key< F, 0c, R, Ks > get value at deck [code index]
       R, 2d, F, 0h, Ks > set code index to resulting number 

>   +-.,[]<>
>variables & constants
0d: 0s > cell index
1d: As > largest cell tracker. +1 if reach new max
2d: 0s > code index
3d:    > code size
4d:    > bf code

>43-46 61-62 91 & 93
HERE
)

(parse-to-datum (apply-tokenizer make-tokenizer quine))
(parse-to-datum (apply-tokenizer make-tokenizer bf))