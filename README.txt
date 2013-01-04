SmartWorker
Josh Jancourtz

Haxe package to use worker thread if available or degrade gracefully if not.
The work it does will be in main app and compiled to standalone worker script.
Only js implemented, but set up to add other implementaitons.
Serialization to/from worker via haxe serialization :)

 To implement:
	1) Make your own SmartWorker subclass (Included example SmartWorkerSubclass extends SmartWorker)
	2) Override doWork method
	3) Add helper methods
	
	Then compile:
	4) Compile app and also external worker script with -D worker (see smartWorker.hxml)
	5) Serve app (for js worker to be available)
	
	
TODO:
	 * Add other implementations beyond js
	 * Explore automating worker script compilation with macros
	 * Automate injection of external worker script back into main app to inline with BlobBuilder if available
	 * Explore using decorator somehow to facilitate usage
	 * If case where work switches from non-worker to worker, enable passing state