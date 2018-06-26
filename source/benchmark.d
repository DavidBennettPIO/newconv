import newconv;

pragma(inline, false) O newTo(O, T)(T arg)
{
	import std.array : uninitializedArray;
	import std.conv : to, toChars;

	char[] buf = uninitializedArray!(char[])(20);
	size_t length = arg.writeCharsTo(buf).length;

	return cast(string) buf[0..length];
}

pragma(inline, false) string newText(Args...)(Args args)
{

    import std.array : appender;
    auto app = appender!string();
    app.reserve(Args[0].sizeof*4*8);

    char[20] buf;

    static foreach(arg; args)
    {
        app.put(arg.writeCharsTo(buf[]));
    }

    return cast(string) app.data;
}

pragma(inline, false) size_t writeCharsToConvert(T)(T arg){
    char[20] buf;
    return arg.writeCharsTo(buf[]).length;
}

pragma(inline, false) string writeCharsToConcat(Args...)(Args args)
{
    import std.array : uninitializedArray;
    char[] buf = uninitializedArray!(char[])(Args[0].sizeof*4*8);
    size_t length = 0;

    static foreach(arg; args)
    {
        length += arg.writeCharsTo(buf[length..$]).length;
    }

    return cast(string) buf[0..length];
}

pragma(inline, false) size_t convert(string formixin, alias data)(){
	import std.conv : to, toChars;

	size_t length;

    static foreach (i; 0..8){
        mixin(`length += `~formixin);
    }

	return length;
}

pragma(inline, false) string concat(string formixin, alias d)(){
	import std.conv : text;
    mixin(`return `~formixin~`(d[0],d[1],d[2],d[3],d[4],d[5],d[6],d[7]);`);

}

auto benchmarkData(T, string fname="convert", Args...)()
{
	import std.datetime.stopwatch : benchmark;
    import std.random : uniform;
    import std.range : generate, takeExactly;
    import std.array : array;

    auto data = generate!(() => uniform(cast(T)T.min, cast(T)(T.max/2-1))).takeExactly(8).array;

    static if(fname == "convert"){
        auto w = benchmark!(
            convert!(Args[0], data),
            convert!(Args[1], data),
            convert!(Args[2], data)
        )(1000000);
    } else static if(fname == "concat"){
        auto w = benchmark!(
            concat!(Args[0], data),
            concat!(Args[1], data),
            concat!(Args[2], data)
        )(1000000);
    }

    return [
        w[0].total!("msecs"),
        w[1].total!("msecs"),
        w[2].total!("msecs")
    ];

}

void main()
{
    import std.stdio : writeln;

    import std.range.primitives;
    import std.meta : AliasSeq;

    auto w = benchmarkData!(ubyte, "convert",
        "data[i].to!(string).length;",
        "data[i].newTo!(string).length;",
        "data[i].writeCharsToConvert();"
    );

    char[73] base;
    char[73] row;

    writeln("|-----------------------------------------------------------------------|");
    writeln("| <convert>       .to!(string) |   .newTo!(string) | .writeCharsTo(buf) |");
    writeln("|-----------------------------------------------------------------------|");
    base =  "|          :                ms |                ms |                 ms |";

    // runtime data to help pervent compiler inlining and unrolling
    static foreach (T; AliasSeq!(ubyte, ushort, uint, ulong, byte, short, int, long, char, wchar, dchar))
    {
        //w = benchmarkData(generate!(() => is(T==char)? uniform!T & 127 : uniform!T).takeExactly(64).array);
        w = benchmarkData!(T, "convert",
            "data[i].to!(string).length;",
            "data[i].newTo!(string).length;",
            "data[i].writeCharsToConvert();"
        );

        row[] = base[];

        T.stringof.writeCharsTo(row[2..$]);
        w[0].writeCharsToRTL(row[0..27]);
        w[1].writeCharsToRTL(row[0..47]);
        w[2].writeCharsToRTL(row[0..68]);

        writeln(row);
    }

    writeln("|-----------------------------------------------------------------------|");

    writeln("");

    writeln("|-----------------------------------------------------------------------|");
    writeln("| <concat>           text(...) |      newText(...) | .writeCharsTo(buf) |");
    writeln("|-----------------------------------------------------------------------|");
    base =  "|          :                ms |                ms |                 ms |";

    // runtime data to help pervent compiler inlining and unrolling
    static foreach (T; AliasSeq!(ubyte, ushort, uint, ulong, byte, short, int, long, char, wchar, dchar))
    {
        //w = benchmarkData(generate!(() => is(T==char)? uniform!T & 127 : uniform!T).takeExactly(64).array);
        w = benchmarkData!(T, "concat",
            "text",
            "newText",
            "writeCharsToConcat"
        );

        row[] = base[];

        T.stringof.writeCharsTo(row[2..$]);
        w[0].writeCharsToRTL(row[0..27]);
        w[1].writeCharsToRTL(row[0..47]);
        w[2].writeCharsToRTL(row[0..68]);

        writeln(row);
    }

    writeln("|-----------------------------------------------------------------------|");

}
