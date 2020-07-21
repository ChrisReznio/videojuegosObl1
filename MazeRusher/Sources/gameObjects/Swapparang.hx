package gameObjects;

import com.collision.platformer.CollisionGroup;
import GlobalGameData.GGD;
import com.gEngine.helper.RectangleDisplay;
import com.collision.platformer.CollisionBox;
import com.framework.utils.Entity;
import com.gEngine.display.Sprite;

class Swapparang extends Entity
{
	public var collision:CollisionBox;
	var display:Sprite;
	var lifeTime:Float=0;
	var totalLifeTime:Float=0.8;

	public function new() 
	{
        super();
        display = new Sprite("boomerang");
		display.scaleX = display.scaleY = 0.5;
		collision=new CollisionBox();
		collision.width = display.width()/32;
		collision.height = display.height()/32;
		display.offsetX = -15;
		display.offsetY = -15;
		collision.userData=this;
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
		display.x=collision.x;
		display.y=collision.y;
		display.pivotX = display.width()*0.5;
		display.pivotY = display.height()*0.5;
		display.rotation += Math.PI/10;
		
		super.update(dt);
	}
	public function toss(x:Float, y:Float,dirX:Float,dirY:Float,boomerangCollision:CollisionGroup):Void
	{
		lifeTime=0;
		collision.x=x;
		collision.y=y;
		collision.velocityX = 400 * dirX;
		collision.velocityY = 400 * dirY;
		boomerangCollision.add(collision);
		GGD.simulationLayer.addChild(display);
		display.timeline.playAnimation("attack",false);
	}
}