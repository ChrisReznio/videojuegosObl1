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

class GameStart extends State {
    var message:String;
    public function new() {
        super();
        message = "Legends of old, tell there exists an ancient maze in this world, one\n" +
        "which hides a crystal at the end of its path.\n" +
        "It it said that Whoever manages to reach it, will have his wildest desires\n" +
        "be granted in front of his eyes.\n" +
        "\n" +
        "Long ago, a young man named Gwegwein took off on a trip to grant his wishes.\n" +
        "However, little did Gwegwein know about the dangers it hid, and ended\n" +
        "up dying halfway; along with his wishes.\n" +
        "\n"+
        "Despite that, this is not your story, and neither is this how Gwegwein's story\n" +
        "should end.\n" +
        "This is William's story, who's only wish is to get back his friend, no matter\n" +
        "what it takes.";
    }
    override function load(resources:Resources) {
        var atlas:JoinAtlas=new JoinAtlas(1024,1024);
        atlas.add(new FontLoader(Assets.fonts.Kenney_PixelName,30));
        resources.add(atlas);
    }

    override function init() {
        var messageDisplay=new Text(Assets.fonts.Kenney_PixelName);
        messageDisplay.text=message;
        messageDisplay.x=50;
        messageDisplay.y=100;
        messageDisplay.color=Color.White;
        stage.addChild(messageDisplay);

        var startPlaying=new Text(Assets.fonts.Kenney_PixelName);
        startPlaying.text="Press enter to play";
        startPlaying.x=GEngine.virtualWidth/2-startPlaying.width()*0.5;
        startPlaying.y=GEngine.virtualHeight - 100;
        startPlaying.color=Color.Green;
        stage.addChild(startPlaying);
    }
    override function update(dt:Float) {
        super.update(dt);
        if(Input.i.isKeyCodePressed(KeyCode.Return)){
            changeState(new GameState()); 
        }
    }
}