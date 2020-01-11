/// Operating system facilities are comprehensive and well-documented. On the
/// other hand, Phobos is not, so we avoid it. This module exports wrappers
/// around operating system facilities, with the following properties:
///
/// $(LIST
///     * System calls are automatically retried when they fail with EINTR.
///     * Subroutines are @safe and take slices instead of pointers.
///     * Errors are reported by throwing exceptions.
///     * Names of subroutines remain unaltered.
/// )
module nilcons.util.os;

import std.exception : errnoEnforce;
import std.string : fromStringz, toStringz;

import errno = core.stdc.errno;
import stdlib = core.stdc.stdlib;
import unistd = core.sys.posix.unistd;

/// getenv(3).
nothrow @trusted
immutable(char)[] getenv(scope const(char)[] name)
{
    return stdlib.getenv(name.toStringz).fromStringz.idup;
}

/// read(2).
@trusted
size_t read(int fd, scope ubyte[] buf)
{
retry:
    const ok = unistd.read(fd, buf.ptr, buf.length);
    if (ok == -1 && errno.errno == errno.EINTR) goto retry;
    errnoEnforce(ok != -1, "read");
    return ok;
}

/// write(2).
@trusted
size_t write(int fd, scope const(void)[] buf)
{
retry:
    const ok = unistd.write(fd, buf.ptr, buf.length);
    if (ok == -1 && errno.errno == errno.EINTR) goto retry;
    errnoEnforce(ok != -1, "write");
    return ok;
}
