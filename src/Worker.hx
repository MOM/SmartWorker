/**
 * From html5 package
 */
extern class Worker {
	var onmessage : Dynamic->Void;
	function new( scriptURL : String ) : Void;
	function terminate() : Void;
	function postMessage( message : Dynamic, ?ports : Array<Dynamic> ) : Void;
}
