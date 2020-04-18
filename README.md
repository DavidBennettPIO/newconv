

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
| ubyte    :            721 ms |            505 ms |              38 ms |
| ushort   :            957 ms |            555 ms |             123 ms |
| uint     :           1334 ms |            629 ms |             147 ms |
| ulong    :           2000 ms |            702 ms |             270 ms |
| byte     :            784 ms |            575 ms |              49 ms |
| short    :            984 ms |            593 ms |             120 ms |
| int      :           1413 ms |            626 ms |             153 ms |
| long     :           2062 ms |            769 ms |             275 ms |
| float    :           5272 ms |            946 ms |             480 ms |
| double   :           5617 ms |            957 ms |             482 ms |
| real     :           5537 ms |            965 ms |             510 ms |
| char     :           1362 ms |            486 ms |              61 ms |
| wchar    :           1433 ms |            525 ms |              51 ms |
| dchar    :           1409 ms |            520 ms |              59 ms |
|-----------------------------------------------------------------------|

|-----------------------------------------------------------------------|
| <concat>           text(...) |      newText(...) | .writeCharsTo(buf) |
|-----------------------------------------------------------------------|
| ubyte    :            934 ms |             88 ms |              53 ms |
| ushort   :           1144 ms |            165 ms |             136 ms |
| uint     :           1500 ms |            226 ms |             179 ms |
| ulong    :           2076 ms |            376 ms |             307 ms |
| byte     :            997 ms |            105 ms |              67 ms |
| short    :           1215 ms |            173 ms |             142 ms |
| int      :           1536 ms |            227 ms |             179 ms |
| long     :           2005 ms |            374 ms |             317 ms |
| float    :           5725 ms |            707 ms |             850 ms |
| double   :           5734 ms |            670 ms |             748 ms |
| real     :           5754 ms |            564 ms |             865 ms |
| char     :            212 ms |             91 ms |              48 ms |
| wchar    :            250 ms |            110 ms |              69 ms |
| dchar    :            248 ms |            145 ms |              79 ms |
|-----------------------------------------------------------------------|
```

**LDC**

```
|-----------------------------------------------------------------------|
| <convert>       .to!(string) |   .newTo!(string) | .writeCharsTo(buf) |
|-----------------------------------------------------------------------|
| ubyte    :            456 ms |            404 ms |              11 ms |
| ushort   :            495 ms |            431 ms |              31 ms |
| uint     :            657 ms |            514 ms |              52 ms |
| ulong    :            873 ms |            535 ms |             218 ms |
| byte     :            504 ms |            431 ms |              17 ms |
| short    :            556 ms |            450 ms |              38 ms |
| int      :            683 ms |            476 ms |              99 ms |
| long     :            940 ms |            585 ms |             221 ms |
| float    :           4650 ms |           1174 ms |             403 ms |
| double   :           4551 ms |            780 ms |             512 ms |
| real     :           4800 ms |            802 ms |             641 ms |
| char     :           1166 ms |            382 ms |              11 ms |
| wchar    :           1209 ms |            405 ms |              28 ms |
| dchar    :           1220 ms |            415 ms |              31 ms |
|-----------------------------------------------------------------------|

|-----------------------------------------------------------------------|
| <concat>           text(...) |      newText(...) | .writeCharsTo(buf) |
|-----------------------------------------------------------------------|
| ubyte    :            674 ms |             66 ms |              26 ms |
| ushort   :            704 ms |            102 ms |              30 ms |
| uint     :            927 ms |            159 ms |              48 ms |
| ulong    :           1120 ms |            295 ms |             244 ms |
| byte     :            764 ms |             76 ms |              11 ms |
| short    :            782 ms |            110 ms |              35 ms |
| int      :            904 ms |            157 ms |             105 ms |
| long     :           1183 ms |            298 ms |             245 ms |
| float    :           4887 ms |            775 ms |             775 ms |
| double   :           4892 ms |            759 ms |             798 ms |
| real     :           5096 ms |            698 ms |             808 ms |
| char     :            102 ms |             59 ms |               8 ms |
| wchar    :            208 ms |             80 ms |              31 ms |
| dchar    :            220 ms |            106 ms |              43 ms |
|-----------------------------------------------------------------------|
```