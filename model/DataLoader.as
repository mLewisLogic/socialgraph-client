package graph.model
{
	import com.adobe.serialization.json.JSON;
	
	import flare.data.DataSet;
	import flare.data.DataSource;
	
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import flash.utils.Dictionary;
	
	public class DataLoader extends EventDispatcher
	{
		public static var DATA_RECEIVED:String = 'Data received';
		
		private static var urlBase:String = 'http://localhost:5000/data/';
		
		private var loader:URLLoader = new URLLoader();
		private var request:URLRequest = new URLRequest();
		
		private var data:Dictionary;
		
		public function DataLoader(dataType:String)
		{
			request.url = urlBase + dataType;
		}
		
		public function load():void
		{
			loader.load(request);
			loader.addEventListener(Event.COMPLETE,
				                    function(event:Event):void {
										saveData(loader.data);
										dispatchEvent(new Event(DataLoader.DATA_RECEIVED));
									});
		}
		
		private function saveData(json:String):void
		{
			var list:Array = JSON.decode(json);
			
			data = new Dictionary();
			for each(var element:Object in list)
			{
				data[element.id] = element;
			}
		}
		
		public function getData():Dictionary
		{
			return data;
		}
	}
}
	