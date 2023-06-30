## PB023 --- CYCLES

| cycles | size | activity |
| ------ | ---- | -------- |
| 121 | 71 | 14 |
<hr>
<br>

**DA**

```
; FILE DATA SENDER

LINK 800
GRAB 199
@REP 6
COPY F M
@END


MARK LOOP
COPY F M
TEST EOF
FJMP LOOP


DROP
```

<br>

**PR**

```
; PROCESSING

NOOP
LINK 800


MARK LOOP
TEST MRD
FJMP KILL
GRAB M


SEEK 1
ADDI F F X
ADDI X F X
DIVI X 3 T;(BA+ZA+APB)/3

MULI F F X
DIVI X F X;(WRT*OI)/OD
REPL LOOP
ADDI X T T

SUBI F F X
MULI X 20 X;(PC-PS)*20
ADDI X T T
SEEK -9999
COPY F X
DROP


LINK -1
MODE
;MAKE
COPY T M
COPY X M
HALT





MARK KILL
LINK -1
@REP 11
NOOP
@END
KILL
GRAB 400
VOID F
HALT
```

<br>

**XA**

```
MAKE
COPY 0 F
SEEK -9999


MARK LOOP
COPY M X
TEST F < X
TJMP NEW_BEST
VOID M
SEEK -9999
JUMP LOOP



MARK NEW_BEST
COPY M F
SEEK -9999
COPY X F
SEEK -9999
JUMP LOOP
```