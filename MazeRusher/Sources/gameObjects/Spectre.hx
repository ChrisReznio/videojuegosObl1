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


class Spectre extends Entity
{
	var display:Sprite;
	public var collision:CollisionBox;
    public var direction:FastVector2;
    static inline var MAX_SPEED:Float=86;
    var stunned = false;
    var stunnedTime:Float = 0;
    
	public function new(layer:Layer,collisions:CollisionGroup,x:Float,y:Float) 
	{
		super();
        display = new Sprite("darkrai");
		display.smooth = false;
		layer.addChild(display);
		
		collision = new CollisionBox();
		collisions.add(collision);

		collision.width = display.width()*0.6;
        collision.height = display.height()*0.4;
		display.pivotX = display.width()/2;
		
        display.scaleX = display.scaleY = 1;
        display.offsetX = -collision.width*0.35;
        display.offsetY = -collision.height*0.8;
		collision.x=x;
		collision.y=y;
		collision.userData = this;

		direction = new FastVector2(0,0);
    }
    
	override public function update(dt:Float):Void 
	{        
        if (stunned){
            if(stunnedTime < GGD.stunDuration){
                stunnedTime += dt;
                return;
            }else{
                stunned = false;
                stunnedTime = 0;
            }
        }
        var target:William = GGD.player;
        
        direction = new FastVector2(target.collision.x-(collision.x),target.collision.y-(collision.y));
        
		direction.setFrom(direction.normalized());
		direction.setFrom(direction.mult(MAX_SPEED));
		collision.velocityX=direction.x;
		collision.velocityY=direction.y;
		
		collision.update(dt);
		super.update(dt);
    }
    
    public function stun(){
        stunned = true;
    }
    
	override function render() {
		display.x = collision.x;
		display.y = collision.y;

        if(Math.abs(direction.x) > 20 && Math.abs(direction.y) > 20){
            if(direction.x > 0){
                if(direction.y > 0){
                    display.timeline.playAnimation("walkDiagonalBack");
                }else{
                    display.timeline.playAnimation("walkDiagonalFront");
                }
                display.scaleX=-1;
            }else{
                if(direction.y > 0){
                    display.timeline.playAnimation("walkDiagonalBack");
                }else{
                    display.timeline.playAnimation("walkDiagonalFront");
                }
                display.scaleX=1;
            }
        }else{
            if(Math.abs(direction.x) <= 20){ //estoy mirand up o down
                if(direction.y>0){
                    display.timeline.playAnimation("walkBack");
                }else{
                    display.timeline.playAnimation("walkFront");
                }
            }else{
                display.timeline.playAnimation("walkSide");
                if(direction.x>0){
                    display.scaleX=-1;
                }else{
                    display.scaleX=1;
                }
            }
        }
		
		display.timeline.frameRate = 1/10;
	}	
}
