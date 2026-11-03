package
{
   import com.riotgames.platform.common.ImagePackLookup;
   import com.riotgames.platform.gameclient.views.game.common.endofgame.SpellItemRenderer;
   import flash.display.Sprite;
   import mx.binding.IWatcherSetupUtil;
   import mx.binding.PropertyWatcher;
   import mx.binding.StaticPropertyWatcher;
   import mx.core.IFlexModuleFactory;
   
   public class _com_riotgames_platform_gameclient_views_game_common_endofgame_SpellItemRendererWatcherSetupUtil extends Sprite implements IWatcherSetupUtil
   {
      
      public function _com_riotgames_platform_gameclient_views_game_common_endofgame_SpellItemRendererWatcherSetupUtil()
      {
         super();
      }
      
      public static function init(param1:IFlexModuleFactory) : void
      {
         SpellItemRenderer.watcherSetupUtil = new _com_riotgames_platform_gameclient_views_game_common_endofgame_SpellItemRendererWatcherSetupUtil();
      }
      
      public function setup(param1:Object, param2:Function, param3:Array, param4:Array) : void
      {
         param4[3] = new PropertyWatcher("width",{"widthChanged":true},[param3[1]],param2);
         param4[2] = new PropertyWatcher("data",{"dataChange":true},[param3[0]],param2);
         param4[0] = new StaticPropertyWatcher("instance",null,[param3[0]],null);
         param4[4] = new PropertyWatcher("spellImg",{"propertyChange":true},[param3[2]],param2);
         param4[5] = new PropertyWatcher("width",{"widthChanged":true},[param3[2]],null);
         param4[3].updateParent(param1);
         param4[2].updateParent(param1);
         param4[0].updateParent(ImagePackLookup);
         param4[4].updateParent(param1);
         param4[4].addChild(param4[5]);
      }
   }
}

