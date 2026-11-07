package
{
   import com.riotgames.platform.gameclient.components.summoner.SummonerIcon;
   import flash.display.Sprite;
   import mx.binding.IWatcherSetupUtil;
   import mx.binding.PropertyWatcher;
   import mx.core.IFlexModuleFactory;
   
   [Mixin]
   [ExcludeClass]
   public class _com_riotgames_platform_gameclient_components_summoner_SummonerIconWatcherSetupUtil extends Sprite implements IWatcherSetupUtil
   {
      
      public function _com_riotgames_platform_gameclient_components_summoner_SummonerIconWatcherSetupUtil()
      {
         super();
      }
      
      public static function init(param1:IFlexModuleFactory) : void
      {
         SummonerIcon.watcherSetupUtil = new _com_riotgames_platform_gameclient_components_summoner_SummonerIconWatcherSetupUtil();
      }
      
      public function setup(param1:Object, param2:Function, param3:Array, param4:Array) : void
      {
         param4[1] = new PropertyWatcher("height",{"heightChanged":true},[param3[0]],param2);
         param4[4] = new PropertyWatcher("_iconSource",{"propertyChange":true},[param3[2]],param2);
         param4[3] = new PropertyWatcher("width",{"widthChanged":true},[param3[1]],param2);
         param4[1].updateParent(param1);
         param4[4].updateParent(param1);
         param4[3].updateParent(param1);
      }
   }
}

