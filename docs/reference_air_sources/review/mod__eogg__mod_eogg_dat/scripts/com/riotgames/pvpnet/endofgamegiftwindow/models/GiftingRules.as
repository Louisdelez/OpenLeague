package com.riotgames.pvpnet.endofgamegiftwindow.models
{
   import blix.signals.ISignal;
   import blix.signals.Signal;
   import com.riotgames.pvpnet.endofgamegiftwindow.models.player.IPlayerSummary;
   import com.riotgames.pvpnet.endofgamegiftwindow.models.player.ISessionPlayer;
   import com.riotgames.pvpnet.system.config.cdc.DynamicClientConfigManager;
   
   public class GiftingRules implements IGiftingRules
   {
      
      private static const CONFIG_NAMESPACE:String = "EndOfGameGiftSettings";
      
      private static const SETTING_NAME_SESSION_LEVEL_MIN:String = "GiftSenderLevelMin";
      
      private static const SETTING_DEFAULT_SESSION_LEVEL_MIN:Number = 15;
      
      private static const SETTING_NAME_SESSION_RP_MAX:String = "GiftSenderRPMax";
      
      private static const SETTING_DEFAULT_SESSION_RP_MAX:Number = 50000;
      
      private static const SETTING_NAME_SESSION_SEND_MAX:String = "SenderGiftDailyMax";
      
      private static const SETTING_DEFAULT_SESSION_SEND_MAX:Number = 5;
      
      private static const SETTING_NAME_RECIPIENT_LEVEL_MIN:String = "GiftRecipientLevelMin";
      
      private static const SETTING_DEFAULT_RECIPIENT_LEVEL_MIN:Number = 5;
      
      private static const SETTING_NAME_RECIPIENT_RECEIVE_MAX:String = "RecipientGiftDailyMax";
      
      private static const SETTING_DEFAULT_RECIPIENT_RECEIVE_MAX:Number = 5;
      
      private static const FAIL_REASON_RP_MAX:String = "RP_max";
      
      private static const FAIL_REASON_LEVEL_MIN:String = "level_min";
      
      private static const FAIL_REASON_GIFT_LIMIT_SELF:String = "gift_limit_reached";
      
      private static const FAIL_REASON_RECIPIENT_LEVEL_MIN:String = "recipient_min";
      
      private static const FAIL_REASON_RECIPIENT_GIFT_LIMIT:String = "recipient_limit";
      
      private var _sessionPlayerLevelMin:Number;
      
      private var _sessionPlayerLevelMinChange:Signal;
      
      private var _sessionPlayerRPMax:Number;
      
      private var _sessionPlayerRPMaxChange:Signal;
      
      private var _sessionPlayerGiftSendDailyMax:Number;
      
      private var _sessionPlayerGiftSendDailyMaxChange:Signal;
      
      private var _giftRecipientLevelMin:Number;
      
      private var _giftRecipientLevelMinChange:Signal;
      
      private var _giftRecipientGiftDailyMax:Number;
      
      private var _giftRecipientGiftDailyMaxChange:Signal;
      
      private var _rulesInitialized:Signal;
      
      private var _failReason:String;
      
      public function GiftingRules()
      {
         super();
         this._failReason = "";
         this._sessionPlayerLevelMinChange = new Signal();
         this._sessionPlayerRPMaxChange = new Signal();
         this._sessionPlayerGiftSendDailyMaxChange = new Signal();
         this._giftRecipientLevelMinChange = new Signal();
         this._giftRecipientGiftDailyMaxChange = new Signal();
         this._rulesInitialized = new Signal();
         this._sessionPlayerLevelMin = DynamicClientConfigManager.getConfiguration(CONFIG_NAMESPACE,SETTING_NAME_SESSION_LEVEL_MIN,SETTING_DEFAULT_SESSION_LEVEL_MIN,this.onConfigChangeSessionPlayerLevelMin).getNumber();
         this._sessionPlayerRPMax = DynamicClientConfigManager.getConfiguration(CONFIG_NAMESPACE,SETTING_NAME_SESSION_RP_MAX,SETTING_DEFAULT_SESSION_RP_MAX,this.onConfigChangeSessionPlayerRPMax).getNumber();
         this._sessionPlayerGiftSendDailyMax = DynamicClientConfigManager.getConfiguration(CONFIG_NAMESPACE,SETTING_NAME_SESSION_SEND_MAX,SETTING_DEFAULT_SESSION_SEND_MAX,this.onConfigChangeSessionPlayerSendMax).getNumber();
         this._giftRecipientLevelMin = DynamicClientConfigManager.getConfiguration(CONFIG_NAMESPACE,SETTING_NAME_RECIPIENT_LEVEL_MIN,SETTING_DEFAULT_RECIPIENT_LEVEL_MIN,this.onConfigChangeRecipientLevelMin).getNumber();
         this._giftRecipientGiftDailyMax = DynamicClientConfigManager.getConfiguration(CONFIG_NAMESPACE,SETTING_NAME_RECIPIENT_RECEIVE_MAX,SETTING_DEFAULT_RECIPIENT_RECEIVE_MAX,this.onConfigChangeRecipientDailyMax).getNumber();
         this._rulesInitialized.dispatch();
      }
      
      public function lastFailReason() : String
      {
         return this._failReason;
      }
      
      public function playerCanSendGifts(param1:ISessionPlayer) : Boolean
      {
         return this.playerMeetsMinLevelRequirement(param1.playerLevel) && this.playerMeetsGiftSendLimit(param1.giftsSentThisSession) && this.playerMeetsRPMaxLimit(param1.rp);
      }
      
      public function recipientCanReceiveGift(param1:IPlayerSummary) : Boolean
      {
         return this.recipientMeetsLevelMin(param1.playerLevel);
      }
      
      public function playerCanGiftRecipient(param1:ISessionPlayer, param2:IPlayerSummary) : Boolean
      {
         return this.playerCanSendGifts(param1) && this.recipientCanReceiveGift(param2);
      }
      
      public function rulesInitialized() : ISignal
      {
         return this._rulesInitialized;
      }
      
      public function sessionPlayerLevelMinChange() : ISignal
      {
         return this._sessionPlayerLevelMinChange;
      }
      
      public function sessionPlayerRPMaxChange() : ISignal
      {
         return this._sessionPlayerRPMaxChange;
      }
      
      public function sessionPlayerDailySendMaxChange() : ISignal
      {
         return this._sessionPlayerGiftSendDailyMaxChange;
      }
      
      public function recipientLevelMinChange() : ISignal
      {
         return this._giftRecipientLevelMinChange;
      }
      
      public function recipientDailyReceiveMaxChange() : ISignal
      {
         return this._giftRecipientGiftDailyMaxChange;
      }
      
      public function get sessionPLayerLevelMin() : Number
      {
         return this._sessionPlayerLevelMin || SETTING_DEFAULT_SESSION_LEVEL_MIN;
      }
      
      public function get sessionPlayerRPMax() : Number
      {
         return this._sessionPlayerRPMax || SETTING_DEFAULT_SESSION_RP_MAX;
      }
      
      public function get sessionPlayerDailyMax() : Number
      {
         return this._sessionPlayerGiftSendDailyMax || SETTING_DEFAULT_SESSION_SEND_MAX;
      }
      
      public function get recipientLevelMin() : Number
      {
         return this._giftRecipientLevelMin || SETTING_DEFAULT_RECIPIENT_LEVEL_MIN;
      }
      
      public function get recipientDailyReceiveMax() : Number
      {
         return this._giftRecipientGiftDailyMax || SETTING_DEFAULT_RECIPIENT_RECEIVE_MAX;
      }
      
      private function playerMeetsMinLevelRequirement(param1:Number) : Boolean
      {
         if(param1 >= this._sessionPlayerLevelMin)
         {
            return true;
         }
         this._failReason = FAIL_REASON_LEVEL_MIN;
         return false;
      }
      
      private function playerMeetsGiftSendLimit(param1:Number) : Boolean
      {
         if(param1 < this._sessionPlayerGiftSendDailyMax)
         {
            return true;
         }
         this._failReason = FAIL_REASON_GIFT_LIMIT_SELF;
         return false;
      }
      
      private function playerMeetsRPMaxLimit(param1:Number) : Boolean
      {
         if(param1 < this._sessionPlayerRPMax)
         {
            return true;
         }
         this._failReason = FAIL_REASON_RP_MAX;
         return false;
      }
      
      private function recipientMeetsLevelMin(param1:Number) : Boolean
      {
         if(param1 >= this._giftRecipientLevelMin)
         {
            return true;
         }
         this._failReason = FAIL_REASON_RECIPIENT_LEVEL_MIN;
         return false;
      }
      
      private function onConfigChangeSessionPlayerLevelMin() : void
      {
         this._sessionPlayerLevelMin = DynamicClientConfigManager.getConfiguration(CONFIG_NAMESPACE,SETTING_NAME_SESSION_LEVEL_MIN,SETTING_DEFAULT_SESSION_LEVEL_MIN).getNumber();
         this._sessionPlayerLevelMinChange.dispatch(this._sessionPlayerLevelMin);
      }
      
      private function onConfigChangeSessionPlayerRPMax() : void
      {
         this._sessionPlayerRPMax = DynamicClientConfigManager.getConfiguration(CONFIG_NAMESPACE,SETTING_NAME_SESSION_RP_MAX,SETTING_DEFAULT_SESSION_RP_MAX).getNumber();
         this._sessionPlayerRPMaxChange.dispatch(this._sessionPlayerRPMax);
      }
      
      private function onConfigChangeSessionPlayerSendMax() : void
      {
         this._sessionPlayerGiftSendDailyMax = DynamicClientConfigManager.getConfiguration(CONFIG_NAMESPACE,SETTING_NAME_SESSION_SEND_MAX,SETTING_DEFAULT_SESSION_SEND_MAX).getNumber();
         this._sessionPlayerGiftSendDailyMaxChange.dispatch(this._sessionPlayerGiftSendDailyMax);
      }
      
      private function onConfigChangeRecipientLevelMin() : void
      {
         this._giftRecipientLevelMin = DynamicClientConfigManager.getConfiguration(CONFIG_NAMESPACE,SETTING_NAME_RECIPIENT_LEVEL_MIN,SETTING_DEFAULT_RECIPIENT_LEVEL_MIN).getNumber();
         this._giftRecipientLevelMinChange.dispatch(this._giftRecipientLevelMin);
      }
      
      private function onConfigChangeRecipientDailyMax() : void
      {
         this._giftRecipientGiftDailyMax = DynamicClientConfigManager.getConfiguration(CONFIG_NAMESPACE,SETTING_NAME_RECIPIENT_RECEIVE_MAX,SETTING_DEFAULT_RECIPIENT_RECEIVE_MAX).getNumber();
         this._giftRecipientGiftDailyMaxChange.dispatch(this._giftRecipientGiftDailyMax);
      }
   }
}

