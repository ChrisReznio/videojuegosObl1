package gameObjects;

import com.gEngine.display.IDraw;
import com.gEngine.display.Layer;
import com.gEngine.display.Sprite;
import com.collision.platformer.CollisionGroup;
import GlobalGameData.GGD;
import com.gEngine.helper.RectangleDisplay;
import com.collision.platformer.CollisionBox;
import com.framework.utils.Entity;

class BossBullet extends Entity
{
	public var collision:CollisionBox;
	var display:Sprite;
	var lifeTime:Float=0;
	var totalLifeTime:Float=0.4;

	public function new() 
	{
		super();
		collision=new CollisionBox();
		collision.userData=this;

		display = new Sprite("roarOfTime");
        display.smooth = false;
        display.pivotY = 500;
		display.timeline.frameRate = 1/5;
	}
	override function limboStart() {
		display.removeFromParent();
		collision.removeFromParent();
	}
	override function update(dt:Float) {
		lifeTime+=dt;
		if(lifeTime>totalLifeTime){
			die();
		}
        collision.update(dt);
        collision.width = display.width();
        collision.height = display.height();
		display.x=collision.x;
        display.y=collision.y;
		
		super.update(dt);
	}
	public function roar(x:Float, y:Float,dirY:Float,bossBulletCollision:CollisionGroup):Void
	{
		collision.x=145;
        collision.y=y;
		if(dirY > 0){
            collision.y+=16;
		}
		else{
            collision.y-=510;
        }
        GGD.attackLayer.addChild(display);
        lifeTime=0;
		collision.velocityX = 0;
		collision.velocityY = 1 * dirY;
		bossBulletCollision.add(collision);
		display.timeline.playAnimation("attack",false);
    }
}