
package graph
{
	//import com.adobe.protocols.dict.DictionaryServer;
	import com.adobe.serialization.json.JSON;
	
	import flare.display.TextSprite;
	import flare.scale.ScaleType;
	import flare.vis.Visualization;
	import flare.vis.controls.DragControl;
	import flare.vis.data.Data;
	import flare.vis.data.EdgeSprite;
	import flare.vis.data.NodeSprite;
	import flare.vis.operator.encoder.*;
	import flare.vis.operator.label.Labeler;
	import flare.vis.operator.layout.ForceDirectedLayout;
	
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.external.ExternalInterface;
	import flash.geom.Rectangle;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import flash.text.TextFormat;
	import flash.utils.Dictionary;
	
	import graph.flare.RelationshipForceDirectedLayout;
	import graph.model.DataLoader;
	
	[SWF(width="800",height="600",backgroundColor="#ffffff", frameRate="30")]
	public class Graph extends Sprite
	{
		private var vis:Visualization;
		private var data:Data = new Data();
		private var users:Dictionary = new Dictionary();
		private var edges:Array;
		
		public function Graph()
		{
			visualize();
			loadAll('Familiarity');
		}
		
		private function loadAll(name:String):void
		{
			var loader:URLLoader = new URLLoader();
			var request:URLRequest = new URLRequest();
			request.url = 'http://localhost:5000/data/all/'+name;
			loader.addEventListener(Event.COMPLETE,
				function(event:Event):void {
					var loader:URLLoader = URLLoader(event.target);
					processAll(JSON.decode(loader.data));
				}
			);
			loader.load(request);
		}
		
		private function processAll(all_data:Object):void
		{
			processUsers(all_data.users);
			processConnections(all_data.connections);
		}
		
		private function loadUsers():void
		{
			var loader:URLLoader = new URLLoader();
			var request:URLRequest = new URLRequest();
			request.url = 'http://localhost:5000/data/users';
			loader.addEventListener(Event.COMPLETE,
				function(event:Event):void {
					var loader:URLLoader = URLLoader(event.target);
					processUsers(JSON.decode(loader.data));
				}
			);
			loader.load(request);
		}
		
		private function processUsers(user_array:Array):void
		{
			for each(var user:Object in user_array)
			{
				users[user._id] = data.addNode(user);
			}
			if (edges)
			{
				processConnections(edges);
			}
			
			vis.data.nodes.visit(function(n:NodeSprite):void {
				n.fillColor = 0xaa0000; n.fillAlpha = 0.9;
				n.lineColor = 0x0000dd; n.lineAlpha = 0.7;
				n.lineWidth = 2;
				n.size = 5;
				n.buttonMode = true;
			});
			loadConnections('Familiarity');
		}
		
		private function loadConnections(name:String):void
		{
			var loader:URLLoader = new URLLoader();
			var request:URLRequest = new URLRequest();
			request.url = 'http://localhost:5000/data/connections/'+name;
			loader.addEventListener(Event.COMPLETE,
				                    function(event:Event):void {
				var loader:URLLoader = URLLoader(event.target);
				processConnections(JSON.decode(loader.data));
				}
			);
			loader.load(request);
		}
		
		private function processConnections(connection_array:Array):void
		{
			edges = connection_array;
			data.edges.clear();
			for each(var connection:Object in connection_array)
			{
				data.addEdgeFor(users[connection.id1],
					            users[connection.id2],
								null,
								connection);
			}
			
			vis.data.edges.visit(function(e:EdgeSprite):void {
				e.lineWidth = Math.pow(e.data.weight, 3) * 30;
				e.lineColor = 0x094D00;
				e.lineAlpha = Math.pow(e.data.weight, 3);
			});
		}
		
		private function visualize():void
		{
			var padding:Number = 40;
			vis = new Visualization(data);
			vis.bounds = new Rectangle(padding,
				                       padding,
									   stage.stageWidth - (2*padding),
									   stage.stageHeight - (2*padding));
			
			vis.operators.add(new RelationshipForceDirectedLayout());
			vis.controls.add(new DragControl(NodeSprite));
			
			vis.operators.add(new Labeler('data.name', null, new TextFormat('Arial', '11', '0x00000000', true), null));
			
			
			vis.continuousUpdates = true;
			vis.update();
			
			addChild(vis);
		}
	}
}
