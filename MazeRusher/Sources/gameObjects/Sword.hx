package gameObjects;

import com.framework.utils.Entity;
import com.collision.platformer.CollisionGroup;

/**
 * ...
 * @author 
 */
class Sword extends Entity
{
	public var bulletsCollisions:CollisionGroup;
	public function new() 
	{
		super();
		pool=true;
		bulletsCollisions=new CollisionGroup();
	}	
}