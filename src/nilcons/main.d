module nilcons.main;

version (unittest)
{
    shared static this()
    {
        import core.runtime     : Runtime;
        import nilcons.util.tap : extendedModuleUnitTester;
        Runtime.extendedModuleUnitTester = &extendedModuleUnitTester;
    }

    nothrow pure @nogc @safe
    void main()
    {
    }
}

else version (nilconsServeApi)
    @safe
    void main()
    {
        import nilcons.api.implementation : Implementation;
        import nilcons.api.interface_ : serveCgi;
        import nilcons.util.io : Reader, Writer;
        import nilcons.util.os : getenv;
        import std.algorithm : joiner;

        // TODO: Surround with buffering wrapper.
        // TODO: Doing a syscall for each byte is unacceptable lmao.
        auto stdinR = Reader(0, 512);
        auto stdin  = joiner(&stdinR);

        // TODO: Surround with buffering wrapper.
        // TODO: Doing a syscall for each byte is unacceptable lmao.
        const stdout = Writer(1);

        const requestMethod = getenv("REQUEST_METHOD");
        const requestUri    = getenv("REQUEST_URI");
        const contentType   = getenv("CONTENT_TYPE");

        auto implementation = new Implementation();

        serveCgi(
            implementation,
            requestMethod,
            requestUri,
            contentType,
            stdin,
            stdout,
        );
    }

else
    static assert(false);
