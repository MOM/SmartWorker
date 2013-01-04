package ;

import haxe.Timer;
import js.JQuery;

/**
 * ...
 * @author Josh Jancourtz
 */

class Main 
{

	static function main() 
	{
		new Main();
	}
	
	var worker:SmartWorkerSubclass;
	
	public function new()
	{
		worker = new SmartWorkerSubclass();
		worker.setCallbacks(onmessage, onWorkerComplete);
		
		// To observe when worker becomes available
		for (i in 0...10)
		{
			Timer.delay(function() { worker.postMessage( { cmd: "isWorker" } ); }, i * 20);		
		}
	}
	
	/* You may start sending messages right away without waiting for onComplete. The non-Worker class within the app will just handle the work and when the Worker is ready it will take over. This could be a problem, however, if the worker's state is significant because the internal and external worker won't share state unless you implement a way to do so. One option would be to transfer state from the internal worker to the external worker when it becomes available, e.g.: 
		 * onComplete() { worker.postMessage( { cmd: "setState", stateObj: {...} }); }
	Or just wait for onComplete to begin posting messages.
	*/
	function onWorkerComplete():Void
	{
		trace("Main heard worker complete.");
		sendSomeMessages();
		// Are we sending to internal or external Worker? Doesn't really matter as the work will get done--and that's the idea here! But if you like you can check worker.usingWorker()
	}
	
	function sendSomeMessages():Void
	{
		worker.postMessage( { cmd: "hello", name: "world" } );

		new JQuery("body").mousemove(function(e) {
			worker.postMessage( { cmd: "calculate", mx: e.pageX, my: e.pageY } );
		});
	}
	
	function onmessage(data_:Dynamic):Void
	{
		switch (data_.cmd)
		{
			case "showCalc":
				showCalc(data_);
			default:
				trace("Main heard data = " + data_);
		}
	}
	
	function showCalc(data_):Void
	{
		new JQuery("#output").html(data_.x + ", " + data_.y + " => " + data_.product + ", isWorker = " + data_.isWorker);
	}
	
}