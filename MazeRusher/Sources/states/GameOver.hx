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

class GameOver extends State {
    var message:String;
    public function new(gameOverMessage:String) {
        super();
        message = gameOverMessage;
    }
    override function load(resources:Resources) {
        var atlas:JoinAtlas=new JoinAtlas(1024,1024);
        atlas.add(new ImageLoader("brokenHeart"));
        atlas.add(new FontLoader(Assets.fonts.Kenney_PixelName,30));
        resources.add(atlas);
    }

    override function init() {
        var image=new Sprite("brokenHeart");
        image.x=GEngine.virtualWidth*0.5-image.width()*0.5;
        image.y=100;
        stage.addChild(image);
        var messageDisplay=new Text(Assets.fonts.Kenney_PixelName);
        messageDisplay.text=message;
        messageDisplay.x=GEngine.virtualWidth/2-messageDisplay.width()*0.5;
        messageDisplay.y=GEngine.virtualHeight/2;
        messageDisplay.color=Color.White;
        stage.addChild(messageDisplay);

        var playAgainDisplay=new Text(Assets.fonts.Kenney_PixelName);
        playAgainDisplay.text="Press enter to play again";
        playAgainDisplay.x=GEngine.virtualWidth/2-playAgainDisplay.width()*0.5;
        playAgainDisplay.y=GEngine.virtualHeight-100;
        playAgainDisplay.color=Color.Green;
        stage.addChild(playAgainDisplay);
    }
    override function update(dt:Float) {
        super.update(dt);
        if(Input.i.isKeyCodePressed(KeyCode.Return)){
            changeState(new GameState()); 
        }
    }
}