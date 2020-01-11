module nilcons.api.implementation;

import nilcons.api.interface_;

import std.typecons : Tuple, tuple;
import std.uuid : UUID;

final
class Implementation
    : Service
{
    override @safe
    Tuple!() addItemTally(const(AddItemTally[UUID]) input)
    {
        delegate()@trusted{import std.stdio;stderr.writeln(input);}();
        return tuple!();
    }

    override @safe
    Tuple!() setItemDone(const(SetItemDone[UUID]) input)
    {
        delegate()@trusted{import std.stdio;stderr.writeln(input);}();
        return tuple!();
    }

    override @safe
    Tuple!() setItemText(const(SetItemText[UUID]) input)
    {
        delegate()@trusted{import std.stdio;stderr.writeln(input);}();
        return tuple!();
    }
}
