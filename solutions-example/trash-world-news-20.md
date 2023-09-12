## PB002 --- UNROLLED + DIV 10

| cycles | size | activity |
| ------ | ---- | -------- |
| 289 | 49 | 2 |
<hr>
<br>

**XA**

```
LINK 800
GRAB 200
COPY F X
WIPE

MAKE


COPY X F
SUBI X 1 X
COPY X F
SUBI X 1 X
COPY X F
SUBI X 1 X
COPY X F
SUBI X 1 X
COPY X F
SUBI X 1 X
COPY X F
SUBI X 1 X

MARK LOOP
 DIVI X 10 T
 TEST T > 0
 FJMP ONE_BY_ONE

 COPY X F
 SUBI X 1 X
 COPY X F
 SUBI X 1 X
 COPY X F
 SUBI X 1 X
 COPY X F
 SUBI X 1 X
 COPY X F
 SUBI X 1 X
 COPY X F
 SUBI X 1 X
 COPY X F
 SUBI X 1 X
 COPY X F
 SUBI X 1 X
 COPY X F
 SUBI X 1 X
 COPY X F
 SUBI X 1 X

 TEST X = -1
 FJMP LOOP


MARK ONE_BY_ONE
COPY X F
 SUBI X 1 X
 TEST X = -1
 FJMP LOOP


LINK 800
```
