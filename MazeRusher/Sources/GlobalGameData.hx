import com.gEngine.display.Camera;
import com.gEngine.display.Layer;
import gameObjects.William;

typedef GGD = GlobalGameData; 
class GlobalGameData {

    public static var player:William;
    public static var simulationLayer:Layer;
    public static var attackLayer:Layer;
    public static var camera:Camera;
    public static var lives:Int = 3;
    public static var unlockedSwapparang:Bool = false;
    public static var unlockedBagpipe:Bool = false;
    public static var stunDuration:Int = 2;
    public static var bagpipeCoolDown:Float = 0;
    public static var swapparangCoolDown:Float = 0;
    public static var bossDefeated:Bool = false;

    public static function destroy() {
        player=null;
        simulationLayer=null;
        attackLayer=null;
        camera=null;
        lives = 3;
        bagpipeCoolDown = 0;
        swapparangCoolDown = 0;
        unlockedBagpipe = false;
        unlockedSwapparang = false;
        bossDefeated=false;
    }
}