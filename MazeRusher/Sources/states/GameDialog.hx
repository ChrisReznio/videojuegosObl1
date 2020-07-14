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
    var text:String;
    var textGuide:String;
    public function new(dialogText:String, dialogTextGuide:String) {
        super();
        text = dialogText;
        textGuide = dialogTextGuide;
    }
    override function load(resources:Resources) {
        var atlas:JoinAtlas=new JoinAtlas(1024,1024);
        atlas.add(new FontLoader(Assets.fonts.Kenney_PixelName,14));
        resources.add(atlas);
    }

    override function init() {
        var textBoxDisplay = new RectangleDisplay();
        textBoxDisplay.x = 300;
        textBoxDisplay.y = 100;
        textBoxDisplay.setColor(255,222,173);
        textBoxDisplay.scaleX = 700;
        textBoxDisplay.scaleY = 500;
        stage.addChild(textBoxDisplay);

        var textDisplay=new Text(Assets.fonts.Kenney_PixelName);
        textDisplay.text=text;
        textDisplay.x = textBoxDisplay.x + 50;
        textDisplay.y = textBoxDisplay.y + 50;
        textDisplay.color=Color.Black;
        stage.addChild(textDisplay);

        var textGuideDisplay=new Text(Assets.fonts.Kenney_PixelName);
        textGuideDisplay.text=textGuide;
        textGuideDisplay.x = textBoxDisplay.x + 50;
        textGuideDisplay.y = textBoxDisplay.y + 300;
        textGuideDisplay.color=Color.Purple;
        stage.addChild(textGuideDisplay);

        var closeDisplay=new Text(Assets.fonts.Kenney_PixelName);
        closeDisplay.text="Press escape to close";
        closeDisplay.x = textBoxDisplay.x + 50;
        closeDisplay.y = textBoxDisplay.y + 400;
        closeDisplay.color=Color.Red;
        stage.addChild(closeDisplay);
        stage.color = Color.Transparent;
    }
    override function update(dt:Float) {
        super.update(dt);
        if(Input.i.isKeyCodePressed(KeyCode.Escape)){
            close();
        }
    }
    function close(){
        var originalState:GameState = cast parentState;
        originalState.closeDialog(this);
    }
}