package cinematic;

import com.collision.platformer.ICollider;
import gameObjects.William;
import states.GameState;
import com.sequencer.SequenceCode;
import com.gEngine.display.Layer;
import com.gEngine.display.Text;
import com.collision.platformer.CollisionBox;
import com.framework.utils.Entity;

class FinalDialog extends Entity {

    public var collider:CollisionBox;
    public var text:String;
    public var text2:String;
    public var text3:String;
    public var text4:String;

	public function new(x:Float, y:Float, width:Float, height:Float, aText:String, aText2:String, aText3:String, aText4:String) {
		super();
		collider = new CollisionBox();
		collider.x = x;
		collider.y = y;
		collider.userData = this;
		collider.width = width;
        collider.height = height;
        text = aText;
        text2 = aText2;
        text3 = aText3;
        text4 = aText4;
    }

    override function update(dt:Float) {
        super.update(dt);
    }
}