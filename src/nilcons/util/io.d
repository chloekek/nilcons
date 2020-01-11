module nilcons.util.io;

import nilcons.util.os : read, write;
import std.range : empty;

/// Input range that calls read each time input is needed. The input range stores
/// (but does not own) a file descriptor, as well as a buffer into which the
/// bytes are read. The buffer is reused across calls.
struct Reader
{
private:
    int     fd;
    ubyte[] buf;
    size_t  len;

public:
    @disable this();
    @disable this(this);

    /// Initialize the reader with a file descriptor and a non-empty buffer.
    nothrow pure @nogc @safe
    this(int fd, ubyte[] buf)
    in
    {
        assert(buf.length > 0);
    }
    do
    {
        this.fd  = fd;
        this.buf = buf;
        this.len = 0;
    }

    /// ditto
    nothrow pure @safe
    this(int fd, size_t bufSize)
    in
    {
        assert(bufSize > 0);
    }
    do
    {
        this(fd, new ubyte[bufSize]);
    }

    private @safe
    void ensureFilled()
    {
        if (len == 0)
            len = read(fd, buf);
    }

    /// Return true iff the underlying file descriptor has reached the end of the
    /// file. This will fill the buffer if necessary.
    @safe
    bool empty()
    {
        ensureFilled();
        return len == 0;
    }

    /// Return the buffer as filled by empty. The buffer may not be entirely
    /// full, because read(2) does not guarantee that it reads all requested
    /// bytes.
    nothrow pure @nogc @safe
    inout(ubyte)[] front() inout
    {
        return buf[0 .. len];
    }

    /// Discard the buffer, making it ready for filling.
    nothrow pure @nogc @safe
    void popFront()
    {
        len = 0;
    }
}

/// The write(2) subroutine returns the number of bytes it wrote. This may be
/// less than the number of bytes given to it, in case the write was interrupted
/// by a signal. Most of the time, you want to write all bytes. This subroutine
/// automatically retries the write with the remaining bytes.
@safe
void writeAll(int fd, scope const(void)[] b)
{
    while (!b.empty) {
        const n = write(fd, b);
        b = b[n .. $];
    }
}

/// Output range that calls writeAll each time a byte slice is put into it. The
/// output range stores (but does not own) a file descriptor.
struct Writer
{
private:
    int fd;

public:
    @disable this();

    nothrow pure @nogc @safe
    this(int fd)
    {
        this.fd = fd;
    }

    @safe
    void put(scope const(void)[] b) const scope
    {
        write(fd, b);
    }
}
