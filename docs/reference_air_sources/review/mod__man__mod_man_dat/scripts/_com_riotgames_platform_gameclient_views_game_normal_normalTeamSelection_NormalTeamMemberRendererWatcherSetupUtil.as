package
{
   import com.riotgames.platform.common.ImagePackLookup;
   import com.riotgames.platform.gameclient.views.game.normal.normalTeamSelection.NormalTeamMemberRenderer;
   import flash.display.Sprite;
   import mx.binding.IWatcherSetupUtil;
   import mx.binding.PropertyWatcher;
   import mx.binding.StaticPropertyWatcher;
   import mx.core.IFlexModuleFactory;
   
   public class _com_riotgames_platform_gameclient_views_game_normal_normalTeamSelection_NormalTeamMemberRendererWatcherSetupUtil extends Sprite implements IWatcherSetupUtil
   {
      
      public function _com_riotgames_platform_gameclient_views_game_normal_normalTeamSelection_NormalTeamMemberRendererWatcherSetupUtil()
      {
         super();
      }
      
      public static function init(param1:IFlexModuleFactory) : void
      {
         NormalTeamMemberRenderer.watcherSetupUtil = new _com_riotgames_platform_gameclient_views_game_normal_normalTeamSelection_NormalTeamMemberRendererWatcherSetupUtil();
      }
      
      public function setup(param1:Object, param2:Function, param3:Array, param4:Array) : void
      {
         param4[21] = new PropertyWatcher("canPassInvitePrivileges",{"propertyChange":true},[param3[38],param3[39]],param2);
         param4[14] = new PropertyWatcher("kickBanActive",{"propertyChange":true},[param3[19],param3[18]],param2);
         param4[1] = new StaticPropertyWatcher("instance",null,[param3[1]],null);
         param4[16] = new PropertyWatcher("isCurrentSummonerMe",{"propertyChange":true},[param3[23],param3[24]],param2);
         param4[7] = new PropertyWatcher("canDelegate",{"propertyChange":true},[param3[34],param3[33],param3[10]],param2);
         param4[9] = new PropertyWatcher("gameOwner_img",{"propertyChange":true},[param3[12]],param2);
         param4[10] = new PropertyWatcher("visible",{
            "hide":true,
            "show":true
         },[param3[12]],null);
         param4[12] = new PropertyWatcher("width",{"widthChanged":true},[param3[12]],null);
         param4[11] = new PropertyWatcher("x",{"xChanged":true},[param3[12]],null);
         param4[18] = new PropertyWatcher("isCurrentSummonerFriend",{"propertyChange":true},[param3[29],param3[28]],param2);
         param4[0] = new PropertyWatcher("summonerData",{"propertyChange":true},[param3[0]],param2);
         param4[5] = new PropertyWatcher("isCurrentSummonerOwner",{"propertyChange":true},[param3[5]],param2);
         param4[21].updateParent(param1);
         param4[14].updateParent(param1);
         param4[1].updateParent(ImagePackLookup);
         param4[16].updateParent(param1);
         param4[7].updateParent(param1);
         param4[9].updateParent(param1);
         param4[9].addChild(param4[10]);
         param4[9].addChild(param4[12]);
         param4[9].addChild(param4[11]);
         param4[18].updateParent(param1);
         param4[0].updateParent(param1);
         param4[5].updateParent(param1);
      }
   }
}

