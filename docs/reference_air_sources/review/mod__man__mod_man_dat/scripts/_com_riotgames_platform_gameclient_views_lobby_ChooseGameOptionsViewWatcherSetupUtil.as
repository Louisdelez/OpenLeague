package
{
   import com.riotgames.platform.gameclient.views.lobby.ChooseGameOptionsView;
   import com.riotgames.pvpnet.system.config.UserPreferencesManager;
   import flash.display.Sprite;
   import mx.binding.IWatcherSetupUtil;
   import mx.binding.PropertyWatcher;
   import mx.binding.StaticPropertyWatcher;
   import mx.core.IFlexModuleFactory;
   
   public class _com_riotgames_platform_gameclient_views_lobby_ChooseGameOptionsViewWatcherSetupUtil extends Sprite implements IWatcherSetupUtil
   {
      
      public function _com_riotgames_platform_gameclient_views_lobby_ChooseGameOptionsViewWatcherSetupUtil()
      {
         super();
      }
      
      public static function init(param1:IFlexModuleFactory) : void
      {
         ChooseGameOptionsView.watcherSetupUtil = new _com_riotgames_platform_gameclient_views_lobby_ChooseGameOptionsViewWatcherSetupUtil();
      }
      
      public function setup(param1:Object, param2:Function, param3:Array, param4:Array) : void
      {
         param4[26] = new PropertyWatcher("soloVisible",{"propertyChange":true},[param3[25],param3[27],param3[28]],param2);
         param4[22] = new PropertyWatcher("optionsListContainer",{"propertyChange":true},[param3[21]],param2);
         param4[23] = new PropertyWatcher("height",{"heightChanged":true},[param3[21]],null);
         param4[25] = new PropertyWatcher("currentState",{"currentStateChange":true},[param3[32],param3[23],param3[24],param3[31],param3[30]],param2);
         param4[17] = new PropertyWatcher("primaryListsList2_title",{"propertyChange":true},[param3[16]],param2);
         param4[18] = new PropertyWatcher("text",{"valueCommit":true},[param3[16]],null);
         param4[6] = new PropertyWatcher("primaryListsList0_title",{"propertyChange":true},[param3[4]],param2);
         param4[7] = new PropertyWatcher("text",{"valueCommit":true},[param3[4]],null);
         param4[11] = new PropertyWatcher("list0Data",{"propertyChange":true},[param3[8]],param2);
         param4[14] = new PropertyWatcher("primaryListsListOptions1",{"propertyChange":true},[param3[11]],param2);
         param4[15] = new PropertyWatcher("visible",{
            "hide":true,
            "show":true
         },[param3[11]],null);
         param4[19] = new PropertyWatcher("primaryListsListOptions2",{"propertyChange":true},[param3[17]],param2);
         param4[20] = new PropertyWatcher("visible",{
            "hide":true,
            "show":true
         },[param3[17]],null);
         param4[5] = new PropertyWatcher("fadeIn_and_glow_unglow_blue",{"propertyChange":true},[param3[3],param3[9],param3[15]],param2);
         param4[16] = new PropertyWatcher("list1Data",{"propertyChange":true},[param3[14]],param2);
         param4[27] = new PropertyWatcher("soloAvailable",{"propertyChange":true},[param3[26]],param2);
         param4[10] = new PropertyWatcher("fadeIn",{"propertyChange":true},[param3[18],param3[6],param3[12]],param2);
         param4[28] = new PropertyWatcher("partyAvailable",{"propertyChange":true},[param3[29]],param2);
         param4[8] = new PropertyWatcher("primaryListsListOptions0",{"propertyChange":true},[param3[5]],param2);
         param4[9] = new PropertyWatcher("visible",{
            "hide":true,
            "show":true
         },[param3[5]],null);
         param4[21] = new PropertyWatcher("list2Data",{"propertyChange":true},[param3[20]],param2);
         param4[12] = new PropertyWatcher("primaryListsList1_title",{"propertyChange":true},[param3[10]],param2);
         param4[13] = new PropertyWatcher("text",{"valueCommit":true},[param3[10]],null);
         param4[3] = new StaticPropertyWatcher("globalPrefs",null,[param3[18],param3[3],param3[6],param3[9],param3[12],param3[15]],null);
         param4[4] = new PropertyWatcher("enableAnimations",{"propertyChange":true},[param3[18],param3[3],param3[6],param3[9],param3[12],param3[15]],null);
         param4[26].updateParent(param1);
         param4[22].updateParent(param1);
         param4[22].addChild(param4[23]);
         param4[25].updateParent(param1);
         param4[17].updateParent(param1);
         param4[17].addChild(param4[18]);
         param4[6].updateParent(param1);
         param4[6].addChild(param4[7]);
         param4[11].updateParent(param1);
         param4[14].updateParent(param1);
         param4[14].addChild(param4[15]);
         param4[19].updateParent(param1);
         param4[19].addChild(param4[20]);
         param4[5].updateParent(param1);
         param4[16].updateParent(param1);
         param4[27].updateParent(param1);
         param4[10].updateParent(param1);
         param4[28].updateParent(param1);
         param4[8].updateParent(param1);
         param4[8].addChild(param4[9]);
         param4[21].updateParent(param1);
         param4[12].updateParent(param1);
         param4[12].addChild(param4[13]);
         param4[3].updateParent(UserPreferencesManager);
         param4[3].addChild(param4[4]);
      }
   }
}

