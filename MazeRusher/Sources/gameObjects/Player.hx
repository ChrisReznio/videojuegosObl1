package gameObjects;

import com.gEngine.GEngine;
import kha.math.FastVector2;
import com.framework.Simulation;
import com.gEngine.display.Layer;
import kha.input.KeyCode;
import com.framework.utils.Input;
import com.collision.platformer.CollisionBox;
import com.gEngine.display.Sprite;
import com.framework.utils.Entity;

class Player extends Entity {
	static private inline var SPEED:Float = 300;

	public var sword:Sword;

	var display:Sprite;

	var screenWidth:Int; 
    var screenHeight:Int; 

	public var direction:FastVector2;
	public var collision:CollisionBox;
	public var x(get, null):Float;
	public var y(get, null):Float;
	public var width(get, null):Float;
	public var height(get, null):Float;

	public function new(X:Float, Y:Float, layer:Layer) {
		super();
		direction = new FastVector2(0,-1);
		display = new Sprite("samus");
		display.timeline.playAnimation("samusShooting");
		display.timeline.frameRate = 1 / 14;
		display.offsetX = -10;
		display.offsetY = -10;

		collision = new CollisionBox();
		collision.width = 24;
		collision.height = 76;

		collision.x = X;
		collision.y = Y;

		layer.addChild(display);

		sword = new Sword();
		addChild(sword);
		display.smooth = false;

		screenWidth = GEngine.i.width;
        screenHeight = GEngine.i.height;
	}

	override function update(dt:Float):Void {
		collision.velocityX = 0;
		collision.velocityY = 0;
			if (Input.i.isKeyCodeDown(KeyCode.Left)) {
				if(collision.x <= 0){
					collision.x = 0;
				}
				else{
					collision.velocityX = -SPEED;
				}
			}
			if (Input.i.isKeyCodeDown(KeyCode.Right)) {
				if(collision.x >= screenWidth - collision.width){
					collision.x = screenWidth - collision.width;
				}
				else{
					collision.velocityX = SPEED;
				}
			}
			if (Input.i.isKeyCodeDown(KeyCode.Down)) {
				if(collision.y >= screenHeight - collision.height){
					collision.y = screenHeight - collision.height;
				}
				else{
					collision.velocityY = SPEED;
				}
			}
			if (Input.i.isKeyCodeDown(KeyCode.Up)) {
				if(collision.y <= collision.height){
					collision.y = collision.height;
				}
				else{
					collision.velocityY = -SPEED;
				}
			}
		collision.update(dt);
		super.update(dt);
	}

	 public function get_x():Float{
		 return collision.x+collision.width*0.5;
	 }
	 public function get_y():Float{
		 return collision.y+collision.height;
	 }
	 public function get_width():Float{
		 return collision.width;
	 }
	 public function get_height():Float{
		 return collision.height;
	 }
	 
	override function render() {
		display.x = collision.x;
		display.y = collision.y;
			if (!notWalking()) {
				if (collision.velocityX > 0) {
					display.scaleX = 1;
					display.offsetX = -22;
				} else {
					display.scaleX = -1;
					display.offsetX = -44;
				}
				display.timeline.playAnimation("samusRunning_");
			} else {
				if(display.scaleX == 1){
					display.offsetX = -10;
				}else{
					display.offsetX = -30;
				}
				display.timeline.playAnimation("samusShooting");
			}
			super.render();
	}

	 inline function notWalking(){
		 return collision.velocityX==0;
	 }
	 
 }