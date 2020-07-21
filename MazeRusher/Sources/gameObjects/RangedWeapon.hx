package gameObjects;

import com.framework.utils.Entity;
import com.collision.platformer.CollisionGroup;

class RangedWeapon extends Entity
{
	public var swapparangCollisions:CollisionGroup;

	public function new() 
	{
		super();
		pool=true;
		swapparangCollisions=new CollisionGroup();
    }
    
	public function tossSwapparang(x:Float, y:Float,dirX:Float,dirY:Float):Void
	{
		var swapparang:Swapparang=cast recycle(Swapparang);
		swapparang.toss(x,y,dirX,dirY, swapparangCollisions);
	}
}