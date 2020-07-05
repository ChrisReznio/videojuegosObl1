package states;

import com.loading.basicResources.FontLoader;
import com.collision.platformer.ICollider;
import com.collision.platformer.CollisionBox;
import com.collision.platformer.CollisionGroup;
import com.loading.basicResources.ImageLoader;
import com.loading.basicResources.SparrowLoader;
import format.tmx.Data.TmxObjectType;
import com.gEngine.display.Sprite;
import com.gEngine.shaders.ShRetro;
import com.gEngine.display.Blend;
import com.gEngine.shaders.ShRgbSplit;
import com.gEngine.display.Camera;
import kha.Assets;
import com.gEngine.display.extra.TileMapDisplay;
import com.collision.platformer.Sides;
import com.framework.utils.XboxJoystick;
import com.framework.utils.VirtualGamepad;
import format.tmx.Data.TmxObject;
import kha.input.KeyCode;
import com.framework.utils.Input;
import com.collision.platformer.CollisionEngine;
import gameObjects.Player;
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
	var william:Player;
	var simulationLayer:Layer;
	var touchJoystick:VirtualGamepad;
	var dialogCollision:CollisionGroup;


	public function new(room:String, fromRoom:String = null) {
		super();
	}

	override function load(resources:Resources) {
		resources.add(new DataLoader(Assets.blobs.finalRoom_tmxName));
		var atlas = new JoinAtlas(2048, 2048);
		atlas.add(new SparrowLoader("samus", "samus_xml"));
		atlas.add(new TilesheetLoader("tile_dungeon_1", 16, 16, 0));
		atlas.add(new TilesheetLoader("tile_indoors_1", 16, 16, 0));
		atlas.add(new TilesheetLoader("tile_red_crystal", 16, 16, 0));
		atlas.add(new TilesheetLoader("tile_terrain_1", 16, 16, 0));
		atlas.add(new FontLoader("Kenney_Pixel",24));
		resources.add(atlas);
	}

	override function init() {
		stageColor(0.5, .5, 0.5);
		dialogCollision = new CollisionGroup();
		simulationLayer = new Layer();
		stage.addChild(simulationLayer);

		worldMap = new Tilemap("finalRoom_tmx", 1);
		worldMap.init(function(layerTilemap, tileLayer) {
			if (!tileLayer.properties.exists("noCollision")) {
				layerTilemap.createCollisions(tileLayer);
			}
			simulationLayer.addChild(layerTilemap.createDisplay(tileLayer,new Sprite("tile_dungeon_1")));
			simulationLayer.addChild(layerTilemap.createDisplay(tileLayer,new Sprite("tile_indoors_1")));
			simulationLayer.addChild(layerTilemap.createDisplay(tileLayer,new Sprite("tile_red_crystal")));
			simulationLayer.addChild(layerTilemap.createDisplay(tileLayer,new Sprite("tile_terrain_1")));
		}, parseMapObjects);

		stage.defaultCamera().limits(0, 0, worldMap.widthIntTiles * 32 , worldMap.heightInTiles * 32);
		william = new Player(250,200,simulationLayer);
		addChild(william);

		//createTouchJoystick();

		//stage.defaultCamera().postProcess=new ShRetro(Blend.blendDefault());
	}

	// function createTouchJoystick() {
	// 	touchJoystick = new VirtualGamepad();
	// 	touchJoystick.addKeyButton(XboxJoystick.LEFT_DPAD, KeyCode.Left);
	// 	touchJoystick.addKeyButton(XboxJoystick.RIGHT_DPAD, KeyCode.Right);
	// 	touchJoystick.addKeyButton(XboxJoystick.UP_DPAD, KeyCode.Up);
	// 	touchJoystick.addKeyButton(XboxJoystick.A, KeyCode.Space);
	// 	touchJoystick.addKeyButton(XboxJoystick.X, KeyCode.X);
	// 	touchJoystick.notify(chivito.onAxisChange, chivito.onButtonChange);

	// 	var gamepad = Input.i.getGamepad(0);
	// 	gamepad.notify(chivito.onAxisChange, chivito.onButtonChange);
		
	// }

	function parseMapObjects(layerTilemap:Tilemap, object:TmxObject) {
		// switch (object.objectType){
		// 	case OTTile(gid):
		// 		var sprite = new Sprite("salt");
		// 		sprite.smooth = false;
		// 		sprite.x = object.x;
		// 		sprite.y = object.y - sprite.height();
		// 		sprite.pivotY=sprite.height();
		// 		sprite.scaleX = object.width/sprite.width();
		// 		sprite.scaleY = object.height/sprite.height();
		// 		sprite.rotation = object.rotation*Math.PI/180;
		// 		simulationLayer.addChild(sprite);
		// 	case OTRectangle:
		// 		if(object.type=="dialog"){
		// 			var text=object.properties.get("text");
		// 			var dialog=new Dialog(text,object.x,object.y,object.width,object.height);
		// 			dialogCollision.add(dialog.collider);
		// 			addChild(dialog);
		// 		}
		// 	default:
		// }
	}


	override function update(dt:Float) {
		super.update(dt);
		stage.defaultCamera().scale=2;
	
		CollisionEngine.collide(william.collision,worldMap.collision);
		//CollisionEngine.overlap(dialogCollision,william.collision,dialogVsPlayer);
		stage.defaultCamera().setTarget(william.collision.x, william.collision.y);
	}

	function dialogVsPlayer(dialogCollision:ICollider,chivitoCollision:ICollider) {
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
		//touchJoystick.destroy();
	}

}
