## PB002 --- UNROLLED + DIV 10

| cycles | size | activity |
| ------ | ---- | -------- |
| 134 | 44 | 13 |
<hr>
<br>

**XA**

```
LINK 800
GRAB 200
COPY F M
WIPE
MAKE
LINK 800


MARK LOOP
@REP 5
 COPY M F
@END
JUMP LOOP

```

<br>

**XB**

```
NOOP
LINK 800
COPY M X


REPL LOOP_2
REPL LOOP_3
REPL LOOP_4
REPL LOOP_5
JUMP LOOP_1


MARK LOOP_2
SUBI X 0 X
JUMP LOOP

MARK LOOP_3
SUBI X 1 X
JUMP LOOP

MARK LOOP_4
SUBI X 2 X
JUMP LOOP

MARK LOOP_5
SUBI X 3 X
JUMP LOOP

MARK LOOP_1
SUBI X 4 X
JUMP LOOP


MARK LOOP
COPY X M
SUBI X 5 X
NOOP
TEST X < 0
FJMP LOOP
LINK 800
KILL
```
