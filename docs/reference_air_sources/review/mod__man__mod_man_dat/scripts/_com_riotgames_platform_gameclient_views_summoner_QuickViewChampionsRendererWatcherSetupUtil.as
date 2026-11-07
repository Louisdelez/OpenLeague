package
{
   import com.riotgames.platform.gameclient.views.summoner.QuickViewChampionsRenderer;
   import flash.display.Sprite;
   import mx.binding.IWatcherSetupUtil;
   import mx.binding.PropertyWatcher;
   import mx.core.IFlexModuleFactory;
   
   public class _com_riotgames_platform_gameclient_views_summoner_QuickViewChampionsRendererWatcherSetupUtil extends Sprite implements IWatcherSetupUtil
   {
      
      public function _com_riotgames_platform_gameclient_views_summoner_QuickViewChampionsRendererWatcherSetupUtil()
      {
         super();
      }
      
      public static function init(param1:IFlexModuleFactory) : void
      {
         QuickViewChampionsRenderer.watcherSetupUtil = new _com_riotgames_platform_gameclient_views_summoner_QuickViewChampionsRendererWatcherSetupUtil();
      }
      
      public function setup(param1:Object, param2:Function, param3:Array, param4:Array) : void
      {
         param4[0] = new PropertyWatcher("height",{"heightChanged":true},[param3[0]],param2);
         param4[2] = new PropertyWatcher("data",{"dataChange":true},[param3[1],param3[2]],param2);
         param4[3] = new PropertyWatcher("champion",null,[param3[1],param3[2]],null);
         param4[4] = new PropertyWatcher("skinName",null,[param3[1]],null);
         param4[5] = new PropertyWatcher("displayName",null,[param3[2]],null);
         param4[0].updateParent(param1);
         param4[2].updateParent(param1);
         param4[2].addChild(param4[3]);
         param4[3].addChild(param4[4]);
         param4[3].addChild(param4[5]);
      }
   }
}

