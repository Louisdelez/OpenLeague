package
{
   import com.riotgames.platform.common.ImagePackLookup;
   import com.riotgames.platform.gameclient.controllers.game.views.ChampionSummaryView;
   import flash.display.Sprite;
   import mx.binding.IWatcherSetupUtil;
   import mx.binding.PropertyWatcher;
   import mx.binding.StaticPropertyWatcher;
   import mx.core.IFlexModuleFactory;
   
   [Mixin]
   [ExcludeClass]
   public class _com_riotgames_platform_gameclient_controllers_game_views_ChampionSummaryViewWatcherSetupUtil extends Sprite implements IWatcherSetupUtil
   {
      
      public function _com_riotgames_platform_gameclient_controllers_game_views_ChampionSummaryViewWatcherSetupUtil()
      {
         super();
      }
      
      public static function init(param1:IFlexModuleFactory) : void
      {
         ChampionSummaryView.watcherSetupUtil = new _com_riotgames_platform_gameclient_controllers_game_views_ChampionSummaryViewWatcherSetupUtil();
      }
      
      public function setup(param1:Object, param2:Function, param3:Array, param4:Array) : void
      {
         param4[8] = new PropertyWatcher("separator_img",{"propertyChange":true},[param3[5]],param2);
         param4[10] = new PropertyWatcher("height",{"heightChanged":true},[param3[5]],null);
         param4[9] = new PropertyWatcher("y",{"yChanged":true},[param3[5]],null);
         param4[5] = new PropertyWatcher("championIdInfo_hb",{"propertyChange":true},[param3[4]],param2);
         param4[7] = new PropertyWatcher("height",{"heightChanged":true},[param3[4]],null);
         param4[6] = new PropertyWatcher("y",{"yChanged":true},[param3[4]],null);
         param4[11] = new PropertyWatcher("abilities",{"propertyChange":true},[param3[6]],param2);
         param4[2] = new PropertyWatcher("description",{"propertyChange":true},[param3[2]],param2);
         param4[3] = new StaticPropertyWatcher("instance",null,[param3[3]],null);
         param4[0] = new PropertyWatcher("fadeEffect",{"propertyChange":true},[param3[0]],param2);
         param4[1] = new PropertyWatcher("championName",{"propertyChange":true},[param3[1]],param2);
         param4[8].updateParent(param1);
         param4[8].addChild(param4[10]);
         param4[8].addChild(param4[9]);
         param4[5].updateParent(param1);
         param4[5].addChild(param4[7]);
         param4[5].addChild(param4[6]);
         param4[11].updateParent(param1);
         param4[2].updateParent(param1);
         param4[3].updateParent(ImagePackLookup);
         param4[0].updateParent(param1);
         param4[1].updateParent(param1);
      }
   }
}

