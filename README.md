

## How to run the benchmark

Clone this repo and cd into the directory, then run one of the two commands.

* DMD:  `dmd -O -release -inline -i -I=source -dip1000 source/benchmark.d && ./benchmark`
* LDC:  `ldc2 -O3 -release -I=source -dip1000 source/benchmark.d && ./benchmark`

You should see results like this:

**DMD**

```
|-----------------------------------------------------------------------|
| <convert>       .to!(string) |   .newTo!(string) | .writeCharsTo(buf) |
|-----------------------------------------------------------------------|
| ubyte    :           1856 ms |           1037 ms |             201 ms |
| ushort   :           2336 ms |           1350 ms |             382 ms |
| uint     :           3415 ms |           1538 ms |             669 ms |
| ulong    :           6171 ms |           2275 ms |            1398 ms |
| byte     :           1908 ms |           1044 ms |             227 ms |
| short    :           2234 ms |           1364 ms |             406 ms |
| int      :           3560 ms |           1603 ms |             629 ms |
| long     :           6276 ms |           2219 ms |            1369 ms |
| char     :           3013 ms |           1061 ms |             181 ms |
| wchar    :           3285 ms |           1043 ms |             242 ms |
| dchar    :           3211 ms |           1048 ms |             277 ms |
|-----------------------------------------------------------------------|

|-----------------------------------------------------------------------|
| <concat>           text(...) |      newText(...) | .writeCharsTo(buf) |
|-----------------------------------------------------------------------|
| ubyte    :           2643 ms |            937 ms |             254 ms |
| ushort   :           3237 ms |           1173 ms |             530 ms |
| uint     :           5144 ms |           1448 ms |             738 ms |
| ulong    :           9854 ms |           2126 ms |            1427 ms |
| byte     :           2805 ms |            951 ms |             310 ms |
| short    :           3272 ms |           1268 ms |             583 ms |
| int      :           5548 ms |           1456 ms |             819 ms |
| long     :          10303 ms |           2182 ms |            1488 ms |
| char     :           3853 ms |            891 ms |             258 ms |
| wchar    :           4151 ms |            940 ms |             263 ms |
| dchar    :           3945 ms |            949 ms |             352 ms |
|-----------------------------------------------------------------------|
```

**LDC**

```
|-----------------------------------------------------------------------|
| <convert>       .to!(string) |   .newTo!(string) | .writeCharsTo(buf) |
|-----------------------------------------------------------------------|
| ubyte    :           1003 ms |           1011 ms |              88 ms |
| ushort   :            959 ms |            772 ms |             163 ms |
| uint     :           1519 ms |           1237 ms |             382 ms |
| ulong    :           2030 ms |           1484 ms |             735 ms |
| byte     :            899 ms |            886 ms |             121 ms |
| short    :           1115 ms |           1061 ms |             189 ms |
| int      :           1267 ms |           1041 ms |             390 ms |
| long     :           2030 ms |           1596 ms |             852 ms |
| char     :           1958 ms |            755 ms |              28 ms |
| wchar    :           1945 ms |            836 ms |             129 ms |
| dchar    :           2141 ms |            850 ms |             142 ms |
|-----------------------------------------------------------------------|

|-----------------------------------------------------------------------|
| <concat>           text(...) |      newText(...) | .writeCharsTo(buf) |
|-----------------------------------------------------------------------|
| ubyte    :           1248 ms |            448 ms |             164 ms |
| ushort   :           1676 ms |            612 ms |             290 ms |
| uint     :           1491 ms |            732 ms |             445 ms |
| ulong    :           2343 ms |           1074 ms |            1095 ms |
| byte     :           1288 ms |            506 ms |             143 ms |
| short    :           1494 ms |            656 ms |             311 ms |
| int      :           1315 ms |            633 ms |             388 ms |
| long     :           2540 ms |           1363 ms |            1044 ms |
| char     :           2528 ms |            411 ms |             189 ms |
| wchar    :           2600 ms |            506 ms |             149 ms |
| dchar    :           2697 ms |            452 ms |             167 ms |
|-----------------------------------------------------------------------|

```