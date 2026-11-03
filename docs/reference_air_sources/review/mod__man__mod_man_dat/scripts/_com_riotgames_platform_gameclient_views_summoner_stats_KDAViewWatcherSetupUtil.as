package
{
   import com.riotgames.platform.common.ImagePackLookup;
   import com.riotgames.platform.gameclient.views.summoner.stats.KDAView;
   import flash.display.Sprite;
   import mx.binding.IWatcherSetupUtil;
   import mx.binding.PropertyWatcher;
   import mx.binding.StaticPropertyWatcher;
   import mx.core.IFlexModuleFactory;
   
   public class _com_riotgames_platform_gameclient_views_summoner_stats_KDAViewWatcherSetupUtil extends Sprite implements IWatcherSetupUtil
   {
      
      public function _com_riotgames_platform_gameclient_views_summoner_stats_KDAViewWatcherSetupUtil()
      {
         super();
      }
      
      public static function init(param1:IFlexModuleFactory) : void
      {
         KDAView.watcherSetupUtil = new _com_riotgames_platform_gameclient_views_summoner_stats_KDAViewWatcherSetupUtil();
      }
      
      public function setup(param1:Object, param2:Function, param3:Array, param4:Array) : void
      {
         param4[7] = new PropertyWatcher("formatter",{"propertyChange":true},[param3[17],param3[7],param3[12]],param2);
         param4[3] = new PropertyWatcher("kdaImageSize",{"propertyChange":true},[param3[3],param3[4],param3[9],param3[10],param3[14],param3[15]],param2);
         param4[17] = new PropertyWatcher("assists",{"propertyChange":true},[param3[17]],param2);
         param4[2] = new PropertyWatcher("precision",{"propertyChange":true},[param3[2]],param2);
         param4[13] = new PropertyWatcher("deaths",{"propertyChange":true},[param3[12]],param2);
         param4[4] = new StaticPropertyWatcher("instance",null,[param3[5],param3[8],param3[13]],null);
         param4[9] = new PropertyWatcher("kills",{"propertyChange":true},[param3[7]],param2);
         param4[7].updateParent(param1);
         param4[3].updateParent(param1);
         param4[17].updateParent(param1);
         param4[2].updateParent(param1);
         param4[13].updateParent(param1);
         param4[4].updateParent(ImagePackLookup);
         param4[9].updateParent(param1);
      }
   }
}

