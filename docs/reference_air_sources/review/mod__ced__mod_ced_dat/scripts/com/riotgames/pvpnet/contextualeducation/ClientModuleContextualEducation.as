package com.riotgames.pvpnet.contextualeducation
{
   import blix.action.IAction;
   import blix.action.SequenceAction;
   import blix.assets.proxy.SpriteProxy;
   import com.riotgames.platform.common.utils.RiotResourceLoader;
   import com.riotgames.platform.gameclient.domain.EndOfGameStats;
   import com.riotgames.platform.gameclient.domain.PlayerParticipantStatsSummary;
   import com.riotgames.platform.gameclient.domain.PlayerStat;
   import com.riotgames.platform.gameclient.domain.RawStatType;
   import com.riotgames.platform.provider.IProviderModule;
   import com.riotgames.platform.provider.ProviderLookup;
   import com.riotgames.platform.provider.ProviderModuleInfo;
   import com.riotgames.pvpnet.contextualeducation.model.ContextualEducationTipModel;
   import com.riotgames.pvpnet.contextualeducation.services.ContextualEducationServiceManager;
   import com.riotgames.pvpnet.contextualeducation.services.ContextualEducationTipRecord;
   import com.riotgames.pvpnet.contextualeducation.services.IContextualEducationService;
   import com.riotgames.pvpnet.contextualeducation.views.ContextualEducationView;
   import com.riotgames.pvpnet.system.config.ClientConfig;
   import com.riotgames.pvpnet.system.config.actions.UserPreferencesLoadedAction;
   import com.riotgames.pvpnet.system.config.cdc.DynamicClientConfigManager;
   import com.riotgames.pvpnet.system.localization.action.LoadModuleResourceBundleAction;
   import com.riotgames.pvpnet.tracking.Dradis;
   import flash.display.Sprite;
   import flash.utils.Dictionary;
   import mx.collections.ArrayCollection;
   import mx.resources.ResourceManager;
   import mx.utils.StringUtil;
   
   [SWF(width="500", height="375", backgroundColor="#869ca7", frameRate="24")]
   public class ClientModuleContextualEducation extends Sprite implements IProviderModule, IContextualEducationProvider
   {
      
      public static const BUNDLE_ID:String = "ContextualEducation";
      
      public static const SHORT_NAME:String = "ced";
      
      public static const NULL_URL:String = "null";
      
      private static const MAX_TIMES_PER_TIP:uint = 2;
      
      private var _storedTempStatistics:ArrayCollection = null;
      
      private var _records:Dictionary = null;
      
      private var _initSequence:SequenceAction;
      
      private const _preferenceManager:IContextualEducationService = new ContextualEducationServiceManager();
      
      private var _moduleInfo:ProviderModuleInfo;
      
      private var _contextualEducationScreen:ContextualEducationView;
      
      private var _tipModel:ContextualEducationTipModel = new ContextualEducationTipModel();
      
      public function ClientModuleContextualEducation()
      {
         super();
      }
      
      public static function moduleLocalize(param1:String, param2:Array = null) : String
      {
         return RiotResourceLoader.getResourceString(BUNDLE_ID,param1,"**" + param1,param2);
      }
      
      private function getRecordsTimesShown(param1:String) : Number
      {
         var _loc2_:ContextualEducationTipRecord = null;
         if(param1 in this._records)
         {
            _loc2_ = this._records[param1] as ContextualEducationTipRecord;
            return _loc2_.timesAttemptedTip;
         }
         return 0;
      }
      
      private function stat(param1:String) : Number
      {
         var _loc2_:PlayerStat = PlayerStat.findStat(param1,this._storedTempStatistics);
         if(_loc2_ == null)
         {
            return NaN;
         }
         return _loc2_.value;
      }
      
      public function prepareTip(param1:PlayerParticipantStatsSummary, param2:Boolean, param3:EndOfGameStats) : Boolean
      {
         var _loc8_:Number = NaN;
         var _loc14_:Boolean = false;
         var _loc15_:String = null;
         var _loc16_:String = null;
         var _loc17_:String = null;
         var _loc18_:ClientConfig = null;
         var _loc19_:String = null;
         var _loc4_:Boolean = false;
         this._storedTempStatistics = param1.statistics;
         var _loc5_:Boolean = param1.userId % 2 === 1;
         var _loc6_:uint = this.stat(RawStatType.MINIONS_KILLED);
         var _loc7_:uint = this.stat(RawStatType.NEUTRAL_MINIONS_KILLED);
         _loc8_ = Number(DynamicClientConfigManager.getConfiguration("ContextualEducation","TargetMinionsPerWave",1).getNumber());
         var _loc9_:Number = _loc8_ * ((param3.gameLength / 60 - 2) * 2);
         var _loc10_:uint = uint(DynamicClientConfigManager.getConfiguration("ContextualEducation","MaxTargetSummonerLevel",10).getNumber());
         var _loc11_:uint = 1;
         var _loc12_:String = "";
         var _loc13_:String = "";
         if(param1.level >= _loc11_ && param1.level <= _loc10_)
         {
            if(_loc6_ < _loc9_)
            {
               _loc12_ = "LAST_HIT";
               _loc14_ = this.shouldGiveTipBasedOnRecords(_loc12_);
               if(_loc5_ && _loc14_)
               {
                  _loc13_ = "LAST_HIT_A";
                  _loc15_ = DynamicClientConfigManager.getConfiguration("ContextualEducationURLs",_loc12_,NULL_URL).getString();
                  _loc16_ = "TipBody_" + _loc12_;
                  _loc17_ = "";
                  if(_loc15_ === null || _loc15_.toLowerCase() === NULL_URL)
                  {
                     _loc16_ += "__NO_URL";
                  }
                  else
                  {
                     _loc18_ = ClientConfig.instance;
                     _loc19_ = "archer=message_type:player_ed__eog__pass_to_site;id:" + param1.userId;
                     _loc17_ = StringUtil.substitute(_loc15_,[_loc18_.regionTag,_loc18_.locale,_loc18_.localePrefix,_loc19_]);
                  }
                  this._tipModel.setHeaderAndBody(moduleLocalize("TipHeader_DidYouKnow"),moduleLocalize(_loc16_,[_loc17_]));
                  _loc4_ = true;
               }
            }
         }
         Dradis.track("contextual_education__eog_tip",{
            "game_stats.is_victorious":param2,
            "game_stats.lane_minions_killed":_loc6_,
            "game_stats.neutral_minions_killed":_loc7_,
            "game_stats.game_time":param3.gameLength,
            "game_stats.target_minion_kills":_loc9_,
            "contextual_tip.is_in_target_group":_loc12_,
            "contextual_tip.shown_tip":_loc13_
         });
         this._storedTempStatistics = null;
         return _loc4_;
      }
      
      private function shouldGiveTipBasedOnRecords(param1:String) : Boolean
      {
         var _loc3_:ContextualEducationTipRecord = null;
         var _loc2_:Boolean = true;
         if(param1 in this._records)
         {
            _loc3_ = this._records[param1] as ContextualEducationTipRecord;
            ++_loc3_.timesAttemptedTip;
            if(_loc3_.timesAttemptedTip > MAX_TIMES_PER_TIP)
            {
               _loc2_ = false;
            }
         }
         else
         {
            this._records[param1] = new ContextualEducationTipRecord(param1);
         }
         this._preferenceManager.saveRecords(this._records);
         return _loc2_;
      }
      
      public function getContextualEducationDisplay() : SpriteProxy
      {
         if(!this._contextualEducationScreen)
         {
            this._contextualEducationScreen = new ContextualEducationView(this._moduleInfo,this._tipModel);
         }
         return this._contextualEducationScreen;
      }
      
      public function initializeModule(param1:ProviderModuleInfo) : void
      {
         this._initSequence = new SequenceAction();
         this._moduleInfo = param1;
         this._initSequence.and(this.getLoadLocalizedResources());
         this._initSequence.and(new UserPreferencesLoadedAction());
         this._initSequence.getCompleted().addOnce(this.onInitComplete);
         this._initSequence.invoke();
      }
      
      private function onInitComplete() : void
      {
         this._records = this._preferenceManager.getRecords();
         ProviderLookup.publishProvider(IContextualEducationProvider,this);
      }
      
      private function getLoadLocalizedResources() : IAction
      {
         return new LoadModuleResourceBundleAction(ResourceManager.getInstance(),ClientConfig.instance.locale,BUNDLE_ID,BUNDLE_ID,SHORT_NAME,ClientConfig.instance.debugLocale);
      }
   }
}

