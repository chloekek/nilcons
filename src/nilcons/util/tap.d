module nilcons.util.tap;

import core.runtime : UnitTestResult;
import std.stdio : writefln;

/// Extended module unit tester that produces TAP-compatible output.
UnitTestResult extendedModuleUnitTester()
{
    size_t plan = 0;
    foreach (m; ModuleInfo)
        if (m.unitTest !is null)
            ++plan;
    writefln!"1..%d"(plan);

    size_t i = 0;
    foreach (m; ModuleInfo)
        if (m.unitTest !is null)
            runUnitTest(++i, m.name, m.unitTest);

    return UnitTestResult();
}

private
void runUnitTest(size_t i, const(char)[] name, void function() func)
{
    try {
        func();
        writefln!"ok %d - %s"(i, name);
    } catch (Throwable ex) {
        writefln!"not ok %d - %s"(i, name);
        diagnoseException(ex);
    }
}

private
void diagnoseException(Throwable ex)
{
    import std.string : splitLines;
    foreach (line; ex.toString.splitLines)
        writefln!"# %s"(line);
}
