package cinematic;

import gameObjects.Spectre;
import gameObjects.Spider;
import gameObjects.Golem;
import gameObjects.Boss;
import states.GameState;
import com.collision.platformer.CollisionBox;
import com.framework.utils.Entity;

class Spawn extends Entity {

    public var collider:CollisionBox;
    public var activated:Bool=false;
    public var enemyType:String;
    var directionY:Int;

	public function new(x:Float, y:Float, width:Float, height:Float, type:String, dirY:Int=null) {
		super();
		collider = new CollisionBox();
		collider.x = x;
		collider.y = y;
		collider.width = width;
        collider.height = height;
        
        this.enemyType = type;
        //just for golems
        this.directionY = dirY;

        collider.userData = this;
    }

    override function update(dt:Float) {
        super.update(dt);
    }

	public function activate(gameState:GameState) {
        if(enemyType == "spider"){
            var spider = new Spider(gameState.simulationLayer, gameState.spiderCollision, collider.x, collider.y);
		    gameState.addChild(spider);
        }
        if(enemyType == "spectre"){
            var spectre = new Spectre(gameState.simulationLayer, gameState.spectreCollision, collider.x, collider.y);
		    gameState.addChild(spectre);
        }
        if(enemyType == "boss"){
            var boss = new Boss(gameState.simulationLayer, 240, gameState.bossCollision, gameState.bossAttackCollision, gameState.bossSidesCollision, 1000);
		    gameState.addChild(boss);
        }
        if(enemyType == "golem"){
            var golem;
            if(directionY>0){
                golem = new Golem(gameState.simulationLayer, gameState.golemUpCollision, collider.x, collider.y, directionY);
            }
            else{
                golem = new Golem(gameState.simulationLayer, gameState.golemDownCollision, collider.x, collider.y, directionY);
            }
		    gameState.addChild(golem);
        }
    }
}
