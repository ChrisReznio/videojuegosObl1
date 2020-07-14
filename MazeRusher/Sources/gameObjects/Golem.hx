package gameObjects;

import kha.math.FastVector2;
import com.framework.utils.Random;
import com.collision.platformer.Sides;
import com.collision.platformer.CollisionGroup;
import com.collision.platformer.CollisionBox;
import com.collision.platformer.CollisionCircle;
import com.gEngine.display.Sprite;
import com.framework.utils.Entity;
import com.gEngine.display.Layer;
import GlobalGameData.GGD;


class Golem extends Entity
{
	var display:Sprite;
	public var collision:CollisionBox;
    public var direction:FastVector2;
    static inline var MAX_SPEED:Float=240;
    
	public function new(layer:Layer,collisions:CollisionGroup,x:Float,y:Float,dirY:Int) 
	{
		super();
        display = new Sprite("golem");
		display.smooth = false;
		layer.addChild(display);
		
		collision = new CollisionBox();
		collisions.add(collision);

		collision.width = 34;
        collision.height = 34;
		display.pivotX = display.width()/2;
		
        display.scaleX = display.scaleY = 1;
        display.offsetX = -5;
        display.offsetY = 5;
		collision.x=x;
		collision.y=y;
		collision.userData = this;

		direction = new FastVector2(0,dirY);
    }
    
	override public function update(dt:Float):Void 
	{
		collision.velocityX=direction.x;
		collision.velocityY=direction.y*MAX_SPEED;
		
		collision.update(dt);
		super.update(dt);
	}
    
	override function render() {
		display.x = collision.x;
		display.y = collision.y;
		display.timeline.frameRate = 1 / 10;
		if (direction.y < 0) { // estoy mirand up o down
            display.timeline.playAnimation("walkFront");
        } 
        else if (direction.y > 0){
            display.timeline.playAnimation("walkBack");
        } 
        else {
            display.timeline.playAnimation("idle");
            display.offsetY = -15;
            display.timeline.frameRate = 1 / 2;
        }
    }
    
    public function invertDirection() {
        direction.y = -direction.y;
	}
	
	public function dissapear() {
		collision.removeFromParent();
		display.removeFromParent();
	}
}
