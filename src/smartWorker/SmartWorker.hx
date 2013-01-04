package smartWorker;

import haxe.Serializer;
import haxe.Unserializer;

#if !worker
import haxe.Http;
#end

/**
 * 
 * @author Josh Jancourtz
 */

class SmartWorker 
{
    #if worker 
	
	/**
	 * External worker that is loaded by the main app
	 */
	static function main() 
	{
		new SmartWorker(); 
	}
	
	function new ()
	{
		var __onmessage = _onmessage;
		untyped __js__("onmessage = __onmessage");
	}
	
	inline function _onmessage(e:Dynamic):Void
	{
		doWork(Unserializer.run(e.data));
	}
	
	function returnData(smartWorkerData:Dynamic):Void
	{
		untyped __js__('postMessage(smartWorkerData)');
	}
	
    #else
	
    var worker:Worker;
	var onmessage_cb:Dynamic->Void;
	var onComplete_cb:Void->Void;
	var useWorker:Bool;
	var workerScriptFileRef:String;
	
	/**
	 * Internal worker class in main app
	 * @param	onmessage_cb_
	 * @param	onComplete_cb_
	 */
	public function new()
	{
		workerScriptFileRef = Type.getClassName(Type.getClass(this));
		useWorker = false;
	}
	
	public function setCallbacks(onmessage_cb_:Dynamic->Void, onComplete_cb_:Void->Void):Void
	{
		onmessage_cb = onmessage_cb_;
		onComplete_cb = onComplete_cb_;
		
		#if force_no_worker
		announceComplete();
		#else
		tryWorker();
		#end
	}
	
	private function usingWorker():Bool 
	{
		return useWorker;
	}
	
	#if js
	
	/**
	 * Check worker available
	 */
	function tryWorker():Void
	{
		try 
		{
			Worker;
		} catch (e:Dynamic) {
			trace("Worker not implemented");
			announceComplete();
			return;
		}
		
		/**
		 * Filename convention for standalone worker script:
			 * Same_dir_as_app/class_or_subclass_name.js
		 */
		var jsFileRef = workerScriptFileRef + ".js";
		var workerScriptRequest = new Http(jsFileRef);
		
		workerScriptRequest.onStatus = function(status:Int)
		{
			if (status == 200)
			{
				createWorker(jsFileRef);
			}
			else
			{
				announceComplete();
			}
		}
		
		workerScriptRequest.onError = function(e:String)
		{
			trace("Error loading Worker script " + jsFileRef + ": " + e);
			announceComplete();
		}
		
		workerScriptRequest.request(false);
	}
	
	function createWorker(jsFileRef_):Void
	{
		worker = new Worker(jsFileRef_);
		worker.onmessage = onmessage;
		useWorker = true;
		announceComplete();
	}
	
	function announceComplete():Void
	{
		onComplete_cb();
	}
	
	#else
	
	function tryWorker():Void 
	{
		trace("SmartWorker not implemented on this platform.");
	}
	
	#end
	
	/**
	 * Serialize data to external worker
	 * or just send data to internal worker
	 * @param	data_
	 */
	public function postMessage(data_:Dynamic):Void
	{
		if (useWorker)
		{
			worker.postMessage(Serializer.run(data_));
		}
		else
		{
			doWork(data_);
		}
	}
	
	inline function onmessage(e:Dynamic):Void
	{
		returnData(e.data);
	}
	
	function returnData(data_:Dynamic):Void
	{
		onmessage_cb(data_);
	}
	
    #end

	/*
	 * Actual "Work"
	 */
	
	function doWork(data_:Dynamic):Void
	{
		echo(data_);
	}
	
	function echo(data_:Dynamic):Void
	{
		#if worker
		returnData("Worker received data: " + data_);
		#else
		returnData("Non-worker received data: " + data_);
		#end
	}
	
}
