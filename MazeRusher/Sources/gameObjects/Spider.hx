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


class Spider extends Entity
{
	var display:Sprite;
	public var collision:CollisionBox;
	var collisionGroup:CollisionGroup;
	var parentLayer:Layer;
    public var direction:FastVector2;
	static inline var MAX_SPEED:Float=170;
	var stunned = false;
    var stunnedTime:Float = 0;
    
	public function new(layer:Layer,collisions:CollisionGroup,x:Float,y:Float) 
	{
		super();
		parentLayer = layer;
        display = new Sprite("joltik");
        collisionGroup = collisions;
		display.smooth = false;
		layer.addChild(display);
		
		collision = new CollisionBox();
		collisionGroup.add(collision);

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
        if((!display.timeline.isComplete()) && (display.timeline.currentAnimation == "attackFront" 
            || display.timeline.currentAnimation == "attackBack" || display.timeline.currentAnimation == "attackSide")){
            return;
		}
		
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
        
		if(Math.abs(direction.x)>0){
			if(Math.abs(direction.x)>Math.abs(direction.y)){
				direction.y=0;
			}else if(Math.abs(direction.y)>0){
				direction.x=0;
            }
        }
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
        if(isAttacking() || isTakingDamage()){
            return;
		}

		if(display.timeline.isComplete() && (display.timeline.currentAnimation == "damagedFront" 
            || display.timeline.currentAnimation == "damagedBack" || display.timeline.currentAnimation == "damagedSide")){
			parentLayer.remove(display);
		}

		if(notWalking()){
			if(direction.x==0){ //estoy mirand up o down
				if(direction.y>0){
					display.timeline.playAnimation("idleBack");
				}else{
					display.timeline.playAnimation("idleFront");
				}
			}else{
				display.timeline.playAnimation("idleSide");
				if(direction.x>0){
					display.scaleX=-1;
				}else{
					display.scaleX=1;
				}
			}
		}else{
			if(direction.x==0){ //estoy mirand up o down
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

    inline function notWalking(){
		return collision.velocityX==0 &&collision.velocityY==0;
    }
    
    public function attack(){
        if(direction.x==0){ //estoy mirand up o down
            if(direction.y>0){
                display.timeline.playAnimation("attackBack");
                display.timeline.loop = false;
            }else{
                display.timeline.playAnimation("attackFront");
                display.timeline.loop = false;
            }
        }else{
            display.timeline.playAnimation("attackSide");
            display.timeline.loop = false;
            if(direction.x>0){
                display.scaleX=-1;
            }else{
                display.scaleX=1;
            }
        }
        collision.velocityX = 0;
        collision.velocityY = 0;
	}
	
	public function takeDamage() {
		if (direction.x == 0) { // estoy mirand up o down
			if (direction.y > 0) {
				display.timeline.playAnimation("damagedBack", false);
			} else {
				display.timeline.playAnimation("damagedFront", false);
			}
		} else {
			display.timeline.playAnimation("damagedSide", false);
			if (direction.x > 0) {
				display.scaleX = -1;
			} else {
				display.scaleX = 1;
			}
		}
		collision.removeFromParent();
	}

	inline function isAttacking(){
		if((!display.timeline.isComplete()) && (display.timeline.currentAnimation == "attackFront" 
            || display.timeline.currentAnimation == "attackBack" || display.timeline.currentAnimation == "attackSide")){
            return true;
		}
		else{
			return false;
		}
	}

	inline function isTakingDamage(){
		if((!display.timeline.isComplete()) && (display.timeline.currentAnimation == "damagedFront" 
            || display.timeline.currentAnimation == "damagedBack" || display.timeline.currentAnimation == "damagedSide")){
            return true;
		}
		else{
			return false;
		}
	}
}
