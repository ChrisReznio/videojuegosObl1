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

class GameDialogSequence extends GameDialog {
    var text:String;
    var text2:String;
    var text3:String;
    var text4:String;
    var actualText:Int = 1;
    var textDisplay:Text;
    var texts:Array<String>;
    public function new(dialogText:String, dialogText2:String, dialogText3:String, dialogText4:String) {
        super();
        text = dialogText;
        text2 = dialogText2;
        text3 = dialogText3;
        text4 = dialogText4;
        texts = ["", text, text2, text3, text4];
    }
    override function load(resources:Resources) {
        super.load(resources);
    }

    override function init() {
        super.init();

        textDisplay=new Text(Assets.fonts.Kenney_PixelName);
        textDisplay.text=text;
        textDisplay.x = 426;
		textDisplay.y = 505;
        textDisplay.color=Color.Black;
        stage.addChild(textDisplay);
    }

    override function update(dt:Float) {
		if (Input.i.isKeyCodePressed(KeyCode.Escape)) {
			if (actualText < 4) {
                textDisplay.removeFromParent();
				actualText++;
				textDisplay = new Text(Assets.fonts.Kenney_PixelName);
				textDisplay.text = texts[actualText];
				textDisplay.x = 426;
				textDisplay.y = 505;
                textDisplay.color = Color.Black;
                stage.addChild(textDisplay);
			} else {
				close();
			}
		}
	}
}