package cinematic;

import com.collision.platformer.ICollider;
import gameObjects.William;
import states.GameState;
import com.sequencer.SequenceCode;
import com.gEngine.display.Layer;
import com.gEngine.display.Text;
import com.collision.platformer.CollisionBox;
import com.framework.utils.Entity;

class Door extends Entity {

	public var collider:CollisionBox;
    public var room:String;
    public var newPosX:Int;
    public var newPosY:Int;

	public function new(x:Float, y:Float, width:Float, height:Float, room:String, newPosX:Int, newPosY:Int) {
		super();
		collider = new CollisionBox();
		collider.x = x;
		collider.y = y;
		collider.userData = this;
		collider.width = width;
        collider.height = height;
        this.room = room;
        this.newPosX = newPosX;
        this.newPosY = newPosY;
    }

    override function update(dt:Float) {
        super.update(dt);
    }

	public function changeRoom(gameState:GameState) {
        gameState.changeState(new GameState(room, newPosX, newPosY));
    }

    public function teleportPlayer(player:William) {
        player.collision.x = newPosX;
        player.collision.y = newPosY;
    }
}
