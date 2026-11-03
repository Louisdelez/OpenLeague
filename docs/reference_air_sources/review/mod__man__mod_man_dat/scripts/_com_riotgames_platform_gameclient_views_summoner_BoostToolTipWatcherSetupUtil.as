package
{
   import com.riotgames.platform.gameclient.views.summoner.BoostToolTip;
   import flash.display.Sprite;
   import mx.binding.FunctionReturnWatcher;
   import mx.binding.IWatcherSetupUtil;
   import mx.binding.PropertyWatcher;
   import mx.core.IFlexModuleFactory;
   
   public class _com_riotgames_platform_gameclient_views_summoner_BoostToolTipWatcherSetupUtil extends Sprite implements IWatcherSetupUtil
   {
      
      public function _com_riotgames_platform_gameclient_views_summoner_BoostToolTipWatcherSetupUtil()
      {
         super();
      }
      
      public static function init(param1:IFlexModuleFactory) : void
      {
         BoostToolTip.watcherSetupUtil = new _com_riotgames_platform_gameclient_views_summoner_BoostToolTipWatcherSetupUtil();
      }
      
      public function setup(param1:Object, param2:Function, param3:Array, param4:Array) : void
      {
         var target:Object = param1;
         var propertyGetter:Function = param2;
         var bindings:Array = param3;
         var watchers:Array = param4;
         watchers[1] = new PropertyWatcher("titleText",{"propertyChange":true},[bindings[1]],propertyGetter);
         watchers[2] = new PropertyWatcher("resourceManager",{"unused":true},[bindings[2],bindings[4]],propertyGetter);
         watchers[3] = new FunctionReturnWatcher("getString",target,function():Array
         {
            return ["resources","summonerProfile_info_perWiBoostsSubTitle_tooltip"];
         },{"change":true},[bindings[2]],null);
         watchers[5] = new FunctionReturnWatcher("getString",target,function():Array
         {
            return ["resources","summonerProfile_info_timeeBasedBoostsSubTitle_tooltip"];
         },{"change":true},[bindings[4]],null);
         watchers[4] = new PropertyWatcher("boostPerWinCount",{"propertyChange":true},[bindings[3]],propertyGetter);
         watchers[6] = new PropertyWatcher("displayEndDate",{"propertyChange":true},[bindings[5]],propertyGetter);
         watchers[0] = new PropertyWatcher("width",{"widthChanged":true},[bindings[0]],propertyGetter);
         watchers[1].updateParent(target);
         watchers[2].updateParent(target);
         watchers[3].parentWatcher = watchers[2];
         watchers[2].addChild(watchers[3]);
         watchers[5].parentWatcher = watchers[2];
         watchers[2].addChild(watchers[5]);
         watchers[4].updateParent(target);
         watchers[6].updateParent(target);
         watchers[0].updateParent(target);
      }
   }
}

