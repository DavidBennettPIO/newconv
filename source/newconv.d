module newconv;

import std.traits : isIntegral, isSigned, Unqual, Unsigned, isSomeChar,
    isSomeString;

@safe @nogc pure nothrow W[] writeCharsTo(T, W)(T input, scope W[] buf)
        if (isIntegral!(T))
{

    alias UT = Unqual!T;

    static if (isSigned!T)
    {
        uint neg = 0;
        Unsigned!UT v = void;
        if (input < 0)
        {
            v = cast(Unsigned!UT)(cast(UT)(0 - input));
            neg = 1;
            buf[0] = '-';
        }
        else
        {
            v = cast(Unsigned!UT) input;
        }
    }
    else
    {
        alias v = input;
        enum neg = 0;
    }

    if (v < 100)
    {
        if (v < 10)
        {
            buf[neg + 0] = cast(char)(cast(uint) v + '0');
            return buf[0 .. neg + 1];
        }
        buf[neg + 0] = cast(char)(cast(uint) v / 10 + '0');
        buf[neg + 1] = cast(char)(cast(uint) v % 10 + '0');
        return buf[0 .. neg + 2];
    }

    static if (UT.sizeof == 1)
    {
        // byte and ubyte can only have 3 digits so we dont need to go any further
        buf[neg + 0] = cast(char)(cast(uint) v / 100 + '0');
        buf[neg + 1] = cast(char)(cast(uint) v / 10 % 10 + '0');
        buf[neg + 2] = cast(char)(cast(uint) v % 10 + '0');
        return buf[0 .. neg + 3];
    }else{

        uint l;

        if (UT.sizeof > 4 && v >= 10000000000U)
        {
            l = (v >= 10000000000000000000U) ? 20 : (v >= 100000000000000000U) ? 19
                : (v >= 100000000000000000U) ? 18 : (v >= 10000000000000000) ? 17
                : (v >= 1000000000000000) ? 16 : (v >= 100000000000000) ? 15
                : (v >= 10000000000000) ? 14 : (v >= 1000000000000) ? 13
                : (v >= 100000000000) ? 12 : 11;
        } else if (UT.sizeof > 2 && v >= 100000U){
            l = (v >= 1000000000) ? 10 : (v >= 100000000) ? 9
                : (v >= 10000000) ? 8 : (v >= 1000000) ? 7 : 6;
        } else {
            l = (v >= 10000) ? 5 : (v >= 1000) ? 4 : 3;
        }

        l += neg;

        uint i = l;

        do
        {
            buf[--i] = cast(char)(cast(uint)(v % 10) + '0');
        }
        while ((v /= 10) > 9);

        buf[neg + 0] = cast(char)(cast(uint) v + '0');

        return buf[0 .. l];

    }

}

@safe @nogc pure nothrow W[] writeCharsToRTL(T, W)(T input, scope W[] buf)
if (isIntegral!(T))
{

    alias UT = Unqual!T;
    enum signed = isSigned!T;

    static if (isSigned!T)
    {
        uint neg = 0;
        Unsigned!UT v = void;
        if (input < 0)
        {
            v = cast(Unsigned!UT)(cast(UT)(0 - input));
            neg = 1;

        }
        else
        {
            v = cast(Unsigned!UT) input;
        }
    }
    else
    {
        alias v = input;
        enum neg = 0;
    }

    if (v < 100)
    {
        if (v < 10)
        {
            buf[$-1] = cast(char)(cast(uint) v + '0');
            if(neg != 0)
            {
                buf[$-2] = '-';
                return buf[$-2 .. $];
            }else{
                return buf[$-1 .. $];
            }
        }
        buf[$-1] = cast(char)((cast(uint) v / 10) + '0');
        buf[$-2] = cast(char)((cast(uint) v % 10) + '0');
        if(neg != 0)
        {
            buf[$-3] = '-';
            return buf[$-3 .. $];
        }else{
            return buf[$-2 .. $];
        }
    }

    static if (UT.sizeof == 1)
    {
        // byte and ubyte can only have 3 digits so we dont need to go any further
        buf[$-1] = cast(char)(cast(uint) v / 100 + '0');
        buf[$-2] = cast(char)(cast(uint) v / 10 % 10 + '0');
        buf[$-3] = cast(char)(cast(uint) v % 10 + '0');
        if(neg != 0)
        {
            buf[$-4] = '-';
            return buf[$-4 .. $];
        }else{
            return buf[$-3 .. $];
        }
    }else{

        size_t l = buf.length;

        do
        {
            buf[--l] = cast(char)(cast(uint)(v % 10) + '0');
        }
        while ((v /= 10) > 9);

        buf[--l] = cast(char)(cast(uint) v + '0');

        if(neg != 0)
        {
            buf[--l] = '-';
        }

        return buf[l .. $];

    }

}

@safe unittest
{

    ubyte[80] stack_buffer;

    char[] buffer = cast(char[]) stack_buffer[];
    wchar[] wbuffer = cast(wchar[]) stack_buffer[];
    dchar[] dbuffer = cast(dchar[]) stack_buffer[];

    import std.meta : AliasSeq;

    static foreach (buf; AliasSeq!(buffer, wbuffer, dbuffer))
    {
        static foreach (input_type; AliasSeq!(byte, ubyte, short, ushort, int, uint, long, ulong))
        {
            assert((cast(input_type) 0).writeCharsTo(buf) == "0");
            assert((cast(input_type) 1).writeCharsTo(buf) == "1");
            assert((cast(input_type) 9).writeCharsTo(buf) == "9");
            assert((cast(input_type) 10).writeCharsTo(buf) == "10");
            assert((cast(input_type) 99).writeCharsTo(buf) == "99");
            assert((cast(input_type) 100).writeCharsTo(buf) == "100");
            assert((cast(input_type) 127).writeCharsTo(buf) == "127");
        }

        static foreach (input_type; AliasSeq!(ubyte, short, ushort, int, uint, long, ulong))
        {
            assert((cast(input_type) 128).writeCharsTo(buf) == "128");
            assert((cast(input_type) 254).writeCharsTo(buf) == "254");
            assert((cast(input_type) 255).writeCharsTo(buf) == "255");
        }

        static foreach (input_type; AliasSeq!(short, ushort, int, uint, long, ulong))
        {
            assert((cast(input_type) 256).writeCharsTo(buf) == "256");
            assert((cast(input_type) 299).writeCharsTo(buf) == "299");
            assert((cast(input_type) 300).writeCharsTo(buf) == "300");
            assert((cast(input_type) 999).writeCharsTo(buf) == "999");
            assert((cast(input_type) 1000).writeCharsTo(buf) == "1000");
            assert((cast(input_type) 9999).writeCharsTo(buf) == "9999");
            assert((cast(input_type) 10000).writeCharsTo(buf) == "10000");
            assert((cast(input_type) 32767).writeCharsTo(buf) == "32767");
        }

        static foreach (input_type; AliasSeq!(ushort, int, uint, long, ulong))
        {
            assert((cast(input_type) 32768).writeCharsTo(buf) == "32768");
            assert((cast(input_type) 65535).writeCharsTo(buf) == "65535");
        }

        static foreach (input_type; AliasSeq!(int, uint, long, ulong))
        {
            assert((cast(input_type) 65536).writeCharsTo(buf) == "65536");
            assert((cast(input_type) 99999).writeCharsTo(buf) == "99999");
            assert((cast(input_type) 100000).writeCharsTo(buf) == "100000");
            assert((cast(input_type) 999999999).writeCharsTo(buf) == "999999999");
            assert((cast(input_type) 1000000000).writeCharsTo(buf) == "1000000000");
            assert((cast(input_type) 1234567890).writeCharsTo(buf) == "1234567890");
            assert((cast(input_type) 2147483647).writeCharsTo(buf) == "2147483647");
        }

        static foreach (input_type; AliasSeq!(uint, long, ulong))
        {
            assert((cast(input_type) 2147483648).writeCharsTo(buf) == "2147483648");
            assert((cast(input_type) 4294967295).writeCharsTo(buf) == "4294967295");
        }

        static foreach (input_type; AliasSeq!(long, ulong))
        {
            assert((cast(input_type) 4294967296).writeCharsTo(buf) == "4294967296");
            assert((cast(input_type) 9999999999).writeCharsTo(buf) == "9999999999");
            assert((cast(input_type) 10000000000).writeCharsTo(buf) == "10000000000");
            assert((cast(input_type) 9223372036854775807).writeCharsTo(buf) == "9223372036854775807");
        }

        assert(9223372036854775808UL.writeCharsTo(buf) == "9223372036854775808");
        assert(18446744073709551615UL.writeCharsTo(buf) == "18446744073709551615");

        static foreach (input_type; AliasSeq!(byte, short, int, long))
        {
            assert((cast(input_type)-0).writeCharsTo(buf) == "0");
            assert((cast(input_type)-1).writeCharsTo(buf) == "-1");
            assert((cast(input_type)-9).writeCharsTo(buf) == "-9");
            assert((cast(input_type)-10).writeCharsTo(buf) == "-10");
            assert((cast(input_type)-99).writeCharsTo(buf) == "-99");
            assert((cast(input_type)-100).writeCharsTo(buf) == "-100");
            assert((cast(input_type)-127).writeCharsTo(buf) == "-127");
            assert((cast(input_type)-128).writeCharsTo(buf) == "-128");
        }

        static foreach (input_type; AliasSeq!(short, int, long))
        {
            assert((cast(input_type)-129).writeCharsTo(buf) == "-129");
            assert((cast(input_type)-255).writeCharsTo(buf) == "-255");
            assert((cast(input_type)-256).writeCharsTo(buf) == "-256");
            assert((cast(input_type)-999).writeCharsTo(buf) == "-999");
            assert((cast(input_type)-1000).writeCharsTo(buf) == "-1000");
            assert((cast(input_type)-9999).writeCharsTo(buf) == "-9999");
            assert((cast(input_type)-10000).writeCharsTo(buf) == "-10000");
            assert((cast(input_type)-32767).writeCharsTo(buf) == "-32767");
            assert((cast(input_type)-32768).writeCharsTo(buf) == "-32768");
        }

        static foreach (input_type; AliasSeq!(int, long))
        {
            assert((cast(input_type)-65536).writeCharsTo(buf) == "-65536");
            assert((cast(input_type)-99999).writeCharsTo(buf) == "-99999");
            assert((cast(input_type)-100000).writeCharsTo(buf) == "-100000");
            assert((cast(input_type)-999999999).writeCharsTo(buf) == "-999999999");
            assert((cast(input_type)-1000000000).writeCharsTo(buf) == "-1000000000");
            assert((cast(input_type)-1234567890).writeCharsTo(buf) == "-1234567890");
            assert((cast(input_type)-2147483647).writeCharsTo(buf) == "-2147483647");
        }

        static foreach (input_type; AliasSeq!(long))
        {
            assert((cast(input_type)-2147483648).writeCharsTo(buf) == "-2147483648");
            assert((cast(input_type)-4294967295).writeCharsTo(buf) == "-4294967295");
            assert((cast(input_type)-4294967296).writeCharsTo(buf) == "-4294967296");
            assert((cast(input_type)-9999999999).writeCharsTo(buf) == "-9999999999");
            assert((cast(input_type)-10000000000).writeCharsTo(buf) == "-10000000000");
            assert((cast(input_type)-9223372036854775807)
                    .writeCharsTo(buf) == "-9223372036854775807");
        }

        //assert((-9223372036854775808L).writeCharsTo(buf) == "-9223372036854775808");

    }

    assert((cast(char[]) 1234567890.writeCharsTo(buffer[])).length == 10);
    assert((cast(char[]) 1234567890.writeCharsTo(wbuffer[])).length == 20);
    assert((cast(char[]) 1234567890.writeCharsTo(dbuffer[])).length == 40);

    static assert((-1).writeCharsTo(new char[20]) == "-1");
    static assert((-1).writeCharsTo(new wchar[20]) == "-1");
    static assert((-1).writeCharsTo(new dchar[20]) == "-1");

    static assert(1234567890.writeCharsTo(new char[20]) == "1234567890");
    static assert(1234567890.writeCharsTo(new wchar[20]) == "1234567890");
    static assert(1234567890.writeCharsTo(new dchar[20]) == "1234567890");

    static assert(1234567890.writeCharsTo(new char[20]) == "1234567890");
    static assert(1234567890.writeCharsTo(new wchar[20]) == "1234567890");
    static assert((-9223372036854775807L).writeCharsTo(new dchar[20]) == "-9223372036854775807");

}

// @nogc nothrow
@safe pure W[] writeCharsTo(T, W)(T input, scope W[] buf)
        if (isSomeChar!T)
{
    enum dchar replacementDchar = '\uFFFD';

    if(
        (T.sizeof == 1 && input >= 0x80) ||
        (T.sizeof == 4 && input > 0x10FFFF) ||
        (T.sizeof >= 2 && (input >= 0xD800 && input <= 0xDFFF))
    )
    {
        debug {
            enum error = "Attempted to use an invalid or partual UTF-"~(T.sizeof*8).writeCharsTo(new char[2])~" code point.";
            assert(0, error);
        }
        return replacementDchar.writeCharsTo(buf);
    }

    import std.utf : encode;

    static if (W.sizeof == 4)
    {
        encode(cast(dchar[1])buf[0..1], cast(dchar)input);
        return buf[0 .. 1];
    } else static if(W.sizeof == 2){
        size_t l = encode(cast(wchar[2])buf[0..2], cast(dchar)input);
        return buf[0 .. l];
    } else static if(W.sizeof == 1){
        size_t l = encode(cast(char[4])buf[0..4], cast(dchar)input);
        return buf[0 .. l];
    }

    //// below is a working @nogc nothrow version
    //
    //alias UW = Unqual!W;
    //alias UT = Unqual!T;
    //alias c = input;
    //
    //static if(UW.sizeof < UT.sizeof)
    //{
    //    static if (UW.sizeof == 2)
    //    {
    //        if(c > 0xFFFF) // wchar to char[2]
    //        {
    //            buf[0] = cast(wchar)((((c - 0x10000) >> 10) & 0x3FF) + 0xD800);
    //            buf[1] = cast(wchar)(((c - 0x10000) & 0x3FF) + 0xDC00);
    //            return buf[0 .. 2];
    //        }
    //    }
    //    else
    //    {
    //        if(c >= 0x80)
    //        {
    //            if (c <= 0x7FF)
    //            {
    //                buf[0] = cast(char)(0xC0 | (c >> 6));
    //                buf[1] = cast(char)(0x80 | (c & 0x3F));
    //                return buf[0 .. 2];
    //            }
    //            if (c <= 0xFFFF)
    //            {
    //                buf[0] = cast(char)(0xE0 | (c >> 12));
    //                buf[1] = cast(char)(0x80 | ((c >> 6) & 0x3F));
    //                buf[2] = cast(char)(0x80 | (c & 0x3F));
    //                return buf[0 .. 3];
    //            }
    //            if (c <= 0x10FFFF)
    //            {
    //                buf[0] = cast(char)(0xF0 | (c >> 18));
    //                buf[1] = cast(char)(0x80 | ((c >> 12) & 0x3F));
    //                buf[2] = cast(char)(0x80 | ((c >> 6) & 0x3F));
    //                buf[3] = cast(char)(0x80 | (c & 0x3F));
    //                return buf[0 .. 4];
    //            }
    //        }
    //    }
    //}
    //
    //// T fits in a single W with no conversion needed.
    //buf[0] = cast(W) c;
    //return buf[0 .. 1];

}

@safe unittest
{

    char[80] stack_buffer;

    char[] buffer = cast(char[]) stack_buffer[];
    wchar[] wbuffer = cast(wchar[]) stack_buffer[];
    dchar[] dbuffer = cast(dchar[]) stack_buffer[];

    import std.meta : AliasSeq;

    static foreach (buf; AliasSeq!(buffer, wbuffer, dbuffer))
    {
        static foreach (input_type; AliasSeq!(char, wchar, dchar))
        {
            assert((cast(input_type) 0).writeCharsTo!()(buf) == "\x00");
            assert((cast(input_type) 'a').writeCharsTo!()(buf) == "a");
            assert((cast(input_type) '\u007F').writeCharsTo!()(buf) == "\u007F");
        }

        assert((cast(char) '\u0080').writeCharsTo!()(buf) == "\xEF\xBF\xBD", "Expected \uFFFD");

        static foreach (input_type; AliasSeq!(wchar, dchar))
        {
            assert((cast(input_type) '\u0080').writeCharsTo!()(buf) == "\u0080");
            assert((cast(input_type) '\uE000').writeCharsTo!()(buf) == "\uE000");
            assert((cast(input_type) 'デ').writeCharsTo!()(buf) == "デ");
            assert((cast(input_type) 'ë').writeCharsTo!()(buf) == "ë");
        }

        static foreach (input_type; AliasSeq!(dchar))
        {
            assert((cast(input_type) '\U00010000').writeCharsTo!()(buf) == "\U00010000");
            assert((cast(input_type) '\U0010FFFF').writeCharsTo!()(buf) == "\U0010FFFF");
        }

    }

    static assert(('デ').writeCharsTo(new char[4]) == "デ");
    static assert(('デ').writeCharsTo(new wchar[4]) == "デ");
    static assert(('デ').writeCharsTo(new wchar[4]) == "デ");

    static assert(('\u0000').writeCharsTo(new char[4]) == "\u0000");
    static assert(('\u007F').writeCharsTo(new char[4]) == "\u007F");
    static assert(('\u0080').writeCharsTo(new char[4]) == "\u0080");
    static assert(('\uE000').writeCharsTo(new char[4]) == "\uE000");
    static assert((cast(wchar)0xFFFE).writeCharsTo(new char[4]) == "\xEF\xBF\xBE");
    static assert((cast(wchar)0xFFFF).writeCharsTo(new char[4]) == "\xEF\xBF\xBF");
    static assert(('\U00010000').writeCharsTo(new char[4]) == "\U00010000");
    static assert(('\U0010FFFF').writeCharsTo(new char[4]) == "\U0010FFFF");

    assert('\u0000'.writeCharsTo(buffer).length == 1 && buffer[0 .. 1] == "\u0000");
    assert('\u007F'.writeCharsTo(buffer).length == 1 && buffer[0 .. 1] == "\u007F");
    assert('\u0080'.writeCharsTo(buffer).length == 2 && buffer[0 .. 2] == "\u0080");
    assert('\uE000'.writeCharsTo(buffer).length == 3 && buffer[0 .. 3] == "\uE000");
    assert((cast(wchar)0xFFFE).writeCharsTo(buffer).length == 3 && buffer[0 .. 3] == "\xEF\xBF\xBE");
    assert((cast(wchar)0xFFFF).writeCharsTo(buffer).length == 3 && buffer[0 .. 3] == "\xEF\xBF\xBF");
    assert('\U00010000'.writeCharsTo(buffer).length == 4 && buffer[0 .. 4] == "\U00010000");
    assert('\U0010FFFF'.writeCharsTo(buffer).length == 4 && buffer[0 .. 4] == "\U0010FFFF");

    assert('\u0000'.writeCharsTo(wbuffer).length == 1 && wbuffer[0 .. 1] == "\u0000");
    assert('\uD7FF'.writeCharsTo(wbuffer).length == 1 && wbuffer[0 .. 1] == "\uD7FF");
    assert('\uE000'.writeCharsTo(wbuffer).length == 1 && wbuffer[0 .. 1] == "\uE000");
    assert('\U00010000'.writeCharsTo(wbuffer).length == 2 && wbuffer[0 .. 2] == "\U00010000");
    assert('\U0010FFFF'.writeCharsTo(wbuffer).length == 2 && wbuffer[0 .. 2] == "\U0010FFFF");


}

// @nogc nothrow
@safe pure W[] writeCharsTo(T, W)(T[] input, return scope W[] buf)
if(isSomeChar!T)
//if(isSomeString!T)
{


    //alias UW = Unqual!W;
    //alias UT = ElementType!(UT!T);

    static if (T.sizeof == W.sizeof)
    {
        buf[0..input.length] = input[];
        return buf[0..input.length];
    }
    else
    {
        size_t l=0;
        //for(size_t i=0; i<input.length; i++){
        //    l += input[i].writeCharsTo(buf[l..$]).length;
        //}

        import std.range.primitives;
        foreach(c; input){
            l += c.writeCharsTo(buf[l..$]).length;
        }
        return buf[0..l];
    }

}

@safe unittest{

    char[80] stack_buffer;

    char[] buffer = cast(char[]) stack_buffer[];
    wchar[] wbuffer = cast(wchar[]) stack_buffer[];
    dchar[] dbuffer = cast(dchar[]) stack_buffer[];

    import std.meta : AliasSeq;

    static foreach (buf; AliasSeq!(buffer, wbuffer, dbuffer))
    {
        static foreach (input_type; AliasSeq!(string, wstring, dstring))
        {
            assert((cast(input_type) "\x00\x00").writeCharsTo(buf) == "\x00\x00");
            assert((cast(input_type) "hello").writeCharsTo(buf) == "hello");
            //pragma(msg, typeof(buf), " ", input_type, " ", (cast(input_type) "今日は").writeCharsTo(new char[32]));
            //assert((cast(input_type) "今日は").writeCharsTo(buf) == "今日は");
        }
    }

    //
    //static assert("\U00010000\U0010FFFF".writeCharsTo(new char[8]) == "\U00010000\U0010FFFF");
    //static assert("\U00010000\U0010FFFF".writeCharsTo(new wchar[4]) == "\U00010000\U0010FFFF");
    //static assert("\U00010000\U0010FFFF".writeCharsTo(new dchar[4]) == "\U00010000\U0010FFFF");
    //
    ////enum test = (cast(dstring)"\U00010000\U0010FFFF").writeCharsTo(new char[8]);
    ////pragma(msg, test, test.length, test == "\U00010000\U0010FFFF");
    //
    //assert("\U00010000\U0010FFFF".writeCharsTo(buffer).length == 8 && buffer[0 .. 8] == "\U00010000\U0010FFFF");
    //assert("\U00010000\U0010FFFF".writeCharsTo(wbuffer).length == 4 && wbuffer[0 .. 4] == "\U00010000\U0010FFFF");
    //assert("\U00010000\U0010FFFF".writeCharsTo(dbuffer).length == 2 && dbuffer[0 .. 2] == "\U00010000\U0010FFFF");


}
