package states;

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

class GameFinish extends State {
    public var isReading:Bool = false;
    public function new() {
        super();
    }
    override function load(resources:Resources) {
        var atlas:JoinAtlas=new JoinAtlas(1024,1024);
        atlas.add(new FontLoader(Assets.fonts.Kenney_PixelName,30));
        resources.add(atlas);
    }

    override function init() {
        stage.color = Color.Black;
    }

    override function update(dt:Float) {
        super.update(dt);
        if(!isReading){
            openDialog();
        }
    }

    public function closeDialog(subState:State){
		removeSubState(subState);
		timeScale=1;
        changeState(new GameOver("THE END"));
    }

    function openDialog(){
        isReading = true;
        var text1 = " -Will... Is that you?";
        var text2 = " -It's been a while old friend... \n Welcome home.";
        var gameDialog = new GameDialogSequence(text1, text2, false, true);
		initSubState(gameDialog);
		addSubState(gameDialog);
        timeScale=0;
    }
}