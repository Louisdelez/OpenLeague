package
{
   import com.riotgames.platform.gameclient.views.profile.ProfileView;
   import flash.display.Sprite;
   import mx.binding.IWatcherSetupUtil;
   import mx.binding.PropertyWatcher;
   import mx.core.IFlexModuleFactory;
   
   public class _com_riotgames_platform_gameclient_views_profile_ProfileViewWatcherSetupUtil extends Sprite implements IWatcherSetupUtil
   {
      
      public function _com_riotgames_platform_gameclient_views_profile_ProfileViewWatcherSetupUtil()
      {
         super();
      }
      
      public static function init(param1:IFlexModuleFactory) : void
      {
         ProfileView.watcherSetupUtil = new _com_riotgames_platform_gameclient_views_profile_ProfileViewWatcherSetupUtil();
      }
      
      public function setup(param1:Object, param2:Function, param3:Array, param4:Array) : void
      {
         param4[0] = new PropertyWatcher("summonerProfileController",{"propertyChange":true},[param3[0],param3[1],param3[2]],param2);
         param4[5] = new PropertyWatcher("displayPromotionalGames",{"propertyChange":true},[param3[2]],null);
         param4[3] = new PropertyWatcher("promotionalGamesPlayed",{"propertyChange":true},[param3[1]],null);
         param4[1] = new PropertyWatcher("summonerName",{"propertyChange":true},[param3[0]],null);
         param4[4] = new PropertyWatcher("isLocalSummoner",{"propertyChange":true},[param3[2]],null);
         param4[0].updateParent(param1);
         param4[0].addChild(param4[5]);
         param4[0].addChild(param4[3]);
         param4[0].addChild(param4[1]);
         param4[0].addChild(param4[4]);
      }
   }
}

