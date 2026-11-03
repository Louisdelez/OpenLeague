package com.riotgames.pvpnet.game.controllers.contextalert
{
   import com.riotgames.platform.common.provider.ChromeContextAlertProviderProxy;
   import com.riotgames.platform.common.provider.IChromeContextAlertProvider;
   import com.riotgames.platform.common.provider.IInventory;
   import com.riotgames.platform.common.utils.RiotResourceLoader;
   import com.riotgames.platform.gameclient.contextAlert.AlertLocation;
   import com.riotgames.platform.gameclient.contextAlert.AlertParameters;
   import com.riotgames.platform.gameclient.domain.Spell;
   import com.riotgames.platform.gameclient.domain.game.GameQueueConfig;
   import com.riotgames.platform.gameclient.domain.inventory.ActiveBoosts;
   import com.riotgames.pvpnet.game.variants.GameFlowVariant;
   import com.riotgames.pvpnet.game.variants.GameFlowVariantFactory;
   import mx.collections.ArrayCollection;
   import mx.resources.ResourceManager;
   
   public class EndOfGameAlertParser
   {
      
      private static const MESSAGE_SEPARATOR:String = "<br />";
      
      private var chromeContextAlertController:IChromeContextAlertProvider;
      
      private var inventory:IInventory;
      
      private var rewardsParams:AlertParameters;
      
      private var _offsetX:Number = 0;
      
      private var _offsetY:Number = 0;
      
      public function EndOfGameAlertParser(param1:IChromeContextAlertProvider, param2:IInventory)
      {
         super();
         this.chromeContextAlertController = param1;
         this.inventory = param2;
      }
      
      public function runEndOfGameScript(param1:int, param2:Boolean, param3:ArrayCollection, param4:ActiveBoosts, param5:ArrayCollection, param6:int) : void
      {
         var _loc8_:Vector.<String> = null;
         var _loc11_:ArrayCollection = null;
         var _loc12_:GameFlowVariant = null;
         var _loc13_:GameQueueConfig = null;
         var _loc14_:Spell = null;
         var _loc7_:Vector.<String> = new Vector.<String>();
         var _loc9_:Boolean = true;
         var _loc10_:Boolean = false;
         if(param2)
         {
            if(param6 > 0 && _loc9_)
            {
               _loc7_.push(RiotResourceLoader.getString("rp_reward_alert_message","You have been granted RP!",[param1,param6]));
            }
            if(this.inventory.freeToPlayChampionForNewPlayerMaxLevel > 0 && param1 - 1 == this.inventory.freeToPlayChampionForNewPlayerMaxLevel)
            {
               _loc7_.push(RiotResourceLoader.getString("switch_new_to_free_champion_rotation_alert_message"));
               _loc9_ = false;
            }
            if(Boolean(param5) && param5.length > 0)
            {
               _loc8_ = new Vector.<String>();
               _loc11_ = new ArrayCollection();
               _loc12_ = GameFlowVariantFactory.instance.getVariant(_loc13_.gameMutators,_loc13_.gameMode);
               for each(_loc13_ in param5)
               {
                  if(!_loc11_.contains(_loc13_.gameMode) && _loc12_.showsEndOfGameLevelUpAlertForUnlockedGameMode())
                  {
                     _loc8_.push(RiotResourceLoader.getString("levelup_alert_newQueue_" + _loc13_.gameMode));
                     _loc11_.addItem(_loc13_.gameMode);
                  }
               }
               _loc7_.push(_loc8_.join(MESSAGE_SEPARATOR));
            }
            _loc8_ = new Vector.<String>();
            if(_loc7_.length > 0)
            {
               _loc8_.push(RiotResourceLoader.getString("levelup_alert_message_also","You\'ve also unlocked"));
            }
            else
            {
               _loc8_.push(RiotResourceLoader.getString("levelup_alert_message","You\'ve unlocked"));
            }
            _loc8_.push(RiotResourceLoader.getString("levelup_alert_newRune"));
            _loc8_.push(RiotResourceLoader.getString("levelup_alert_newMastery"));
            if(Boolean(param3) && param3.length > 0)
            {
               for each(_loc14_ in param3)
               {
                  _loc8_.push(ResourceManager.getInstance().getString("resources","levelup_alert_newSpell",[_loc14_.displayName]));
               }
            }
            _loc7_.push(_loc8_.join(MESSAGE_SEPARATOR));
            if(param1 === 5)
            {
               _loc10_ = true;
            }
         }
         if(_loc7_.length > 0)
         {
            this.rewardsParams = new AlertParameters();
            this.rewardsParams.requiresThickChromeState = false;
            this.rewardsParams.location = AlertLocation.EOG_REWARDS_INFO;
            if(param2)
            {
               this.rewardsParams.title = RiotResourceLoader.getString("levelup_alert_title",null,[param1]);
            }
            else
            {
               this.rewardsParams.title = RiotResourceLoader.getString("eog_rewards_title_nolevel");
            }
            this.rewardsParams.message = _loc7_.join(MESSAGE_SEPARATOR + MESSAGE_SEPARATOR);
            this.chromeContextAlertController.showAlertForParameters(this.rewardsParams);
         }
         else
         {
            this.rewardsParams = null;
         }
         if(_loc10_)
         {
            this.showChatMinimumLvMetAlert();
         }
         this.chromeContextAlertController.runExpiredBoostScript(param4);
      }
      
      public function showRewardsAlert() : void
      {
         if(this.hasRewards())
         {
            ChromeContextAlertProviderProxy.instance.showAlertForParameters(this.rewardsParams);
         }
      }
      
      public function hasRewards() : Boolean
      {
         return this.rewardsParams !== null;
      }
      
      public function removeAlert() : void
      {
         if(this.hasRewards())
         {
            ChromeContextAlertProviderProxy.instance.removeAlert(this.rewardsParams);
         }
      }
      
      private function showChatMinimumLvMetAlert() : void
      {
         var _loc1_:AlertParameters = new AlertParameters();
         _loc1_.location = AlertLocation.CHAT_ROOMS_BUTTON;
         _loc1_.title = null;
         _loc1_.message = RiotResourceLoader.getString("global_chat_enabled_alert_message");
         this.chromeContextAlertController.showAlertForParameters(_loc1_);
      }
   }
}

