package states;

import com.soundLib.SoundManager;
import com.loading.basicResources.SoundLoader;
import js.html.TextTrackCueList;
import gameObjects.Swapparang;
import kha.math.FastVector2;
import js.html.SpeechSynthesisErrorEvent;
import com.gEngine.display.StaticLayer;
import gameObjects.Slash;
import com.framework.utils.JoystickProxy;
import haxe.Int32;
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
import com.gEngine.display.extra.TileMapDisplay;
import com.collision.platformer.Sides;
import com.framework.utils.XboxJoystick;
import com.framework.utils.VirtualGamepad;
import format.tmx.Data.TmxObject;
import kha.input.KeyCode;
import com.framework.utils.Input;
import com.collision.platformer.CollisionEngine;
import gameObjects.William;
import gameObjects.Spider;
import gameObjects.Spectre;
import gameObjects.Golem;
import com.loading.basicResources.TilesheetLoader;
import com.loading.basicResources.SpriteSheetLoader;
import com.gEngine.display.Layer;
import com.loading.basicResources.DataLoader;
import com.collision.platformer.Tilemap;
import com.loading.basicResources.JoinAtlas;
import com.loading.Resources;
import com.framework.utils.State;
import cinematic.Door;
import cinematic.Trap;
import cinematic.Spawn;
import cinematic.Dialog;
import cinematic.FinalDialog;

import com.gEngine.GEngine;
import com.gEngine.display.Layer;
import GlobalGameData.GGD;


class GameState extends State {
	var initialPosX:Float = 32*4;
	var initialPosY:Float = 32*14;
	var actualMap:String = "startingArea_tmx";
	var worldMap:Tilemap;
	var william:William;

	public var simulationLayer:Layer;
	var hudLayer:Layer;

	var lifeDisplay:Sprite;
	var weaponDisplay:Sprite;

	var touchJoystick:VirtualGamepad;

	var doorsCollision:CollisionGroup;
	var teleportersCollision:CollisionGroup;
	public var spiderCollision:CollisionGroup;
	public var spectreCollision:CollisionGroup;
	public var golemUpCollision:CollisionGroup;
	public var golemDownCollision:CollisionGroup;
	var interactionCollision:CollisionGroup;
	var spawnCollision:CollisionGroup;
	var booksCollision:CollisionGroup;
	var npcsCollision:CollisionGroup;
	var crystalCollision:CollisionGroup;

	var screenWidth:Float;
	var screenHeight:Float;
	var playerHeight:Float = 32;

	public function new(room:String = null, playerPosX:Float = null, playerPosY:Float = null) {
		super();
		if(room != null){
			initialPosX = playerPosX;
			initialPosY = playerPosY;
			actualMap = room;
		}
	}

	override function load(resources:Resources) {
		resources.add(new DataLoader(actualMap));

		var atlas = new JoinAtlas(4096, 4096);

		atlas.add(new TilesheetLoader("tile_terrain", 16, 16, 0));
		atlas.add(new TilesheetLoader("tile_indoors", 16, 16, 0));
		atlas.add(new ImageLoader("tile_crystal"));
		atlas.add(new ImageLoader("book1nobackg"));
		atlas.add(new ImageLoader("book2nobackg"));
		atlas.add(new ImageLoader("book3nobackg"));
		atlas.add(new ImageLoader("skeleton1nobackg"));
		atlas.add(new ImageLoader("skeleton2nobackg"));
		atlas.add(new SpriteSheetLoader("playerLife", 66, 22, 0, [
			new Sequence("fullLife", [0]),
			new Sequence("2Lives", [1]),
			new Sequence("1Life", [2])
		]));
		atlas.add(new SpriteSheetLoader("unlockableItems", 144, 48, 0, [
			new Sequence("noItems", [0]),
			new Sequence("z", [1]),
			new Sequence("x", [2]),
			new Sequence("c", [3]),
			new Sequence("zx", [4]),
			new Sequence("zc", [5]),
			new Sequence("xc", [6]),
			new Sequence("zxc", [7])
		]));
		atlas.add(new SpriteSheetLoader("william", 32, 32, 0, [
			new Sequence("idleFront", [0]),
			new Sequence("idleBack", [3]),
			new Sequence("idleSide", [6]),
			new Sequence("walkFront", [0, 1, 2]),
			new Sequence("walkBack", [3, 4, 5]),
			new Sequence("walkSide", [6, 7, 8]),
			new Sequence("damaged", [14, 15]),
			new Sequence("talking", [16])
		]));
		atlas.add(new SpriteSheetLoader("darkrai", 32, 32, 0, [
			new Sequence("walkBack", [0,1,2]),
			new Sequence("walkDiagonalBack", [3, 4, 5]),
			new Sequence("walkSide", [6,7,8]),
			new Sequence("walkDiagonalFront", [9,10,11]),
			new Sequence("walkFront", [12,13,14])
		]));
		atlas.add(new SpriteSheetLoader("golem", 48, 48, 0, [
			new Sequence("walkBack", [0,2]),
			new Sequence("walkFront", [3,5]),
			new Sequence("idle", [6,7])
		]));
		atlas.add(new SpriteSheetLoader("joltik", 32, 32, 0, [
			new Sequence("idleFront", [8]),
			new Sequence("idleBack", [2]),
			new Sequence("idleSide", [14]),
			new Sequence("walkBack", [0, 1, 2]),
			new Sequence("walkFront", [6, 8, 8, 7, 8, 8]),
			new Sequence("walkSide", [14, 12, 14, 13]),
			new Sequence("attackBack", [3, 4]),
			new Sequence("attackFront", [9, 10]),
			new Sequence("attackSide", [15, 16]),
			new Sequence("damagedBack", [5]),
			new Sequence("damagedFront", [11]),
			new Sequence("damagedSide", [17])
		]));
		atlas.add(new SpriteSheetLoader("slash_attack", 36, 36, 0, [
			new Sequence("attack", [0,1,2,3,4])
		]));
		atlas.add(new SpriteSheetLoader("boomerang", 32, 32, 0, [
			new Sequence("attack", [0])
		]));
		atlas.add(new SpriteSheetLoader("song", 12, 188, 0, [
			new Sequence("play", [0,1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19])
		]));
		atlas.add(new FontLoader("Kenney_Pixel",24));
		resources.add(atlas);
		resources.add(new SoundLoader("ambientalTheme",false));
		resources.add(new SoundLoader("finalStageTheme",false));
		resources.add(new SoundLoader("finalBattleTheme",false));
		resources.add(new SoundLoader("slashSoundEffect"));
		resources.add(new SoundLoader("playerDamageSoundEffect"));
		resources.add(new SoundLoader("bagpipeSoundEffect"));
		resources.add(new SoundLoader("boomerangSoundEffect"));
	}

	override function init() {
		screenWidth = GEngine.i.width;
        screenHeight = GEngine.i.height;
		stageColor(0.5, .5, 0.5);
		doorsCollision = new CollisionGroup();
		teleportersCollision = new CollisionGroup();
		spiderCollision = new CollisionGroup();
		spectreCollision = new CollisionGroup();
		golemUpCollision = new CollisionGroup();
		golemDownCollision = new CollisionGroup();
		interactionCollision = new CollisionGroup();
		spawnCollision = new CollisionGroup();
		booksCollision= new CollisionGroup();
		npcsCollision = new CollisionGroup();
		crystalCollision = new CollisionGroup();
		simulationLayer = new Layer();

		stage.addChild(simulationLayer);

		worldMap = new Tilemap(actualMap, 1);


		worldMap.init(function(layerTilemap, tileLayer) {
			stage.defaultCamera().scale=2.5;
			if (tileLayer.properties.get("tilesheet") == "indoors"){
				simulationLayer.addChild(layerTilemap.createDisplay(tileLayer,new Sprite("tile_indoors")));
			}
			else{
				simulationLayer.addChild(layerTilemap.createDisplay(tileLayer,new Sprite("tile_terrain")));
			}

			if (tileLayer.properties.exists("cannotPass")) {
				layerTilemap.createCollisions(tileLayer);
			}
		}, parseMapObjects);

		stage.defaultCamera().limits(0, 0, worldMap.widthIntTiles * 16 , worldMap.heightInTiles * 16);
		
		william = new William(initialPosX,initialPosY,simulationLayer);
		addChild(william);
		GGD.player = william;
		GGD.simulationLayer = simulationLayer;
		GGD.camera=stage.defaultCamera();
		
		hudLayer = new StaticLayer();
		stage.addChild(hudLayer);
		lifeDisplay = new Sprite("playerLife");
		weaponDisplay = new Sprite("unlockableItems");
		hudLayer.addChild(lifeDisplay);
		hudLayer.addChild(weaponDisplay);
		lifeDisplay.x = 20;
		lifeDisplay.y = 30;
		lifeDisplay.scaleX = lifeDisplay.scaleY = 2;
		weaponDisplay.x = 550;
		weaponDisplay.y = 620;
		weaponDisplay.scaleX = weaponDisplay.scaleY = 1.5;
	}

	function parseMapObjects(layerTilemap:Tilemap, object:TmxObject) {
		switch (object.objectType){
			case OTTile(gid):
				var spriteName = object.properties.get("sprite");
				var sprite = new Sprite(spriteName);
				sprite.smooth = false;
				sprite.x = object.x;
				sprite.y = object.y - sprite.height();
				sprite.pivotY=sprite.height();
				simulationLayer.addChild(sprite);
			case OTRectangle:
				if(object.properties.exists("isDoor")){
					var door = new Door(object.x, object.y, object.width, object.height, object.properties.get("goToMap"),
						Std.parseInt(object.properties.get("goToX")), Std.parseInt(object.properties.get("goToY")));
					doorsCollision.add(door.collider);
					addChild(door);
				}
				if(object.properties.exists("isTeleporter")){
						var teleporter = new Door(object.x,object.y,object.width,object.height, null, Std.parseInt(object.properties.get("goToX")), Std.parseInt(object.properties.get("goToY")));
						teleportersCollision.add(teleporter.collider);
						addChild(teleporter);
				}
				if(object.properties.exists("isBook")){
					var dialog = new Dialog(object.x, object.y, object.width, object.height, object.properties.get("text"), object.properties.get("textGuide"));
					booksCollision.add(dialog.collider);
					addChild(dialog);
				}
				if(object.properties.exists("isNPC")){
					var dialog = new Dialog(object.x, object.y, object.width, object.height, object.properties.get("text"), null, object.properties.get("hasItem"));
					npcsCollision.add(dialog.collider);
					addChild(dialog);
				}
				if(object.properties.exists("isCrystal")){
					var dialog = new FinalDialog(object.x, object.y, object.width, object.height, object.properties.get("text"), object.properties.get("text2"), object.properties.get("text3"), object.properties.get("text4"));
					crystalCollision.add(dialog.collider);
					addChild(dialog);
				}
				if(object.properties.exists("activatesSpawn")){
					var trap = new Trap(object.x, object.y, object.width, object.height);
					interactionCollision.add(trap.collider);
					addChild(trap);
				}
				if(object.properties.exists("isSpawn")){
					if(object.properties.get("enemyType") == "spectre"){
						var spawn = new Spawn(object.x, object.y, object.width, object.height, "spectre");
						spawnCollision.add(spawn.collider);
						addChild(spawn);
						spawn.activate(this);
					}
					else{
						var spawn = new Spawn(object.x, object.y, object.width, object.height, object.properties.get("enemyType"), Std.parseInt(object.properties.get("dirY")));
						spawnCollision.add(spawn.collider);
						addChild(spawn);
					}
				}
			case OTEllipse:
				if (object.properties.exists("music")) {
					SoundManager.playMusic(object.properties.get("music"), true);
					SoundManager.musicVolume(0.4);
				};

			default: 
		}
	}

	override function update(dt:Float) {
		super.update(dt);
	
		simulationLayer.sort(Layer.sortYCompare);
		//CollisionEngine.collide(william.collision,worldMap.collision);
		CollisionEngine.collide(spiderCollision,worldMap.collision);
		CollisionEngine.overlap(william.collision, doorsCollision, playerVsDoor);
		CollisionEngine.overlap(william.collision, teleportersCollision, playerVsTeleporter);
		CollisionEngine.collide(william.collision, spiderCollision, playerVsSpider);
		CollisionEngine.overlap(william.weapon.slashCollisions, spiderCollision, attackVsSpider);
		CollisionEngine.overlap(william.rangedWeapon.swapparangCollisions, golemUpCollision, boomerangVsGolem);
		CollisionEngine.overlap(william.rangedWeapon.swapparangCollisions, golemDownCollision, boomerangVsGolem);
		CollisionEngine.collide(william.rangedWeapon.swapparangCollisions, worldMap.collision, boomerangVsWalls);
		CollisionEngine.overlap(william.instrument.instrumentCollisions, spiderCollision, stunSpiders);
		CollisionEngine.overlap(william.instrument.instrumentCollisions, spectreCollision, stunSpectre);
		CollisionEngine.collide(william.collision, golemUpCollision, williamVsGolem);
		CollisionEngine.collide(william.collision, golemDownCollision, williamVsGolem);
		CollisionEngine.overlap(william.collision, interactionCollision, activateSpawns);
		CollisionEngine.overlap(william.collision, spectreCollision, playerVsSpectre);
		CollisionEngine.collide(golemUpCollision, worldMap.collision, golemVsWalls);
		CollisionEngine.collide(golemDownCollision, worldMap.collision, golemVsWalls);
		CollisionEngine.collide(golemUpCollision, golemDownCollision, golemVsGolem);
		CollisionEngine.overlap(booksCollision, william.collision, williamVsBook);
		CollisionEngine.overlap(npcsCollision, william.collision, williamVsNpc);
		CollisionEngine.overlap(crystalCollision, william.collision, williamVsCrystal);

		stage.defaultCamera().setTarget(william.collision.x, william.collision.y);

		showCurrentLives();
		showCurrentItems();
	}
	function williamVsCrystal(crystalCollision:ICollider, playerCollision:ICollider){
		var dialog:FinalDialog = cast crystalCollision.userData;
		if (Input.i.isKeyCodePressed(KeyCode.Space)){
			openCrystalDialog(dialog.text, dialog.text2, dialog.text3, dialog.text4);
		}
	}
	
	function williamVsBook(booksCollision:ICollider, playerCollision:ICollider){
		var dialog:Dialog = cast booksCollision.userData;
		if (Input.i.isKeyCodePressed(KeyCode.Space)){
			openBookDialog(dialog.text, dialog.textGuide);
		}
	}

	function williamVsNpc(npcsCollision:ICollider, playerCollision:ICollider){
		var dialog:Dialog = cast npcsCollision.userData;
		if (Input.i.isKeyCodePressed(KeyCode.Space)){
			openNpcDialog(dialog.text);
			unlockItem(dialog.weapon);
		}
	}

	function activateSpawns(interactionCollision:ICollider, playerCollision:ICollider){
		var trap:Trap = cast interactionCollision.userData;
		if (!trap.activated) {
			trap.activate();
			for (spawn in this.spawnCollision.colliders) {
				var spawnpoint:Spawn = cast spawn.userData;
				spawnpoint.activate(this);
			}
		}
	}

	function williamVsGolem(playerCollision:ICollider, golemCollision:ICollider){
		william.takeDamage();
		if(GGD.lives == 0){
			GGD.destroy();
			changeState(new GameOver("Too bad... you won't be seeing your brother anytime soon"));
		}
	}

	function golemVsWalls(mapCollision:ICollider, golemCollision:ICollider){
		var golem:Golem = cast golemCollision.userData;
		golem.invertDirection();
	}

	function golemVsGolem(golemCollision1:ICollider, golemCollision2:ICollider){
		var golem1:Golem = cast golemCollision1.userData;
		var golem2:Golem = cast golemCollision2.userData;
		golem1.invertDirection();
		golem2.invertDirection();
	}

	function boomerangVsWalls(wallCollision:ICollider, boomerangCollision:ICollider){
		var boomerang:Swapparang = cast boomerangCollision.userData;
		boomerang.die();
	}

	function boomerangVsGolem(boomerangCollision:ICollider, golemCollision:ICollider){
		var boomerang:Swapparang = cast boomerangCollision.userData;
		boomerang.die();
		var old_x = william.collision.x;
		var old_y = william.collision.y;
		var golem:Golem = cast golemCollision.userData;
		var new_x = golem.collision.x;
		var new_y = golem.collision.y;
		golem.dissapear();
		william.collision.x = new_x;
		william.collision.y = new_y;
		golem = new Golem(simulationLayer, golemDownCollision, old_x, old_y, 0);
		addChild(golem);
	}

	function playerVsDoor(doorCollision:ICollider, playerCollision:ICollider) {
		var door:Door = cast doorCollision.userData;
		door.changeRoom(this);
	}

	function playerVsTeleporter(teleporterCollision:ICollider, playerCollision:ICollider) {
		var teleporter:Door = cast teleporterCollision.userData;
		var player:William = cast playerCollision.userData;
		teleporter.teleportPlayer(player);
	}

	function playerVsSpider(spiderCollision:ICollider, playerCollision:ICollider) {
		var spider:Spider = cast spiderCollision.userData;
		var player:William = cast playerCollision.userData;
		spider.attack();
		player.takeDamage();
		if(GGD.lives == 0){
			GGD.destroy();
			changeState(new GameOver("Too bad... you won't be seeing your brother anytime soon"));
		}
	}

	function playerVsSpectre(spectreCollision:ICollider, playerCollision:ICollider) {
		var spectre:Spectre = cast spectreCollision.userData;
		var player:William = cast playerCollision.userData;
		GGD.destroy();
		changeState(new GameOver("Don't try getting close to a spectre. They will kill you instantly"));
	}

	function attackVsSpider(attackCollision:ICollider, spiderCollision:ICollider) {
		var spider:Spider = cast spiderCollision.userData;
		spider.takeDamage();
	}

	function stunSpectre(attackCollision:ICollider, enemyCollision:ICollider) {
		var enemy:Spectre = cast enemyCollision.userData;
		enemy.stun();
	}

	function stunSpiders(attackCollision:ICollider, enemyCollision:ICollider) {
		var enemy:Spider = cast enemyCollision.userData;
		enemy.stun();
	}

	function showCurrentLives() {
		if(GGD.lives == 3){
			lifeDisplay.timeline.playAnimation("fullLife");
		}
		else if(GGD.lives == 2){
			lifeDisplay.timeline.playAnimation("2Lives");
		}
		else{
			lifeDisplay.timeline.playAnimation("1Life");
		}
	}

	function showCurrentItems() {
		if((!GGD.unlockedSwapparang || GGD.swapparangCoolDown > 0) && GGD.unlockedBagpipe && GGD.bagpipeCoolDown <= 0){
			weaponDisplay.timeline.playAnimation("zx");
		}
		else if(GGD.unlockedSwapparang && (!GGD.unlockedBagpipe || GGD.bagpipeCoolDown > 0) && GGD.swapparangCoolDown <= 0){
			weaponDisplay.timeline.playAnimation("zc");
		}
		else if(GGD.unlockedSwapparang && GGD.unlockedBagpipe && GGD.bagpipeCoolDown <= 0 && GGD.swapparangCoolDown <= 0){
			weaponDisplay.timeline.playAnimation("zxc");
		}
		else{
			weaponDisplay.timeline.playAnimation("z");
		}
	}
	function openBookDialog(text:String, textGuide:String){
		var gameDialog = new GameDialogBook(text, textGuide);
		initSubState(gameDialog);
		addSubState(gameDialog);
		timeScale=0;
	}

	function openNpcDialog(text:String){
		var gameDialog = new GameDialogNpc(text);
		initSubState(gameDialog);
		addSubState(gameDialog);
		timeScale=0;
	}

	function openCrystalDialog(text:String, text2:String, text3:String, text4:String){
		var gameDialog = new GameDialogSequence(text, text2, text3, text4);
		initSubState(gameDialog);
		addSubState(gameDialog);
		timeScale=0;
	}

	public function closeDialog(subState:State){
		removeSubState(subState);
		timeScale=1;
	}

	public function unlockItem(name:String){
		if(name == "bagpipe"){
			GGD.unlockedBagpipe = true;
		}else if(name == "swapparang"){
			GGD.unlockedSwapparang = true;
		}
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
	}

}