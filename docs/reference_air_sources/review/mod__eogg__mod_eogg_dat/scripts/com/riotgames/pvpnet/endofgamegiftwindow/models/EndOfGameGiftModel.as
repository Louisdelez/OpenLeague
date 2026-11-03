package com.riotgames.pvpnet.endofgamegiftwindow.models
{
   import blix.IDestructible;
   import blix.signals.ISignal;
   import blix.signals.Signal;
   import com.riotgames.pvpnet.endofgamegiftwindow.enums.GiftCategories;
   import com.riotgames.pvpnet.endofgamegiftwindow.models.dto.LoadGiftsRequestDTO;
   import com.riotgames.pvpnet.endofgamegiftwindow.models.dto.SendGiftRequestDTO;
   import com.riotgames.pvpnet.endofgamegiftwindow.models.gift.AvailableGiftCategory;
   import com.riotgames.pvpnet.endofgamegiftwindow.models.gift.CustomMessageConfigData;
   import com.riotgames.pvpnet.endofgamegiftwindow.models.gift.EndOfGameGiftDetailData;
   import com.riotgames.pvpnet.endofgamegiftwindow.models.gift.GiftCompleteDetailData;
   import com.riotgames.pvpnet.endofgamegiftwindow.models.gift.GiftErrorData;
   import com.riotgames.pvpnet.endofgamegiftwindow.models.gift.GiftMessageDropDownData;
   import com.riotgames.pvpnet.endofgamegiftwindow.models.gift.GiftMessageDropDownItemData;
   import com.riotgames.pvpnet.endofgamegiftwindow.models.gift.IEndOfGameGift;
   import com.riotgames.pvpnet.endofgamegiftwindow.models.gift.IEndOfGameGiftDetailData;
   import com.riotgames.pvpnet.endofgamegiftwindow.models.player.IPlayerSummary;
   import com.riotgames.pvpnet.endofgamegiftwindow.models.player.ISessionPlayer;
   import com.riotgames.pvpnet.endofgamegiftwindow.services.EndOfGameGiftServiceResponseTypes;
   import com.riotgames.pvpnet.endofgamegiftwindow.utils.EndOfGameGiftLocaleUtil;
   import flash.utils.Dictionary;
   
   public class EndOfGameGiftModel implements IEndOfGameGiftModel, IDestructible
   {
      
      private static var MESSAGE_PROPERTY_NAME:String = "itemLabel";
      
      private static const DEFAULT_TEXT_COLOR:Number = 16711680;
      
      private static const TEXT_COLOR:Number = 16776960;
      
      private static const BORDER_COLOR:Number = 16711680;
      
      private static const BACKGROUND_COLOR:Number = 3342336;
      
      private var _giftingRules:IGiftingRules;
      
      private var _playerRoster:Dictionary;
      
      private var _giftedRoster:Dictionary;
      
      private var _sessionPlayer:ISessionPlayer;
      
      private var _giftRecipient:IPlayerSummary;
      
      private var _giftDetailTitle:String;
      
      private var _salutationString:String;
      
      private var _currencyName:String;
      
      private var _customMessageConfigData:CustomMessageConfigData;
      
      private var _detailButtonLabel:String;
      
      private var _giftDropDownData:GiftMessageDropDownData;
      
      private var _selectedGift:IEndOfGameGift;
      
      private var _isGiftSelected:Boolean;
      
      private var _giftDetailData:IEndOfGameGiftDetailData;
      
      private var _selectedGiftMessageData:Object;
      
      private var _giftList:Vector.<AvailableGiftCategory>;
      
      private var _giftSendCompleteData:GiftCompleteDetailData;
      
      private var _giftErrorData:GiftErrorData;
      
      private var _sentGift:IEndOfGameGift;
      
      private var _giftListUpdated:Signal;
      
      private var _giftRecipientUpdated:Signal;
      
      private var _selectedGiftUpdated:Signal;
      
      private var _selectedMessageUpdated:Signal;
      
      private var _unlockPayloadReady:Signal;
      
      private var _serviceErrorReceived:Signal;
      
      private var _giftSentSuccess:Signal;
      
      private var _windowLabel:String;
      
      private var _nextButtonLabel:String;
      
      private var _backButtonLabel:String;
      
      public function EndOfGameGiftModel(param1:ISessionPlayer, param2:IGiftingRules)
      {
         super();
         this._isGiftSelected = false;
         this._giftListUpdated = new Signal();
         this._giftRecipientUpdated = new Signal();
         this._selectedGiftUpdated = new Signal();
         this._selectedMessageUpdated = new Signal();
         this._unlockPayloadReady = new Signal();
         this._serviceErrorReceived = new Signal();
         this._giftSentSuccess = new Signal();
         this._giftingRules = param2;
         this._playerRoster = new Dictionary();
         this._giftedRoster = new Dictionary();
         this._sessionPlayer = param1;
         this._windowLabel = this.fetchWindowLabel();
         this._nextButtonLabel = this.fetchNextButtonLabel();
         this._backButtonLabel = this.fetchBackButtonLabel();
         this._salutationString = this.fetchSalutationText();
         this._currencyName = this.fetchCurrencyDisplayName();
         this._customMessageConfigData = this.fetchCustomMessageConfigData();
         this._detailButtonLabel = this.fetchDetailViewButtonLabel();
         this._giftDropDownData = this.constructGiftDropDownData();
      }
      
      public function sessionPlayerCanGift() : Boolean
      {
         return this._giftingRules.playerCanSendGifts(this._sessionPlayer);
      }
      
      public function getPlayerGiftable(param1:IPlayerSummary) : Boolean
      {
         if(this._giftedRoster.hasOwnProperty(param1.summonerID.toString()))
         {
            return false;
         }
         if(!this._playerRoster.hasOwnProperty(param1.summonerID.toString()))
         {
            this.addPlayerToGiftRoster(param1);
         }
         return this._playerRoster[param1.summonerID.toString()];
      }
      
      public function getGiftButtonToolTip(param1:IPlayerSummary) : String
      {
         var _loc2_:String = null;
         if(!this.getPlayerGiftable(param1))
         {
            _loc2_ = "eogg_button_tooltip_disabled_";
            if(this._giftedRoster.hasOwnProperty(param1.summonerID.toString()))
            {
               _loc2_ += "gift_sent";
            }
            else
            {
               _loc2_ += this._giftingRules.lastFailReason();
            }
            return EndOfGameGiftLocaleUtil.getResourceString(_loc2_,"Gifting Disabled");
         }
         return EndOfGameGiftLocaleUtil.getResourceString("eogg_button_tooltip_enabled_message","Send Gift");
      }
      
      public function getGiftWindowTitleString() : String
      {
         return this._windowLabel;
      }
      
      public function getNextButtonLabel() : String
      {
         return this._nextButtonLabel;
      }
      
      public function getBackButtonLabel() : String
      {
         return this._backButtonLabel;
      }
      
      public function getBucketLabel(param1:String) : String
      {
         var _loc2_:String = null;
         switch(param1)
         {
            case GiftCategories.CHAMPIONS:
               _loc2_ = EndOfGameGiftLocaleUtil.getResourceString("eogg_gift_list_group_name_champion","CHAMPIONS");
               break;
            case GiftCategories.SKINS:
               _loc2_ = EndOfGameGiftLocaleUtil.getResourceString("eogg_gift_list_group_name_skin","SKINS");
               break;
            case GiftCategories.MYSTERY_CHAMPION:
               _loc2_ = EndOfGameGiftLocaleUtil.getResourceString("eogg_gift_list_group_name_mystery_champion","MYSTERY CHAMPION");
               break;
            case GiftCategories.MYSTERY_SKIN:
               _loc2_ = EndOfGameGiftLocaleUtil.getResourceString("eogg_gift_list_group_name_mystery_skin","MYSTERY SKIN");
               break;
            case GiftCategories.RECOMMENDED:
            default:
               _loc2_ = EndOfGameGiftLocaleUtil.getResourceString("eogg_gift_list_group_name_recommended","RECOMMENDED");
         }
         return _loc2_;
      }
      
      public function updateGiftRecipient(param1:IPlayerSummary) : void
      {
         this._giftRecipient = param1;
         var _loc2_:String = this._giftRecipient.summonerName + "\'s gift";
         this._giftDetailTitle = EndOfGameGiftLocaleUtil.getResourceString("eogg_gift_detail_recipient_suffix",_loc2_);
         this._giftRecipientUpdated.dispatch(this._giftRecipient,this.formulateLoadGiftsPayload());
      }
      
      public function updateGiftList(param1:Vector.<AvailableGiftCategory>) : void
      {
         this._giftList = null;
         this._giftList = param1;
         this._giftListUpdated.dispatch(this._giftList);
      }
      
      public function changeGiftSelection(param1:IEndOfGameGift) : void
      {
         if(param1 != this._selectedGift)
         {
            this._selectedGift = param1;
            this._giftDetailData = this.constructGiftSelectionDetailData();
            this._selectedGiftUpdated.dispatch(this._giftDetailData);
         }
      }
      
      public function updateGiftSelected() : void
      {
         this._isGiftSelected = true;
         this._windowLabel = this.fetchWindowLabel();
      }
      
      public function revertGiftSelected() : void
      {
         this._isGiftSelected = false;
         this._windowLabel = this.fetchWindowLabel();
      }
      
      public function changeMessageSelection(param1:Object) : void
      {
         var _loc2_:String = null;
         if(param1.hasOwnProperty(MESSAGE_PROPERTY_NAME))
         {
            _loc2_ = param1[MESSAGE_PROPERTY_NAME];
            if(_loc2_ != this.formulateSelectedMessage())
            {
               this._selectedGiftMessageData = param1;
               this._giftDetailData = this.constructGiftSelectionDetailData();
               this._selectedMessageUpdated.dispatch(this.formulateSelectedMessage(),this.fetchRecipientSignature());
            }
         }
      }
      
      public function getUnlockGiftPayload() : SendGiftRequestDTO
      {
         return this.formulateSendGiftRequestPayload();
      }
      
      public function setEOGGServiceError(param1:Number, param2:String) : void
      {
         this._giftSentSuccess.removeAll();
         this._giftErrorData = this.constructErrorData(param1,param2);
         this._giftSendCompleteData = new GiftCompleteDetailData(this._giftDetailData,this._giftErrorData);
         this._serviceErrorReceived.dispatch(this._giftSendCompleteData);
      }
      
      public function updateGiftSentSuccess(param1:IEndOfGameGift) : void
      {
         this.setRecipientUngiftable();
         this._serviceErrorReceived.removeAll();
         this._selectedGift = param1;
         this._giftDetailData = this.constructGiftCompleteDetailData(false);
         this._giftSendCompleteData = new GiftCompleteDetailData(this._giftDetailData);
         this._giftSentSuccess.dispatch(this._giftSendCompleteData);
      }
      
      public function resetGiftingSessionData() : void
      {
         var _loc1_:String = null;
         this._giftListUpdated.removeAll();
         this._giftRecipientUpdated.removeAll();
         this._selectedGiftUpdated.removeAll();
         this._selectedMessageUpdated.removeAll();
         this._unlockPayloadReady.removeAll();
         this._serviceErrorReceived.removeAll();
         this._giftSentSuccess.removeAll();
         for each(_loc1_ in this._playerRoster)
         {
            delete this._playerRoster[_loc1_];
         }
         for each(_loc1_ in this._giftedRoster)
         {
            delete this._giftedRoster[_loc1_];
         }
         this._playerRoster = new Dictionary();
         this._giftedRoster = new Dictionary();
      }
      
      public function getGiftListUpdated() : ISignal
      {
         return this._giftListUpdated;
      }
      
      public function getGiftRecipientUpdate() : ISignal
      {
         return this._giftRecipientUpdated;
      }
      
      public function getSelectedGiftUpdated() : ISignal
      {
         return this._selectedGiftUpdated;
      }
      
      public function getSelectedMessageUpdate() : ISignal
      {
         return this._selectedMessageUpdated;
      }
      
      public function getUnlockGiftPayloadReady() : ISignal
      {
         return this._unlockPayloadReady;
      }
      
      public function getServiceErrorReceived() : ISignal
      {
         return this._serviceErrorReceived;
      }
      
      public function getGiftSentSuccess() : ISignal
      {
         return this._giftSentSuccess;
      }
      
      public function destroy() : void
      {
         this._sessionPlayer = null;
         this._giftRecipient = null;
         this._giftDetailTitle = null;
         this._salutationString = null;
         this._currencyName = null;
         this._customMessageConfigData = null;
         this._detailButtonLabel = null;
         this._giftDropDownData = null;
         this._selectedGift = null;
         this._giftDetailData = null;
         this._selectedGiftMessageData = null;
         this._giftList = null;
         this._giftSendCompleteData = null;
         this._giftErrorData = null;
         this._sentGift = null;
         this.resetGiftingSessionData();
         this._giftListUpdated = null;
         this._giftRecipientUpdated = null;
         this._selectedGiftUpdated = null;
         this._selectedMessageUpdated = null;
         this._unlockPayloadReady = null;
         this._serviceErrorReceived = null;
         this._giftSentSuccess = null;
      }
      
      private function addPlayerToGiftRoster(param1:IPlayerSummary) : void
      {
         this._playerRoster[param1.summonerID.toString()] = this._giftingRules.recipientCanReceiveGift(param1);
      }
      
      private function movePlayerToGiftedRoster(param1:IPlayerSummary) : void
      {
         delete this._playerRoster[param1.summonerID.toString()];
         this._giftedRoster[param1.summonerID.toString()] = false;
      }
      
      private function setRecipientUngiftable() : void
      {
         if(this._playerRoster.hasOwnProperty(this._giftRecipient.summonerID.toString()))
         {
            this.movePlayerToGiftedRoster(this._giftRecipient);
         }
      }
      
      private function formulateLoadGiftsPayload() : LoadGiftsRequestDTO
      {
         return new LoadGiftsRequestDTO(this._sessionPlayer.summonerID,this._giftRecipient.summonerID,this._giftRecipient.gameID,this._giftRecipient.queueType,this._sessionPlayer.localeString);
      }
      
      private function formulateSendGiftRequestPayload() : SendGiftRequestDTO
      {
         return new SendGiftRequestDTO(this._sessionPlayer.accountID,this._sessionPlayer.summonerID,this._giftRecipient.summonerID,this.formulateSelectedMessage(),this._giftRecipient.queueType,this._giftRecipient.gameID,this._selectedGift);
      }
      
      private function constructGiftSelectionDetailData() : IEndOfGameGiftDetailData
      {
         return new EndOfGameGiftDetailData(this._giftDetailTitle,this._giftRecipient.summonerName,this._salutationString,true,this._currencyName,this._selectedGift,this._customMessageConfigData,this._detailButtonLabel,"",this._giftDropDownData,this._detailButtonLabel);
      }
      
      private function constructGiftCompleteDetailData(param1:Boolean = true) : IEndOfGameGiftDetailData
      {
         var _loc2_:String = EndOfGameGiftLocaleUtil.getResourceString("eogg_gift_confirmation_title","Gift sent");
         var _loc3_:String = EndOfGameGiftLocaleUtil.getResourceString("eogg_gift_confirmation_salutation","To:");
         var _loc4_:String = EndOfGameGiftLocaleUtil.getResourceString("eogg_gift_confirmation_message","Your Gift has been sent");
         var _loc5_:String = EndOfGameGiftLocaleUtil.getResourceString("eogg_gift_confirmation_button_label","Done");
         return new EndOfGameGiftDetailData(_loc2_,this._giftRecipient.summonerName,_loc3_,param1,this._currencyName,this._selectedGift,this._customMessageConfigData,_loc5_,_loc4_,this._giftDropDownData,this._detailButtonLabel);
      }
      
      private function fetchSalutationText() : String
      {
         return EndOfGameGiftLocaleUtil.getResourceString("eogg_gift_detail_salutation","To:");
      }
      
      private function fetchCurrencyDisplayName() : String
      {
         return EndOfGameGiftLocaleUtil.getResourceString("eogg_currency_RP_long","Riot Points");
      }
      
      private function fetchCustomMessageConfigData() : CustomMessageConfigData
      {
         return new CustomMessageConfigData(EndOfGameGiftLocaleUtil.getResourceString("eogg_gift_detail_custom_message_default_text","custom message..."),DEFAULT_TEXT_COLOR,TEXT_COLOR,BORDER_COLOR,BACKGROUND_COLOR);
      }
      
      private function fetchDetailViewButtonLabel() : String
      {
         return EndOfGameGiftLocaleUtil.getResourceString("eogg_gift_detail_unlock_button_label","Unlock");
      }
      
      private function fetchWindowLabel() : String
      {
         if(!this._isGiftSelected)
         {
            return EndOfGameGiftLocaleUtil.getResourceString("eogg_gift_window_title","Select gift");
         }
         return EndOfGameGiftLocaleUtil.getResourceString("eogg_gift_window_selection_title","Confirm gift");
      }
      
      private function fetchNextButtonLabel() : String
      {
         return EndOfGameGiftLocaleUtil.getResourceString("eogg_gift_window_forward_button_label","Next");
      }
      
      private function fetchBackButtonLabel() : String
      {
         return EndOfGameGiftLocaleUtil.getResourceString("eogg_gift_window_back_button_label","Back");
      }
      
      private function formulateSelectedMessage() : String
      {
         if(this._selectedGiftMessageData != null)
         {
            if(this._selectedGiftMessageData.hasOwnProperty(MESSAGE_PROPERTY_NAME))
            {
               return this._selectedGiftMessageData[MESSAGE_PROPERTY_NAME];
            }
         }
         return "";
      }
      
      private function fetchRecipientSignature() : String
      {
         return EndOfGameGiftLocaleUtil.getResourceString("eogg_gift_detail_sender_signature_prefix","-") + this._sessionPlayer.summonerName;
      }
      
      private function constructGiftDropDownData() : GiftMessageDropDownData
      {
         var _loc1_:String = EndOfGameGiftLocaleUtil.getResourceString("eogg_gift_detail_message_dropdown_default","Select a message...");
         var _loc2_:Vector.<GiftMessageDropDownItemData> = new Vector.<GiftMessageDropDownItemData>();
         _loc2_.push(new GiftMessageDropDownItemData(EndOfGameGiftLocaleUtil.getResourceString("eogg_gift_detail_message_dropdown_message_1","GG"),true));
         _loc2_.push(new GiftMessageDropDownItemData(EndOfGameGiftLocaleUtil.getResourceString("eogg_gift_detail_message_dropdown_message_2","Thanks for the carry!"),true));
         _loc2_.push(new GiftMessageDropDownItemData(EndOfGameGiftLocaleUtil.getResourceString("eogg_gift_detail_message_dropdown_message_3","Well played."),true));
         _loc2_.push(new GiftMessageDropDownItemData(EndOfGameGiftLocaleUtil.getResourceString("eogg_gift_detail_message_dropdown_message_4","Better luck next time."),true));
         _loc2_.push(new GiftMessageDropDownItemData(EndOfGameGiftLocaleUtil.getResourceString("eogg_gift_detail_message_dropdown_message_5","HAHAHAHA!"),true));
         return new GiftMessageDropDownData(MESSAGE_PROPERTY_NAME,_loc1_,_loc2_);
      }
      
      private function constructErrorData(param1:Number, param2:String) : GiftErrorData
      {
         var _loc3_:String = null;
         var _loc4_:String = null;
         var _loc5_:String = null;
         var _loc6_:String = null;
         var _loc7_:String = null;
         if(EndOfGameGiftServiceResponseTypes.isPlayerFacingError(param2))
         {
            _loc3_ = "eogg_gift_validation_error_title_" + param2;
            _loc4_ = "eogg_gift_validation_error_message_" + param2;
            _loc5_ = "eogg_gift_validation_error_kb_text_" + param2;
            _loc6_ = "eogg_gift_validation_error_kb_link_" + param2;
            _loc7_ = "eogg_gift_validation_error_button_label_" + param2;
         }
         else
         {
            _loc3_ = "eogg_gift_system_error_title";
            _loc4_ = "eogg_gift_system_error_message";
            _loc5_ = "eogg_gift_system_error_kb_text";
            _loc6_ = "eogg_gift_system_error_kb_link";
            _loc7_ = "eogg_gift_system_error_button_label";
         }
         return new GiftErrorData(param1,EndOfGameGiftLocaleUtil.getResourceString(_loc3_,"There was a problem"),EndOfGameGiftLocaleUtil.getResourceString(_loc4_,"Unfortunately we are having issues " + "connecting to the store. We are working to " + "resolve this problem; your account should " + "not be charged."),EndOfGameGiftLocaleUtil.getResourceString(_loc5_,"Contact Player Support for more info"),EndOfGameGiftLocaleUtil.getResourceString(_loc6_,"https://support.riotgames.com/"),EndOfGameGiftLocaleUtil.getResourceString(_loc7_,"OK"));
      }
   }
}

