package ;

import smartWorker.SmartWorker;
import haxe.Unserializer;

/**
 * ...
 * @author Josh Jancourtz
 */

 /**
 * STEP 1: Create a SmartWorker subclass
 */
class SmartWorkerSubclass extends SmartWorker
{
	/**
	 * Instantiate the subclass 
	 * (Macro solution to get subclass name within static main in SmartWorker?)
	 */
	#if worker
	static function main() 
	{
		new SmartWorkerSubclass(); 
	}
	#end
	
	/**
	 * STEP 2: Override doWork method
	 * @param	data_
	 */
	
	override function doWork(dataObj:Dynamic):Void
	{
		var cmd:String = Reflect.getProperty(dataObj, "cmd");
		
		switch (cmd)
		{
			case "calculate":
				calculate(dataObj);
			case "hello":
				hello(dataObj);
			case "isWorker":
				returnData("isWorker = " + isWorker());
			default:
				echo(dataObj);
		}
	}
	
	/**
	 * STEP 3: Add helper methods
	 * @param	data
	 */
	function calculate(data_:Dynamic):Void
	{
		var churn = churnNumbers(data_.mx);
		
		for (i in 0...100)
		{
			churn = churnNumbers(churn);
		}
		var dataObj = { cmd: "showCalc", 
						x: data_.mx, 
						y: data_.my, 
						product: data_.mx * data_.my + churn,
						isWorker: isWorker() };
		returnData( dataObj );
	}
	
	function churnNumbers(input: Float):Float
	{
		var arr = [];
		for (i in 0...10)
		{
			arr.push(Math.round(Math.random() * 10));
		}
		var result = Math.round(input * .0321 + 32 * 10 + 6 + 9823 - 378 + 2 * Math.round(Math.tan(arr[6])));
		return result;
	}
	
	function hello(data_:Dynamic)
	{
		returnData("Hello, " + data_.name);
	}
	
	function isWorker():Bool
	{
		#if worker
		var result:Bool = true;
		#else
		var result:Bool = false;
		#end
		return result;
	}
	
}