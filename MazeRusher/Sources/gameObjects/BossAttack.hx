package gameObjects;

import com.gEngine.display.Sprite;
import com.collision.platformer.CollisionBox;
import com.gEngine.helper.RectangleDisplay;
import com.framework.utils.Entity;
import com.collision.platformer.CollisionGroup;
import GlobalGameData;


class BossAttack extends Entity
{
	public var bossAttackCollisions:CollisionGroup;
	var leftLaserCollision:CollisionBox;
	var rightLaserCollision:CollisionBox;

	public function new(aCollision:CollisionGroup, sidesCollision:CollisionGroup) 
	{
		super();
		pool=true;
		bossAttackCollisions=aCollision;

		leftLaserCollision = new CollisionBox();
		leftLaserCollision.x = 0;
		leftLaserCollision.width = 230;
		leftLaserCollision.height = 30;
		rightLaserCollision = new CollisionBox();
		rightLaserCollision.x = 286;
		rightLaserCollision.width = 230;
		rightLaserCollision.height = 30;
		sidesCollision.add(leftLaserCollision);
		sidesCollision.add(rightLaserCollision);
	}
	
	public function updateLasers(y:Float){
		leftLaserCollision.y = y;
		rightLaserCollision.y = y;
	}

	public function deleteLasers(){
		leftLaserCollision.removeFromParent();
		rightLaserCollision.removeFromParent();
	}
    
	public function play(x:Float, y:Float,dirY:Float):Void
	{
		var roarOfTime:BossBullet=cast recycle(BossBullet);
		roarOfTime.roar(x,y,dirY, bossAttackCollisions);
	}
}