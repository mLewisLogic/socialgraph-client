package graph.flare
{
	import flare.physics.Simulation;
	import flare.vis.data.EdgeSprite;
	import flare.vis.operator.layout.ForceDirectedLayout;

	public class RelationshipForceDirectedLayout extends ForceDirectedLayout
	{
		public function RelationshipForceDirectedLayout()
		{
			super(true, 10, new Simulation(0, 0, 0.3, -5));
			defaultParticleMass = 3;
			
			restLength = function(e:EdgeSprite):Number {
				return (Math.pow((1-e.data.weight), 2) * 1000) + 100;
			}
			
			tension = function(e:EdgeSprite):Number {
				return Math.pow(e.data.weight, 6);
			}
			
			damping = function(e:EdgeSprite):Number {
				return .03;
			}
		}
	}
}