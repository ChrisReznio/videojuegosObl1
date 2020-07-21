package states;

import com.collision.platformer.CollisionBox;
import com.gEngine.helper.RectangleDisplay;
import com.gEngine.display.Sprite;
import kha.Color;
import com.loading.basicResources.JoinAtlas;
import com.gEngine.display.StaticLayer;
import com.gEngine.GEngine;
import com.gEngine.display.Text;
import kha.Assets;
import com.loading.basicResources.FontLoader;
import com.gEngine.display.Layer;
import kha.input.KeyCode;
import com.framework.utils.Input;
import kha.math.FastVector2;
import com.loading.basicResources.ImageLoader;
import com.loading.Resources;
import com.framework.utils.State;

class GameDialog extends State {
    var changeToGameFinish = false;
    var isGameFinish = false;
    public function new(changeToGF:Bool=null, isGF:Bool=null) {
        super();
        changeToGameFinish = changeToGF;
        isGameFinish = isGF;
    }

    override function load(resources:Resources) {
        var atlas:JoinAtlas=new JoinAtlas(1024,1024);
        atlas.add(new FontLoader(Assets.fonts.Kenney_PixelName,30));
        resources.add(atlas);
    }

    override function init() {

        var outerBoxDisplay = new RectangleDisplay();
        outerBoxDisplay.x = 399;
        outerBoxDisplay.y = 499;
        outerBoxDisplay.setColor(0,0,0);
        outerBoxDisplay.scaleX = 482;
        outerBoxDisplay.scaleY = 102;
        stage.addChild(outerBoxDisplay);

        var textBoxDisplay = new RectangleDisplay();
        textBoxDisplay.x = 400;
        textBoxDisplay.y = 500;
        textBoxDisplay.setColor(255,255,255);
        textBoxDisplay.scaleX = 480;
        textBoxDisplay.scaleY = 100;
        stage.addChild(textBoxDisplay);

        var closeDisplay=new Text(Assets.fonts.Kenney_PixelName);
        closeDisplay.text="Press space to continue";
        closeDisplay.x = textBoxDisplay.x + 110;
        closeDisplay.y = textBoxDisplay.y + 60;
        closeDisplay.color=Color.Red;
        stage.addChild(closeDisplay);
        stage.color = Color.Transparent;
    }
    override function update(dt:Float) {
        super.update(dt);
        if(Input.i.isKeyCodePressed(KeyCode.Space)){
            close();
        }
    }
    function close(){
        if(isGameFinish){
            var originalState:GameFinish = cast parentState;
            originalState.closeDialog(this);
        }
        else{
            var originalState:GameState = cast parentState;
            originalState.closeDialog(this);
            if(changeToGameFinish){
                originalState.changeState(new GameFinish());
            }
        }
    }
}