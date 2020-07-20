package cinematic;

import com.collision.platformer.ICollider;
import gameObjects.William;
import states.GameState;
import com.sequencer.SequenceCode;
import com.gEngine.display.Layer;
import com.gEngine.display.Text;
import com.collision.platformer.CollisionBox;
import com.framework.utils.Entity;

class Dialog extends Entity {

    public var collider:CollisionBox;
    public var text:Array<String>;
    public var textGuide:String;
    public var weapon:String;

	public function new(x:Float, y:Float, width:Float, height:Float, aText:Array<String>, aTextGuide:String=null, aWeapon:String=null) {
		super();
		collider = new CollisionBox();
		collider.x = x;
		collider.y = y;
		collider.width = width;
        collider.height = height;

        this.text = aText;
        this.textGuide = aTextGuide;
        this.weapon = aWeapon;

		collider.userData = this;
    }

    override function update(dt:Float) {
        super.update(dt);
    }
}
