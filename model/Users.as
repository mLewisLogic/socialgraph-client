package graph.model
{
	import graph.model.DataLoader;
	
	public class Users extends DataLoader
	{
		public function load():void
		{
			requestData('http://localhost:5000/data/users');
		}
	}
}