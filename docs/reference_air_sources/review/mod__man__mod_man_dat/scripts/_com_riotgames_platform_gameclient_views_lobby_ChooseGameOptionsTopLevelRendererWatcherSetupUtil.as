package
{
   import com.riotgames.platform.gameclient.views.lobby.ChooseGameOptionsTopLevelRenderer;
   import flash.display.Sprite;
   import mx.binding.IWatcherSetupUtil;
   import mx.core.IFlexModuleFactory;
   
   public class _com_riotgames_platform_gameclient_views_lobby_ChooseGameOptionsTopLevelRendererWatcherSetupUtil extends Sprite implements IWatcherSetupUtil
   {
      
      public function _com_riotgames_platform_gameclient_views_lobby_ChooseGameOptionsTopLevelRendererWatcherSetupUtil()
      {
         super();
      }
      
      public static function init(param1:IFlexModuleFactory) : void
      {
         ChooseGameOptionsTopLevelRenderer.watcherSetupUtil = new _com_riotgames_platform_gameclient_views_lobby_ChooseGameOptionsTopLevelRendererWatcherSetupUtil();
      }
      
      public function setup(param1:Object, param2:Function, param3:Array, param4:Array) : void
      {
      }
   }
}

