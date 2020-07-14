package gameObjects;

import com.collision.platformer.CollisionGroup;
import GlobalGameData.GGD;
import com.gEngine.helper.RectangleDisplay;
import com.collision.platformer.CollisionBox;
import com.framework.utils.Entity;
import com.gEngine.display.Sprite;

class Bagpipe extends Entity
{
	public var collision:CollisionBox;
	var display:Sprite;
	var lifeTime:Float=0;
	var totalLifeTime:Float=1.4;

	public function new() 
	{
        super();
        display = new Sprite("song");
		display.scaleX = display.scaleY = 1;
		collision=new CollisionBox();
		collision.width = display.width();
		collision.height = display.height();
        collision.userData=this;
        display.timeline.frameRate = 1/8;
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
		super.update(dt);
	}
	public function play(x:Float, y:Float,dirX:Float,dirY:Float,songCollision:CollisionGroup):Void
	{
        lifeTime = 0;
        if(dirY > 0 || dirY < 0){
            setVerticalCollision(x,y,dirY);
        }else{
            setHorizontalCollision(x,y,dirX);
        }
		songCollision.add(collision);
		GGD.simulationLayer.addChild(display);
		display.timeline.playAnimation("play",false);
    }

    inline function setVerticalCollision(a:Float, b:Float, dir:Float){
        collision.width = 188;
        collision.height = 12;
        collision.x = a - collision.width/2;
        collision.y = b;
        collision.velocityX = 0;
        collision.velocityY = 200 * dir;
        display.rotation = Math.PI/2;
        display.offsetX = collision.width;
    }

    inline function setHorizontalCollision(a:Float, b:Float, dir:Float){
        collision.width = 12;
        collision.height = 188;
        collision.x = a;
        collision.y = b - collision.height/2;
        collision.velocityX = 200 * dir;
        collision.velocityY = 0;
        display.rotation = 0;
        display.offsetX = 0;
    }
}