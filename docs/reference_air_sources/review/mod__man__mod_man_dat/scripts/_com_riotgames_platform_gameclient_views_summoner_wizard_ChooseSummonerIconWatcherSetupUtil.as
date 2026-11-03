package
{
   import com.riotgames.platform.common.ImagePackLookup;
   import com.riotgames.platform.gameclient.views.summoner.wizard.ChooseSummonerIcon;
   import flash.display.Sprite;
   import mx.binding.FunctionReturnWatcher;
   import mx.binding.IWatcherSetupUtil;
   import mx.binding.PropertyWatcher;
   import mx.binding.StaticPropertyWatcher;
   import mx.core.IFlexModuleFactory;
   
   public class _com_riotgames_platform_gameclient_views_summoner_wizard_ChooseSummonerIconWatcherSetupUtil extends Sprite implements IWatcherSetupUtil
   {
      
      public function _com_riotgames_platform_gameclient_views_summoner_wizard_ChooseSummonerIconWatcherSetupUtil()
      {
         super();
      }
      
      public static function init(param1:IFlexModuleFactory) : void
      {
         ChooseSummonerIcon.watcherSetupUtil = new _com_riotgames_platform_gameclient_views_summoner_wizard_ChooseSummonerIconWatcherSetupUtil();
      }
      
      public function setup(param1:Object, param2:Function, param3:Array, param4:Array) : void
      {
         var target:Object = param1;
         var propertyGetter:Function = param2;
         var bindings:Array = param3;
         var watchers:Array = param4;
         watchers[8] = new PropertyWatcher("resourceManager",{"unused":true},[bindings[10],bindings[12],bindings[13],bindings[14]],propertyGetter);
         watchers[9] = new FunctionReturnWatcher("getString",target,function():Array
         {
            return ["resources","summonerProfile_chooseIcon"];
         },{"change":true},[bindings[10]],null);
         watchers[11] = new FunctionReturnWatcher("getString",target,function():Array
         {
            return ["resources","summonerProfile_chooseIconInstructions"];
         },{"change":true},[bindings[12]],null);
         watchers[12] = new FunctionReturnWatcher("getString",target,function():Array
         {
            return ["resources","common_button_cancel"];
         },{"change":true},[bindings[13]],null);
         watchers[13] = new FunctionReturnWatcher("getString",target,function():Array
         {
            return ["resources","common_button_ok"];
         },{"change":true},[bindings[14]],null);
         watchers[2] = new PropertyWatcher("iconHolder",{"propertyChange":true},[bindings[3],bindings[7]],propertyGetter);
         watchers[6] = new StaticPropertyWatcher("instance",null,[bindings[9],bindings[11]],null);
         watchers[3] = new PropertyWatcher("userIconList",{"propertyChange":true},[bindings[5]],propertyGetter);
         watchers[8].updateParent(target);
         watchers[9].parentWatcher = watchers[8];
         watchers[8].addChild(watchers[9]);
         watchers[11].parentWatcher = watchers[8];
         watchers[8].addChild(watchers[11]);
         watchers[12].parentWatcher = watchers[8];
         watchers[8].addChild(watchers[12]);
         watchers[13].parentWatcher = watchers[8];
         watchers[8].addChild(watchers[13]);
         watchers[2].updateParent(target);
         watchers[6].updateParent(ImagePackLookup);
         watchers[3].updateParent(target);
      }
   }
}

