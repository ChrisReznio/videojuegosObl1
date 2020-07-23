package states;

import com.gEngine.display.Sprite;
import kha.Color;
import com.loading.basicResources.JoinAtlas;
import com.gEngine.GEngine;
import com.gEngine.display.Text;
import kha.Assets;
import com.loading.basicResources.FontLoader;
import kha.input.KeyCode;
import com.framework.utils.Input;
import com.loading.basicResources.ImageLoader;
import com.loading.Resources;
import com.framework.utils.State;

class GameWon extends State {
    public function new() {
        super();
    }
    override function load(resources:Resources) {
        var atlas:JoinAtlas=new JoinAtlas(1024,1024);
        atlas.add(new ImageLoader("williamEnd"));
        atlas.add(new FontLoader(Assets.fonts.Kenney_PixelName,30));
        resources.add(atlas);
    }

    override function init() {
        var image=new Sprite("williamEnd");
        image.x=GEngine.virtualWidth*0.5-image.width()*0.5;
        image.y=100;
        image.scaleX = 2;
        image.scaleY = 2;
        stage.addChild(image);

        var messageDisplay=new Text(Assets.fonts.Kenney_PixelName);
        messageDisplay.text="THE END" + "\n" + "Took a while, didn't it?";
        messageDisplay.x=GEngine.virtualWidth/2-messageDisplay.width()*0.5;
        messageDisplay.y=GEngine.virtualHeight/2;
        messageDisplay.color=Color.Blue;
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