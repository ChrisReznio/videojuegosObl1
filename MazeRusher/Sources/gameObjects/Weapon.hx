package gameObjects;

import com.framework.utils.Entity;
import com.collision.platformer.CollisionGroup;

class Weapon extends Entity
{
	public var slashCollisions:CollisionGroup;

	public function new() 
	{
		super();
		pool=true;
		slashCollisions=new CollisionGroup();
	}
	public function swingSword(x:Float, y:Float,dirX:Float,dirY:Float):Void
	{
		var slash:Slash=cast recycle(Slash);
		slash.cut(x,y,dirX,dirY,slashCollisions);
	}
}