package gameObjects;

import com.soundLib.SoundManager;
import kha.graphics4.PipelineStateBase;
import kha.Scheduler.TimeTask;
import js.html.TimeElement;
import com.framework.utils.LERP;
import com.gEngine.display.Layer;
import com.collision.platformer.CollisionBox;
import com.gEngine.display.Sprite;
import com.framework.utils.Entity;
import kha.math.FastVector2;
import com.framework.utils.Input;
import kha.input.KeyCode;
import GlobalGameData;

class William extends Entity {
	public var display:Sprite;
	public var collision:CollisionBox;
	public var direction:FastVector2;
	var maxSpeed = 140;
	public var weapon:Weapon;
	public var rangedWeapon:RangedWeapon;
	public var instrument:Instrument;
	public var isSlashing:Bool=false;
	public var takingDmg:Bool = false;
	public var timeTakingDmg:Float = 0;
	public var lastOrientationWasVertical:Bool = true;

	public function new(x:Float,y:Float,layer:Layer) {
		super();

		direction = new FastVector2(0,1);

		display = new Sprite("william");
		display.scaleX = display.scaleY = 1;
		display.smooth = false;
		display.timeline.frameRate = 1/10;
		layer.addChild(display);

		collision = new CollisionBox();
		collision.width = display.width()*0.5;
		collision.height = display.height()*0.6;
		display.pivotX = display.width()/2;
		collision.x=x;
		collision.y=y;
		collision.userData = this;
		
		display.offsetX = -collision.width*0.5;
		display.offsetY = -collision.height*0.6;

		createWeapons();
	}

	override function update(dt:Float) {
		super.update(dt);

		updateWeaponCooldowns(dt);

		collision.velocityX=0;
		collision.velocityY=0;

		updateDamageCooldown(dt);
		
		//player movement
		if(isSlashing){
			return;
		}
		else{
			if(Input.i.isKeyCodePressed(KeyCode.Left)){
				lastOrientationWasVertical = false;
			}
			if(Input.i.isKeyCodePressed(KeyCode.Right)){
				lastOrientationWasVertical = false;
			}
			if(Input.i.isKeyCodePressed(KeyCode.Up)){
				lastOrientationWasVertical = true;
			}
			if(Input.i.isKeyCodePressed(KeyCode.Down)){
				lastOrientationWasVertical = true;
			}
			if(Input.i.isKeyCodeDown(KeyCode.Left)){
				if(Input.i.isKeyCodeDown(KeyCode.Up) || Input.i.isKeyCodeDown(KeyCode.Down)){
					if(!lastOrientationWasVertical){
						collision.velocityX=-maxSpeed;
						collision.velocityY=0;
					}
				}
				else{
					collision.velocityX=-maxSpeed;
						collision.velocityY=0;
				}
			}
			if(Input.i.isKeyCodeDown(KeyCode.Right)){
				if(Input.i.isKeyCodeDown(KeyCode.Up) || Input.i.isKeyCodeDown(KeyCode.Down)){
					if(!lastOrientationWasVertical){
						collision.velocityX=maxSpeed;
						collision.velocityY=0;
					}
				}
				else{
					collision.velocityX=maxSpeed;
						collision.velocityY=0;
				}
			}
			if(Input.i.isKeyCodeDown(KeyCode.Up)){
				if(Input.i.isKeyCodeDown(KeyCode.Right) || Input.i.isKeyCodeDown(KeyCode.Left)){
					if(lastOrientationWasVertical){
						collision.velocityX=0;
						collision.velocityY=-maxSpeed;
					}
				}
				else{
					collision.velocityX=0;
					collision.velocityY=-maxSpeed;
				}
			}
			if(Input.i.isKeyCodeDown(KeyCode.Down)){
				if(Input.i.isKeyCodeDown(KeyCode.Right) || Input.i.isKeyCodeDown(KeyCode.Left)){
					if(lastOrientationWasVertical){
						collision.velocityX=0;
						collision.velocityY=maxSpeed;
					}
				}
				else{
					collision.velocityX=0;
					collision.velocityY=maxSpeed;
				}
			}
			if(collision.velocityX !=0 || collision.velocityY !=0){
				direction.setFrom(new FastVector2(collision.velocityX,collision.velocityY));
				direction.setFrom(direction.normalized());
			}else{
				if(Math.abs(direction.x)>Math.abs(direction.y)){
					direction.y=0;
				}else{
					direction.x=0;
				}
			}

			//player attacks
			if(Input.i.isKeyCodePressed(KeyCode.Z)){
				slash();
			}
			if(Input.i.isKeyCodePressed(KeyCode.X) && GGD.unlockedBagpipe && GGD.bagpipeCoolDown <= 0){
				playSong();
			}
			if(Input.i.isKeyCodePressed(KeyCode.C) && GGD.unlockedSwapparang && GGD.swapparangCoolDown <= 0){
				tossSwapparang();
			}
		}
		collision.update(dt);
	}

	override function render() {
		display.x = collision.x;
		display.y = collision.y;
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
	}	

	function createWeapons(){
		weapon=new Weapon();
		rangedWeapon=new RangedWeapon();
		instrument = new Instrument();
		addChild(weapon);
		addChild(rangedWeapon);
		addChild(instrument);
	}

	function updateWeaponCooldowns(dt:Float){
		if(GGD.bagpipeCoolDown > 0){
			GGD.bagpipeCoolDown -= dt;
		}
		if(GGD.swapparangCoolDown > 0){
			GGD.swapparangCoolDown -= dt;
		}
	}

	function updateDamageCooldown(dt:Float){
		if(timeTakingDmg >= 1){
			timeTakingDmg = 0;
			takingDmg = false;
		}
		if(takingDmg){
			timeTakingDmg += dt;
		}
	}

	function slash(){
		isSlashing = true;
		SoundManager.playFx("slashSoundEffect");
		SoundManager.musicVolume(0.4);
		weapon.swingSword(collision.x, collision.y, direction.x, direction.y);
	}

	function tossSwapparang(){
		GGD.swapparangCoolDown = 2;
		SoundManager.playFx("boomerangSoundEffect");
		SoundManager.musicVolume(0.4);
		rangedWeapon.tossSwapparang(collision.x + 8, collision.y + 6, direction.x, direction.y);
	}

	function playSong(){
		GGD.bagpipeCoolDown = 18;
		SoundManager.playFx("bagpipeSoundEffect");
		SoundManager.musicVolume(0.4);
		instrument.play(collision.x, collision.y, direction.x, direction.y);
	}

	public function takeDamage(){
		if(!takingDmg){
			SoundManager.playFx("playerDamageSoundEffect");
			SoundManager.musicVolume(0.4);
			takingDmg = true;
			GGD.lives--;
		}
	}

	inline function notWalking(){
		return collision.velocityX==0 &&collision.velocityY==0;
	}
}
