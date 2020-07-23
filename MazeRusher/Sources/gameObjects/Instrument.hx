package gameObjects;

import com.framework.utils.Entity;
import com.collision.platformer.CollisionGroup;

class Instrument extends Entity
{
	public var instrumentCollisions:CollisionGroup;

	public function new() 
	{
		super();
		pool=true;
		instrumentCollisions=new CollisionGroup();
    }
    
	public function play(x:Float, y:Float,dirX:Float,dirY:Float):Void
	{
		var bagpipe:Bagpipe=cast recycle(Bagpipe);
		bagpipe.play(x,y,dirX,dirY, instrumentCollisions);
	}
}