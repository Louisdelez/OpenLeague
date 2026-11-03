package
{
   import com.riotgames.platform.common.ImagePackLookup;
   import com.riotgames.platform.gameclient.controllers.game.views.itemRenderers.ChampionAbilityItemRenderer;
   import flash.display.Sprite;
   import mx.binding.IWatcherSetupUtil;
   import mx.binding.PropertyWatcher;
   import mx.binding.StaticPropertyWatcher;
   import mx.core.IFlexModuleFactory;
   
   [Mixin]
   [ExcludeClass]
   public class _com_riotgames_platform_gameclient_controllers_game_views_itemRenderers_ChampionAbilityItemRendererWatcherSetupUtil extends Sprite implements IWatcherSetupUtil
   {
      
      public function _com_riotgames_platform_gameclient_controllers_game_views_itemRenderers_ChampionAbilityItemRendererWatcherSetupUtil()
      {
         super();
      }
      
      public static function init(param1:IFlexModuleFactory) : void
      {
         ChampionAbilityItemRenderer.watcherSetupUtil = new _com_riotgames_platform_gameclient_controllers_game_views_itemRenderers_ChampionAbilityItemRendererWatcherSetupUtil();
      }
      
      public function setup(param1:Object, param2:Function, param3:Array, param4:Array) : void
      {
         param4[8] = new PropertyWatcher("separator_img",{"propertyChange":true},[param3[4],param3[5]],param2);
         param4[11] = new PropertyWatcher("height",{"heightChanged":true},[param3[5]],null);
         param4[10] = new PropertyWatcher("y",{"yChanged":true},[param3[5]],null);
         param4[9] = new PropertyWatcher("x",{"xChanged":true},[param3[4]],null);
         param4[3] = new PropertyWatcher("ability_img",{"propertyChange":true},[param3[2]],param2);
         param4[5] = new PropertyWatcher("width",{"widthChanged":true},[param3[2]],null);
         param4[4] = new PropertyWatcher("x",{"xChanged":true},[param3[2]],null);
         param4[0] = new PropertyWatcher("data",{"dataChange":true},[param3[0],param3[1],param3[6]],param2);
         param4[12] = new PropertyWatcher("description",null,[param3[6]],null);
         param4[2] = new PropertyWatcher("iconSource",null,[param3[1]],null);
         param4[1] = new PropertyWatcher("name",null,[param3[0]],null);
         param4[6] = new StaticPropertyWatcher("instance",null,[param3[3]],null);
         param4[8].updateParent(param1);
         param4[8].addChild(param4[11]);
         param4[8].addChild(param4[10]);
         param4[8].addChild(param4[9]);
         param4[3].updateParent(param1);
         param4[3].addChild(param4[5]);
         param4[3].addChild(param4[4]);
         param4[0].updateParent(param1);
         param4[0].addChild(param4[12]);
         param4[0].addChild(param4[2]);
         param4[0].addChild(param4[1]);
         param4[6].updateParent(ImagePackLookup);
      }
   }
}

