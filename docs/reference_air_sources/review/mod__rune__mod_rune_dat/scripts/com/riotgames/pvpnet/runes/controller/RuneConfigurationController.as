package com.riotgames.pvpnet.runes.controller
{
   import com.riotgames.pvpnet.system.config.cdc.testing.SplitTestingConfigController;
   import com.riotgames.pvpnet.tracking.trackers.runes.IRunesTracker;
   import flash.utils.Dictionary;
   import flash.utils.getQualifiedClassName;
   import mx.logging.ILogger;
   import mx.logging.Log;
   
   public class RuneConfigurationController extends SplitTestingConfigController
   {
      
      public static const IRON_LEFT_SIDE_UX_STYLE:String = "ironLeft";
      
      public static const IRON_DEFAULT_UX_STYLE:String = "ironDefault";
      
      public static const LEGACY_UX_STYLE:String = "legacy";
      
      private var _runesViewLinkageDict:Dictionary;
      
      private var _itemEffectRendererLinkageDict:Dictionary;
      
      private var _activeStyle:String;
      
      private var _runesTracker:IRunesTracker;
      
      private var logger:ILogger = Log.getLogger(getQualifiedClassName(this).replace(/::/,"."));
      
      public function RuneConfigurationController(param1:IRunesTracker)
      {
         super("Runes");
         this._runesViewLinkageDict = new Dictionary();
         this._runesViewLinkageDict[LEGACY_UX_STYLE] = "RunesView";
         this._runesViewLinkageDict[IRON_DEFAULT_UX_STYLE] = "IronRunesView";
         this._runesViewLinkageDict[IRON_LEFT_SIDE_UX_STYLE] = "IronLeftSideRunesView";
         this._itemEffectRendererLinkageDict = new Dictionary();
         this._itemEffectRendererLinkageDict[LEGACY_UX_STYLE] = "ItemEffectRenderer";
         this._itemEffectRendererLinkageDict[IRON_DEFAULT_UX_STYLE] = "IronItemEffectRenderer";
         this._itemEffectRendererLinkageDict[IRON_LEFT_SIDE_UX_STYLE] = "IronItemEffectRenderer";
         this._runesTracker = param1;
      }
      
      public function lookupUXConfiguration() : void
      {
         super.init();
         this._activeStyle = getSettingByKey("overallStyle",LEGACY_UX_STYLE);
         this._runesTracker.setOverallStyle(this._activeStyle);
      }
      
      public function isIronStyle() : Boolean
      {
         return this._activeStyle == IRON_LEFT_SIDE_UX_STYLE || this._activeStyle == IRON_DEFAULT_UX_STYLE;
      }
      
      public function isLegacyStyle() : Boolean
      {
         return this._activeStyle == LEGACY_UX_STYLE;
      }
      
      public function getItemEffectLinkage() : String
      {
         return this._itemEffectRendererLinkageDict[this._activeStyle];
      }
      
      public function getRunesViewLinkage() : String
      {
         return this._runesViewLinkageDict[this._activeStyle];
      }
   }
}

