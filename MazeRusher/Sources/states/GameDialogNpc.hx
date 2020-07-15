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

class GameDialogNpc extends GameDialog {
    var text:String;
    public function new(dialogText:String) {
        super();
        text = dialogText;
    }

    override function load(resources:Resources){
        super.load(resources);
    }

    override function init() {
        super.init();
        var textDisplay=new Text(Assets.fonts.Kenney_PixelName);
        textDisplay.text=text;
        textDisplay.x = 426;
		textDisplay.y = 505;
        textDisplay.color=Color.Black;
        stage.addChild(textDisplay);
    }

    override function update(dt:Float) {
        super.update(dt);
    }
}