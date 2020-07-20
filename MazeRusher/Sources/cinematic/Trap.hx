package cinematic;

import com.collision.platformer.ICollider;
import gameObjects.William;
import states.GameState;
import com.sequencer.SequenceCode;
import com.gEngine.display.Layer;
import com.gEngine.display.Text;
import com.collision.platformer.CollisionBox;
import com.framework.utils.Entity;

class Trap extends Entity {

    public var collider:CollisionBox;
    public var activated:Bool=false;

	public function new(x:Float, y:Float, width:Float, height:Float) {
		super();
		collider = new CollisionBox();
		collider.x = x;
		collider.y = y;
		collider.width = width;
        collider.height = height;
        
		collider.userData = this;
    }

    override function update(dt:Float) {
        super.update(dt);
    }

	public function activate() {
        this.activated = true;
    }
}
