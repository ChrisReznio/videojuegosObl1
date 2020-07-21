package gameObjects;

import com.helpers.Rectangle;
import com.gEngine.helper.RectangleDisplay;
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


class Boss extends Entity
{
	var display:Sprite;
	public var collision:CollisionBox;
	var collisionGroup:CollisionGroup;
	var parentLayer:Layer;
    public var direction:FastVector2;
	static inline var MAX_SPEED:Float=100;
    var attackActualCooldown:Float = 2.9;
    var attackCooldown:Float = 3;
    var lives:Int;
    var weapon:BossAttack;
    
	public function new(layer:Layer, y:Float, collisions:CollisionGroup, bossAttackCollision:CollisionGroup, bossSidesCollision:CollisionGroup, actualLives:Int) {
		super();
        parentLayer = layer;
		weapon = new BossAttack(bossAttackCollision, bossSidesCollision);
		lives = actualLives;
        addChild(weapon);
		display = new Sprite("dialga");
		collisionGroup = collisions;
		display.smooth = false;
		layer.addChild(display);

		collision = new CollisionBox();
		collisionGroup.add(collision);

		collision.width = display.width() * 0.6;
		collision.height = display.height() * 0.4;
		display.pivotX = display.width() / 2;

		display.scaleX = display.scaleY = 1;
		display.offsetX = -collision.width * 0.35;
		display.offsetY = -collision.height * 0.8;
		collision.x = 244;
		collision.y = y;

		collision.userData = this;

		direction = new FastVector2(0, 0);
	}

	override public function update(dt:Float):Void {
		display.resetColorTransform();
		weapon.updateLasers(collision.y);

		if (isAttacking()) {
			return;
		}
		if(attackActualCooldown == 3){
			attack();
		}
        if(attackActualCooldown > 0){
            attackActualCooldown -= dt;
        }
        else{
			startAttackAnimation();
            attackActualCooldown=attackCooldown;
        }

		var target:William = GGD.player;

		direction = new FastVector2(0, target.collision.y - (collision.y));

		direction.setFrom(direction.normalized());
		direction.setFrom(direction.mult(MAX_SPEED));
		collision.velocityX = 0;
		collision.velocityY = 0;

		collision.update(dt);
		super.update(dt);
    }
    
	override function render() {
		display.x = collision.x;
		display.y = collision.y;
		if (isAttacking()) {
			return;
		}

		if (display.timeline.isComplete()
			&& (display.timeline.currentAnimation == "damagedFront"
                || display.timeline.currentAnimation == "damagedBack")
            && (lives == 0)) {
			parentLayer.remove(display);
		}

		if (notWalking()) {
			if (direction.y > 0) {
				display.timeline.playAnimation("idleBack");
			} else {
				display.timeline.playAnimation("idleFront");
			}
		}

		display.timeline.frameRate = 1 / 16;
	}

    inline function notWalking(){
		return collision.velocityY==0;
    }
    
    inline function startAttackAnimation(){
		if (direction.y > 0) {
			display.timeline.playAnimation("attackBack");
			display.timeline.loop = false;
		} else {
			display.timeline.playAnimation("attackFront");
			display.timeline.loop = false;
        }
	}

	inline function attack(){
		weapon.play(collision.x, collision.y, direction.y);
	}
	
	public function takeDamage() {
		display.colorMultiplication(80,1,1);
        lives--;
        if(lives == 0){
			dissapear();
			GGD.bossDefeated = true;
        }
	}

	public function getActualLives(){
		return lives;
	}

	public function dissapear() {
		collision.removeFromParent();
		display.removeFromParent();
		weapon.deleteLasers();
	}

	inline function isAttacking(){
		if((!display.timeline.isComplete()) && (display.timeline.currentAnimation == "attackFront" 
            || display.timeline.currentAnimation == "attackBack")){
            return true;
		}
		else{
			return false;
		}
	}
}
