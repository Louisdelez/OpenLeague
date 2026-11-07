package
{
   import com.riotgames.platform.gameclient.skin.ButtonSkin;
   import flash.display.Sprite;
   import mx.binding.IWatcherSetupUtil;
   import mx.binding.PropertyWatcher;
   import mx.core.IFlexModuleFactory;
   
   [Mixin]
   [ExcludeClass]
   public class _com_riotgames_platform_gameclient_skin_ButtonSkinWatcherSetupUtil extends Sprite implements IWatcherSetupUtil
   {
      
      public function _com_riotgames_platform_gameclient_skin_ButtonSkinWatcherSetupUtil()
      {
         super();
      }
      
      public static function init(param1:IFlexModuleFactory) : void
      {
         ButtonSkin.watcherSetupUtil = new _com_riotgames_platform_gameclient_skin_ButtonSkinWatcherSetupUtil();
      }
      
      public function setup(param1:Object, param2:Function, param3:Array, param4:Array) : void
      {
         param4[1] = new PropertyWatcher("textShadow",{"propertyChange":true},[param3[1]],param2);
         param4[2] = new PropertyWatcher("bevelDown",{"propertyChange":true},[param3[3]],param2);
         param4[0] = new PropertyWatcher("textField",{"propertyChange":true},[param3[0],param3[6],param3[8]],param2);
         param4[4] = new PropertyWatcher("bevel",{"propertyChange":true},[param3[10]],param2);
         param4[3] = new PropertyWatcher("glow",{"propertyChange":true},[param3[4],param3[7],param3[9]],param2);
         param4[1].updateParent(param1);
         param4[2].updateParent(param1);
         param4[0].updateParent(param1);
         param4[4].updateParent(param1);
         param4[3].updateParent(param1);
      }
   }
}

