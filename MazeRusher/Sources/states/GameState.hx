package states;

import gameObjects.Boss;
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

import com.gEngine.GEngine;
import com.gEngine.display.Layer;
import GlobalGameData.GGD;


class GameState extends State {
	var initialPosX:Float = 32*4;
	var initialPosY:Float = 32*14;
	var actualMap:String = "startingArea_tmx";
	var worldMap:Tilemap;
	var william:William;
	var isOverlapping:Bool = false;

	public var simulationLayer:Layer;
	public var attackLayer:Layer;
	var hudLayer:Layer;

	var lifeDisplay:Sprite;
	var weaponDisplay:Sprite;
	var interactionDisplay:Sprite;

	var doorsCollision:CollisionGroup;
	var teleportersCollision:CollisionGroup;
	public var spiderCollision:CollisionGroup;
	public var spectreCollision:CollisionGroup;
	public var golemUpCollision:CollisionGroup;
	public var golemDownCollision:CollisionGroup;
	public var bossCollision:CollisionGroup;
	public var bossAttackCollision:CollisionGroup;
	public var bossSidesCollision:CollisionGroup;
	var trapsCollision:CollisionGroup;
	var spawnCollision:CollisionGroup;
	var booksCollision:CollisionGroup;
	var npcsCollision:CollisionGroup;
	var crystalCollision:CollisionGroup;

	var screenWidth:Float;
	var screenHeight:Float;
	var playerHeight:Float = 32;

	public var isReading:Bool = false;
	var timeSinceRead:Float = 0;
	var readCooldown:Float = 0.2;
	var hasRead:Bool = false;

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
		atlas.add(new SpriteSheetLoader("dialga", 48, 72, 0, [
			new Sequence("attackBack", [0,1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17]),
			new Sequence("attackFront", [18,19,20,21,22,23,24,25,26,27,28,29,30,31,32,33,34,35]),
			new Sequence("idleBack", [36,36,36,36,37,37,37]),
			new Sequence("idleFront", [38,38,38,38,39,39,39]),
			new Sequence("damagedBack", [40]),
			new Sequence("damagedFront", [41])
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
		atlas.add(new SpriteSheetLoader("chest", 105, 41, 0, [
			new Sequence("available", [0]),
			new Sequence("unavailable", [1])
		]));
		atlas.add(new SpriteSheetLoader("roarOfTime", 222, 510, 0, [
			new Sequence("attack", [0,1])
		]));
		atlas.add(new FontLoader("Kenney_Pixel",24));
		resources.add(atlas);
		resources.add(new SoundLoader("ambientalTheme",false));
		resources.add(new SoundLoader("finalStageTheme",false));
		resources.add(new SoundLoader("bossTheme",false));
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
		bossCollision = new CollisionGroup();
		bossAttackCollision = new CollisionGroup();
		bossSidesCollision = new CollisionGroup();
		trapsCollision = new CollisionGroup();
		spawnCollision = new CollisionGroup();
		booksCollision= new CollisionGroup();
		npcsCollision = new CollisionGroup();
		crystalCollision = new CollisionGroup();
		simulationLayer = new Layer();
		attackLayer = new Layer();

		stage.addChild(simulationLayer);
		stage.addChild(attackLayer);

		GGD.simulationLayer = simulationLayer;
		GGD.attackLayer = attackLayer;
		GGD.camera=stage.defaultCamera();

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
		
		initializeWilliam(initialPosX,initialPosY,simulationLayer);
		
		initializeHUD();
	}

	inline function initializeWilliam(x:Float,y:Float,layer:Layer){
		william = new William(x,y,layer);
		addChild(william);
		GGD.player = william;
	}

	inline function initializeHUD(){
		hudLayer = new StaticLayer();
		stage.addChild(hudLayer);
		lifeDisplay = new Sprite("playerLife");
		weaponDisplay = new Sprite("unlockableItems");
		interactionDisplay = new Sprite("chest");
		interactionDisplay.timeline.playAnimation("unavailable");
		hudLayer.addChild(lifeDisplay);
		hudLayer.addChild(weaponDisplay);
		hudLayer.addChild(interactionDisplay);
		lifeDisplay.x = 20;
		lifeDisplay.y = 30;
		lifeDisplay.scaleX = lifeDisplay.scaleY = 2;
		weaponDisplay.x = 550;
		weaponDisplay.y = 620;
		weaponDisplay.scaleX = weaponDisplay.scaleY = 1.5;
		interactionDisplay.x = 550;
		interactionDisplay.y = 30;
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
					if(object.properties.exists("isLocked")){
						door.lockDoor();
					}
					addChild(door);
				}
				if(object.properties.exists("isTeleporter")){
						var teleporter = new Door(object.x,object.y,object.width,object.height, null, Std.parseInt(object.properties.get("goToX")), Std.parseInt(object.properties.get("goToY")));
						teleportersCollision.add(teleporter.collider);
						addChild(teleporter);
				}
				if(object.properties.exists("isBook")){
					var texts = [object.properties.get("text")];
					var dialog = new Dialog(object.x, object.y, object.width, object.height, texts, object.properties.get("textGuide"), null);
					booksCollision.add(dialog.collider);
					addChild(dialog);
				}
				if(object.properties.exists("isNPC")){
					var texts = [object.properties.get("text")];
					var dialog = new Dialog(object.x, object.y, object.width, object.height, texts, null, object.properties.get("hasItem"));
					npcsCollision.add(dialog.collider);
					addChild(dialog);
				}
				if(object.properties.exists("isCrystal")){
					var texts = [object.properties.get("text"), object.properties.get("text2")];
					var dialog = new Dialog(object.x, object.y, object.width, object.height, texts, null, null);
					crystalCollision.add(dialog.collider);
					addChild(dialog);
				}
				if(object.properties.exists("isTrap")){
					var trap = new Trap(object.x, object.y, object.width, object.height);
					trapsCollision.add(trap.collider);
					addChild(trap);
				}
				if(object.properties.exists("isSpawn")){
					var spawn = new Spawn(object.x, object.y, object.width, object.height, object.properties.get("enemyType"), Std.parseInt(object.properties.get("dirY")));
						spawnCollision.add(spawn.collider);
						addChild(spawn);
					if(object.properties.get("enemyType") == "spectre" || object.properties.get("enemyType") == "boss"){
						spawn.activate(this);
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

		isOverlapping = false;

		//characters and overworld collisions
		CollisionEngine.collide(william.collision,worldMap.collision);
		CollisionEngine.collide(spiderCollision, worldMap.collision);
		CollisionEngine.collide(golemUpCollision, worldMap.collision, golemVsWalls);
		CollisionEngine.collide(golemDownCollision, worldMap.collision, golemVsWalls);

		//player and doors overlaps
		CollisionEngine.overlap(william.collision, doorsCollision, williamVsDoor);
		CollisionEngine.overlap(william.collision, teleportersCollision, williamVsTeleporter);

		//enemies damaging player interactions
		CollisionEngine.collide(william.collision, spiderCollision, williamVsSpider);
		CollisionEngine.collide(william.collision, golemUpCollision, williamVsGolem);
		CollisionEngine.collide(william.collision, golemDownCollision, williamVsGolem);
		CollisionEngine.overlap(william.collision, spectreCollision, williamVsSpectre);
		CollisionEngine.overlap(bossCollision, william.collision, williamVsBossSides);
		CollisionEngine.overlap(bossSidesCollision, william.collision, williamVsBossSides);
		CollisionEngine.overlap(bossAttackCollision, william.collision, williamVsBossAttacks);

		//weapon interactions
		CollisionEngine.overlap(william.weapon.slashCollisions, spiderCollision, attackVsSpider);
		CollisionEngine.overlap(william.weapon.slashCollisions, bossCollision, attackVsBoss);
		CollisionEngine.overlap(william.rangedWeapon.swapparangCollisions, bossCollision, boomerangVsBoss);
		CollisionEngine.overlap(william.rangedWeapon.swapparangCollisions, golemUpCollision, boomerangVsGolem);
		CollisionEngine.overlap(william.rangedWeapon.swapparangCollisions, golemDownCollision, boomerangVsGolem);
		CollisionEngine.collide(william.rangedWeapon.swapparangCollisions, worldMap.collision, boomerangVsWalls);
		CollisionEngine.overlap(william.instrument.instrumentCollisions, spiderCollision, stunSpiders);
		CollisionEngine.overlap(william.instrument.instrumentCollisions, spectreCollision, stunSpectre);
		
		//player stepping on spawnpoints
		CollisionEngine.overlap(william.collision, trapsCollision, activateSpawns);
		
		//special golem collision
		CollisionEngine.collide(golemUpCollision, golemDownCollision, golemVsGolem);

		//open dialogs
		if(!isReading && !hasRead){
			CollisionEngine.overlap(booksCollision, william.collision, williamVsBook);
			CollisionEngine.overlap(npcsCollision, william.collision, williamVsNpc);
			CollisionEngine.overlap(crystalCollision, william.collision, williamVsCrystal);
		}

		if(timeSinceRead >= readCooldown){
			hasRead = false;
			timeSinceRead = 0;
		}
		if(hasRead){
			timeSinceRead+=dt;
		}
		stage.defaultCamera().setTarget(william.collision.x, william.collision.y);

		showCurrentLives();
		showCurrentItems();
		showInteractions();
	}

	function golemVsWalls(mapCollision:ICollider, golemCollision:ICollider){
		var golem:Golem = cast golemCollision.userData;
		golem.invertDirection();
	}

	function williamVsDoor(doorCollision:ICollider, playerCollision:ICollider) {
		var door:Door = cast doorCollision.userData;
		if(!door.isLocked){
			door.changeRoom(this);
		}
		else if(GGD.bossDefeated){
			door.changeRoom(this);
		}
	}

	function williamVsTeleporter(teleporterCollision:ICollider, playerCollision:ICollider) {
		var teleporter:Door = cast teleporterCollision.userData;
		var player:William = cast playerCollision.userData;
		teleporter.teleportPlayer(player);
	}

	function williamVsSpider(spiderCollision:ICollider, playerCollision:ICollider) {
		var spider:Spider = cast spiderCollision.userData;
		var player:William = cast playerCollision.userData;
		spider.attack();
		player.takeDamage();
		if(GGD.lives == 0){
			GGD.destroy();
			changeState(new GameOver("Too bad... you won't be seeing your brother anytime soon"));
		}
	}

	function williamVsGolem(playerCollision:ICollider, golemCollision:ICollider){
		william.takeDamage();
		if(GGD.lives == 0){
			GGD.destroy();
			changeState(new GameOver("Too bad... you won't be seeing your brother anytime soon"));
		}
	}

	function williamVsSpectre(spectreCollision:ICollider, playerCollision:ICollider) {
		var spectre:Spectre = cast spectreCollision.userData;
		var player:William = cast playerCollision.userData;
		GGD.destroy();
		changeState(new GameOver("Don't try getting close to a spectre. They will kill you instantly"));
	}

	function williamVsBossAttacks(bossAttackCollision:ICollider, playerCollision:ICollider){
		william.takeDamage();
		if(GGD.lives == 0){
			GGD.destroy();
			changeState(new GameOver("Too bad... you won't be seeing your brother anytime soon"));
		}
	}

	function williamVsBossSides(bosssidesCollision:ICollider, playerCollision:ICollider){
		william.pushBack();
	}
	function attackVsSpider(attackCollision:ICollider, spiderCollision:ICollider) {
		var spider:Spider = cast spiderCollision.userData;
		spider.takeDamage();
	}

	function attackVsBoss(attackCollision:ICollider, bossCollision:ICollider){
		var boss:Boss = cast bossCollision.userData;
		boss.takeDamage();
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

	function boomerangVsBoss(boomerangCollision:ICollider, bossCollision:ICollider){
		var boomerang:Swapparang = cast boomerangCollision.userData;
		boomerang.die();
		var boss:Boss = cast bossCollision.userData;
		var old_y = boss.collision.y;
		var old_x = boss.collision.x;
		var new_y = william.collision.y;
		william.dissapear();
		boss.collision.y = new_y;
		this.william = new William(old_x, old_y, simulationLayer);
		GGD.player = william;
		addChild(GGD.player);
	}

	function boomerangVsWalls(wallCollision:ICollider, boomerangCollision:ICollider){
		var boomerang:Swapparang = cast boomerangCollision.userData;
		boomerang.die();
	}

	function stunSpiders(attackCollision:ICollider, enemyCollision:ICollider) {
		var enemy:Spider = cast enemyCollision.userData;
		enemy.stun();
	}

	function stunSpectre(attackCollision:ICollider, enemyCollision:ICollider) {
		var enemy:Spectre = cast enemyCollision.userData;
		enemy.stun();
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

	function golemVsGolem(golemCollision1:ICollider, golemCollision2:ICollider){
		var golem1:Golem = cast golemCollision1.userData;
		var golem2:Golem = cast golemCollision2.userData;
		golem1.invertDirection();
		golem2.invertDirection();
	}

	function williamVsBook(booksCollision:ICollider, playerCollision:ICollider){
		isOverlapping = true;
		if (!isReading) {
			var dialog:Dialog = cast booksCollision.userData;
			if (Input.i.isKeyCodePressed(KeyCode.Space)) {
				openBookDialog(dialog.text[0], dialog.textGuide);
			}
		}
	}

	function williamVsNpc(npcsCollision:ICollider, playerCollision:ICollider) {
		isOverlapping = true;
		if (!isReading) {
			var dialog:Dialog = cast npcsCollision.userData;
			if (Input.i.isKeyCodePressed(KeyCode.Space)) {
				openNpcDialog(dialog.text[0]);
				unlockItem(dialog.weapon);
			}
		}
	}

	function williamVsCrystal(crystalCollision:ICollider, playerCollision:ICollider) {
		isOverlapping = true;
		if (!isReading) {
			var dialog:Dialog = cast crystalCollision.userData;
			if (Input.i.isKeyCodePressed(KeyCode.Space)) {
				openCrystalDialog(dialog.text[0], dialog.text[1]);
			}
		}
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
		} else if (GGD.unlockedSwapparang && GGD.unlockedBagpipe && GGD.bagpipeCoolDown <= 0 && GGD.swapparangCoolDown <= 0) {
			weaponDisplay.timeline.playAnimation("zxc");
		} else {
			weaponDisplay.timeline.playAnimation("z");
		}
	}

	function showInteractions() {
		if(isOverlapping){
			interactionDisplay.timeline.playAnimation("available");
		}else{
			interactionDisplay.timeline.playAnimation("unavailable");
		}
	}

	function openBookDialog(text:String, textGuide:String) {
		isReading = true;
		var gameDialog = new GameDialogBook(text, textGuide);
		initSubState(gameDialog);
		addSubState(gameDialog);
		timeScale = 0;
	}

	function openNpcDialog(text:String) {
		isReading = true;
		var texts = [text];
		var gameDialog = new GameDialogSequence(texts, false, false);
		initSubState(gameDialog);
		addSubState(gameDialog);
		timeScale = 0;
	}

	function openCrystalDialog(text:String, text2:String) {
		isReading = true;
		var texts = [text, text2];
		var gameDialog = new GameDialogSequence(texts, true, false);
		initSubState(gameDialog);
		addSubState(gameDialog);
		timeScale = 0;
	}

	public function closeDialog(subState:State){
		removeSubState(subState);
		timeScale=1;
		isReading = false;
		hasRead = true;
	}

	public function unlockItem(name:String){
		if(name == "bagpipe"){
			GGD.unlockedBagpipe = true;
		}else if(name == "swapparang"){
			GGD.unlockedSwapparang = true;
		}
	}
	
	// #if DEBUGDRAW
	// override function draw(framebuffer:kha.Canvas) {
	// 	super.draw(framebuffer);
	// 	var camera = stage.defaultCamera();
	// 	CollisionEngine.renderDebug(framebuffer, camera);
	// }
	// #end
	override function destroy() {
		super.destroy();
	}

}