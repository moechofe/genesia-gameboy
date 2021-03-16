import std.algorithm;
import std.conv;
import std.string;
import std.stdio;

void main()
{
	foreach(l;stdin.byLine)
		l.split(',').map!((a){
			ubyte c=a.to!ubyte;
			c+=cast(ubyte)(128);
			return c;
		}).copy(stdout.lockingTextWriter());
}
