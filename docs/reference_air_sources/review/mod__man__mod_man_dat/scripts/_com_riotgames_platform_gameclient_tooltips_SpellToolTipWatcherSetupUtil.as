package
{
   import com.riotgames.platform.gameclient.tooltips.SpellToolTip;
   import flash.display.Sprite;
   import mx.binding.FunctionReturnWatcher;
   import mx.binding.IWatcherSetupUtil;
   import mx.binding.PropertyWatcher;
   import mx.core.IFlexModuleFactory;
   
   public class _com_riotgames_platform_gameclient_tooltips_SpellToolTipWatcherSetupUtil extends Sprite implements IWatcherSetupUtil
   {
      
      public function _com_riotgames_platform_gameclient_tooltips_SpellToolTipWatcherSetupUtil()
      {
         super();
      }
      
      public static function init(param1:IFlexModuleFactory) : void
      {
         SpellToolTip.watcherSetupUtil = new _com_riotgames_platform_gameclient_tooltips_SpellToolTipWatcherSetupUtil();
      }
      
      public function setup(param1:Object, param2:Function, param3:Array, param4:Array) : void
      {
         var target:Object = param1;
         var propertyGetter:Function = param2;
         var bindings:Array = param3;
         var watchers:Array = param4;
         watchers[6] = new PropertyWatcher("resourceManager",{"unused":true},[bindings[2]],propertyGetter);
         watchers[7] = new FunctionReturnWatcher("getString",target,function():Array
         {
            return ["resources","talentTree_requirements_summonerLevel",[target.dataSpell.minLevel]];
         },{"change":true},[bindings[2]],null);
         watchers[8] = new PropertyWatcher("minLevel",null,[bindings[2]],propertyGetter);
         watchers[3] = new PropertyWatcher("spellName",{"propertyChange":true},[bindings[1]],propertyGetter);
         watchers[5] = new PropertyWatcher("height",{"heightChanged":true},[bindings[1]],null);
         watchers[4] = new PropertyWatcher("y",{"yChanged":true},[bindings[1]],null);
         watchers[2] = new PropertyWatcher("name",null,[bindings[0],bindings[4]],propertyGetter);
         watchers[9] = new PropertyWatcher("spellRequirement",{"propertyChange":true},[bindings[3]],propertyGetter);
         watchers[11] = new PropertyWatcher("height",{"heightChanged":true},[bindings[3]],null);
         watchers[10] = new PropertyWatcher("y",{"yChanged":true},[bindings[3]],null);
         watchers[1] = new PropertyWatcher("data",{"dataChange":true},[bindings[0],bindings[2],bindings[4]],propertyGetter);
         watchers[6].updateParent(target);
         watchers[7].parentWatcher = watchers[6];
         watchers[6].addChild(watchers[7]);
         watchers[8].updateParent(target);
         watchers[3].updateParent(target);
         watchers[3].addChild(watchers[5]);
         watchers[3].addChild(watchers[4]);
         watchers[2].updateParent(target);
         watchers[9].updateParent(target);
         watchers[9].addChild(watchers[11]);
         watchers[9].addChild(watchers[10]);
         watchers[1].updateParent(target);
      }
   }
}

