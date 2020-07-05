package states;

import com.loading.basicResources.FontLoader;
import com.collision.platformer.ICollider;
import com.collision.platformer.CollisionBox;
import com.collision.platformer.CollisionGroup;
import com.loading.basicResources.ImageLoader;
import format.tmx.Data.TmxObjectType;
import com.gEngine.display.Sprite;
import com.gEngine.shaders.ShRetro;
import com.gEngine.display.Blend;
import com.gEngine.shaders.ShRgbSplit;
import com.gEngine.display.Camera;
import kha.Assets;
import helpers.Tray;
import com.gEngine.display.extra.TileMapDisplay;
import com.collision.platformer.Sides;
import com.framework.utils.XboxJoystick;
import com.framework.utils.VirtualGamepad;
import format.tmx.Data.TmxObject;
import kha.input.KeyCode;
import com.framework.utils.Input;
import com.collision.platformer.CollisionEngine;
import gameObjects.ChivitoBoy;
import com.loading.basicResources.TilesheetLoader;
import com.loading.basicResources.SpriteSheetLoader;
import com.gEngine.display.Layer;
import com.loading.basicResources.DataLoader;
import com.collision.platformer.Tilemap;
import com.loading.basicResources.JoinAtlas;
import com.loading.Resources;
import com.framework.utils.State;
import cinematic.Dialog;

class GameState extends State {
	var worldMap:Tilemap;
	var chivito:ChivitoBoy;
	var simulationLayer:Layer;
	var touchJoystick:VirtualGamepad;
	var tray:helpers.Tray;
	var dialogCollision:CollisionGroup;


	public function new(room:String, fromRoom:String = null) {
		super();
	}

	override function load(resources:Resources) {
		resources.add(new DataLoader(Assets.blobs.finalRoom_tmxName));
		var atlas = new JoinAtlas(2048, 2048);

		atlas.add(new TilesheetLoader("tiles2", 32, 32, 0));
		atlas.add(new ImageLoader("salt"));
		atlas.add(new SpriteSheetLoader("hero", 45, 60, 0, [
			new Sequence("fall", [0]),
			new Sequence("slide", [0]),
			new Sequence("jump", [1]),
			new Sequence("run", [2, 3, 4, 5, 6, 7, 8, 9]),
			new Sequence("idle", [10]),
			new Sequence("wallGrab", [11])
		]));
		atlas.add(new FontLoader("Kenney_Pixel",24));
		resources.add(atlas);
	}

	override function init() {
		stageColor(0.5, .5, 0.5);
		dialogCollision = new CollisionGroup();
		simulationLayer = new Layer();
		stage.addChild(simulationLayer);

		var mayonnaiseMap:TileMapDisplay;
		worldMap = new Tilemap("testRoom_tmx", 1);
		worldMap.init(function(layerTilemap, tileLayer) {
			if (!tileLayer.properties.exists("noCollision")) {
				layerTilemap.createCollisions(tileLayer);
			}
			simulationLayer.addChild(layerTilemap.createDisplay(tileLayer,new Sprite("tiles2")));
			mayonnaiseMap = layerTilemap.createDisplay(tileLayer,new Sprite("tiles2"));
			simulationLayer.addChild(mayonnaiseMap);
		}, parseMapObjects);
		
		tray = new Tray(mayonnaiseMap);

		stage.defaultCamera().limits(0, 0, worldMap.widthIntTiles * 32 , worldMap.heightInTiles * 32);
		chivito = new ChivitoBoy(250,200,simulationLayer);
		addChild(chivito);

		createTouchJoystick();

		stage.defaultCamera().postProcess=new ShRetro(Blend.blendDefault());
	}

	function createTouchJoystick() {
		touchJoystick = new VirtualGamepad();
		touchJoystick.addKeyButton(XboxJoystick.LEFT_DPAD, KeyCode.Left);
		touchJoystick.addKeyButton(XboxJoystick.RIGHT_DPAD, KeyCode.Right);
		touchJoystick.addKeyButton(XboxJoystick.UP_DPAD, KeyCode.Up);
		touchJoystick.addKeyButton(XboxJoystick.A, KeyCode.Space);
		touchJoystick.addKeyButton(XboxJoystick.X, KeyCode.X);
		touchJoystick.notify(chivito.onAxisChange, chivito.onButtonChange);

		var gamepad = Input.i.getGamepad(0);
		gamepad.notify(chivito.onAxisChange, chivito.onButtonChange);
		
	}

	function parseMapObjects(layerTilemap:Tilemap, object:TmxObject) {
		switch (object.objectType){
			case OTTile(gid):
				var sprite = new Sprite("salt");
				sprite.smooth = false;
				sprite.x = object.x;
				sprite.y = object.y - sprite.height();
				sprite.pivotY=sprite.height();
				sprite.scaleX = object.width/sprite.width();
				sprite.scaleY = object.height/sprite.height();
				sprite.rotation = object.rotation*Math.PI/180;
				simulationLayer.addChild(sprite);
			case OTRectangle:
				if(object.type=="dialog"){
					var text=object.properties.get("text");
					var dialog=new Dialog(text,object.x,object.y,object.width,object.height);
					dialogCollision.add(dialog.collider);
					addChild(dialog);
				}
			default:
		}
	}


	override function update(dt:Float) {
		super.update(dt);
		stage.defaultCamera().scale=2;
	
		CollisionEngine.collide(chivito.collision,worldMap.collision);
		CollisionEngine.overlap(dialogCollision,chivito.collision,dialogVsChivito);
		stage.defaultCamera().setTarget(chivito.collision.x, chivito.collision.y);

        tray.setContactPosition(chivito.collision.x + chivito.collision.width / 2, chivito.collision.y + chivito.collision.height + 1, Sides.BOTTOM);
		tray.setContactPosition(chivito.collision.x + chivito.collision.width + 1, chivito.collision.y + chivito.collision.height / 2, Sides.RIGHT);
		tray.setContactPosition(chivito.collision.x-1, chivito.collision.y+chivito.collision.height/2, Sides.LEFT);

	}
	function dialogVsChivito(dialogCollision:ICollider,chivitoCollision:ICollider) {
		var dialog:Dialog=cast dialogCollision.userData;
		dialog.showText(simulationLayer);
	}
	
	#if DEBUGDRAW
	override function draw(framebuffer:kha.Canvas) {
		super.draw(framebuffer);
		var camera=stage.defaultCamera();
		CollisionEngine.renderDebug(framebuffer,camera);
	}
	#end
	override function destroy() {
		super.destroy();
		touchJoystick.destroy();
	}

}
