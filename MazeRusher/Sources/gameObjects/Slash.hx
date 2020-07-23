package gameObjects;

import com.gEngine.display.Layer;
import com.gEngine.display.Sprite;
import com.collision.platformer.CollisionGroup;
import GlobalGameData.GGD;
import com.gEngine.helper.RectangleDisplay;
import com.collision.platformer.CollisionBox;
import com.framework.utils.Entity;

class Slash extends Entity
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

		display = new Sprite("slash_attack");
		display.smooth = false;
		display.scaleX=0.8;
		display.scaleY=0.8;
		display.timeline.frameRate = 1/15;
	}
	override function limboStart() {
		display.removeFromParent();
		collision.removeFromParent();
	}
	override function update(dt:Float) {
		lifeTime+=dt;
		if(lifeTime>totalLifeTime){
			GGD.player.isSlashing = false;
			die();
		}
		collision.update(dt);
		display.x=collision.x;
		display.y=collision.y;
		
		super.update(dt);
	}
	public function cut(x:Float, y:Float,dirX:Float,dirY:Float,bulletsCollision:CollisionGroup):Void
	{
		collision.x=x;
		collision.y=y;
		if(dirY > 0){
			collision.width=36*0.8;
			collision.height=24;
			collision.x-=6;
			collision.y+=16;
			display.offsetY=26;
			display.offsetX=29;
			display.rotation = -Math.PI;
		}
		else if(dirY<0){
			collision.width=36*0.8;
			collision.height=24;
			collision.x-=6;
			collision.y-=22;
			display.offsetY=-2;
			display.offsetX= 0;
			display.rotation = 0;
		}
		else if(dirX < 0){
			collision.height=36*0.8;
			collision.width=24;
			collision.y-=5;
			collision.x-=20;
			display.offsetY=29;
			display.offsetX=-2;
			display.rotation = -Math.PI/2;
		}
		else{
			collision.height=36*0.8;
			collision.width=24;
			collision.y-=5;
			collision.x+=12;
			display.offsetY=0;
			display.offsetX=26;
			display.rotation = Math.PI/2;
		}
		lifeTime=0;
		collision.velocityX = 1 * dirX;
		collision.velocityY = 1 * dirY;
		bulletsCollision.add(collision);
		GGD.simulationLayer.addChild(display);
		display.timeline.playAnimation("attack",false);
	}
}