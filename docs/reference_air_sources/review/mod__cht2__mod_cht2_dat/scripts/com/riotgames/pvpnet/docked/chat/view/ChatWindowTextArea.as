package com.riotgames.pvpnet.docked.chat.view
{
   import blix.assets.proxy.SpriteProxy;
   import blix.components.scroll.TailedScrollingBehavior;
   import blix.components.text.TextScroller;
   import blix.context.IContext;
   import blix.signals.ISignal;
   import blix.signals.Signal;
   import com.riotgames.platform.common.session.Session;
   import com.riotgames.platform.common.utils.RiotResourceLoader;
   import com.riotgames.platform.gameclient.chat.domain.ChatPersonalMessageVO;
   import com.riotgames.platform.gameclient.chat.utils.ChatFormatUtil;
   import com.riotgames.platform.gameclient.domain.Summoner;
   import com.riotgames.pvpnet.chat.model.ChatWindowModel;
   import com.riotgames.pvpnet.system.alerter.AlertAction;
   import com.riotgames.pvpnet.system.alerter.AlertWithCheckBoxAction;
   import com.riotgames.pvpnet.system.config.UserPreferencesManager;
   import com.riotgames.pvpnet.system.wordfilter.WordFilter;
   import flash.events.TextEvent;
   import flash.net.URLRequest;
   import flash.net.navigateToURL;
   import flash.text.TextFormat;
   import mx.formatters.DateFormatter;
   import mx.resources.IResourceManager;
   import mx.resources.ResourceManager;
   
   public class ChatWindowTextArea extends SpriteProxy
   {
      
      private static const USER_COLOR_ONE:String = "#00CCFF";
      
      private static const USER_COLOR_TWO:String = "#FFCC00";
      
      private static const LINK_COLOR:String = "#a7d0ff";
      
      private static const FONT_FAMILY_OPENING_TAG:String = "<font face=\'ApplicationFont1\'>";
      
      private static const FONT_FAMILY_CLOSING_TAG:String = "</font>";
      
      private var _model:ChatWindowModel;
      
      private var _dateFormatter:DateFormatter;
      
      private var _chatText:TextScroller;
      
      private var _chatTextBody:String = "";
      
      private var _linkClicked:Signal = new Signal();
      
      private var _urlText:String;
      
      private var lastTimeStampedMessage:Date = null;
      
      private var _showTimestamps:Boolean = false;
      
      private var _tailingBehavior:TailedScrollingBehavior;
      
      public function ChatWindowTextArea(param1:IContext)
      {
         super(param1);
      }
      
      override protected function createChildren() : void
      {
         super.createChildren();
         this._dateFormatter = new DateFormatter();
         this._dateFormatter.formatString = "[L:NN] ";
         this._chatText = new TextScroller(this);
         this._chatText.getLayoutInvalidated().add(invalidateLayout);
         this._chatText.setMouseWheelEnabled(false);
         var _loc1_:TextFormat = new TextFormat("ApplicationFont1");
         this._chatText.getTextView().setDefaultTextFormat(_loc1_);
         setTimelineChildByName("textScroller",this._chatText);
         this._tailingBehavior = new TailedScrollingBehavior(this._chatText.getVScrollModel());
         this._chatText.setHtmlText(FONT_FAMILY_OPENING_TAG + FONT_FAMILY_CLOSING_TAG);
      }
      
      public function setModel(param1:ChatWindowModel) : void
      {
         if(this._model != param1)
         {
            if(this._model)
            {
               this._model.getChatMessagesChanged().remove(this.handleChatMessagesChanged);
            }
            this._model = param1;
            if(this._model)
            {
               this._model.getChatMessagesChanged().add(this.handleChatMessagesChanged);
            }
            this.showAllChatMessages();
         }
      }
      
      public function getTextScroller() : TextScroller
      {
         return this._chatText;
      }
      
      private function handleChatMessagesChanged() : void
      {
         this.addChatMessage(this._model.getMessages()[this._model.getMessages().length - 1]);
      }
      
      private function showAllChatMessages() : void
      {
         var _loc1_:ChatPersonalMessageVO = null;
         this._chatText.setHtmlText("");
         this._chatTextBody = "<font color=\'#A31C1C\'>" + RiotResourceLoader.getString("chat_imWindow_defaultMessage","**Please remember that Riot employees will never ask for your password when assisting you.") + "</font>" + "\n";
         if(this._model)
         {
            for each(_loc1_ in this._model.getMessages())
            {
               this.addChatMessage(_loc1_);
            }
         }
      }
      
      private function addChatMessage(param1:ChatPersonalMessageVO) : void
      {
         var _loc2_:String = null;
         if(param1)
         {
            _loc2_ = "<p>";
            _loc2_ += this.getFormattedChatString(param1);
            _loc2_ += "</p>";
            this._chatTextBody += _loc2_;
            this._chatText.setHtmlText(FONT_FAMILY_OPENING_TAG + this._chatTextBody + FONT_FAMILY_CLOSING_TAG);
            this._chatText.addEventListener(TextEvent.LINK,this.onLinkClicked);
         }
      }
      
      private function onLinkClicked(param1:TextEvent) : void
      {
         var _loc2_:String = null;
         var _loc3_:IResourceManager = null;
         var _loc4_:AlertAction = null;
         this._urlText = param1.text;
         if(!UserPreferencesManager.userPrefs.enableLinkClickWarning)
         {
            this.doNavigateToUrl();
         }
         else
         {
            _loc2_ = ResourceManager.getInstance().getString("resources","common_button_ok");
            _loc3_ = ResourceManager.getInstance();
            _loc4_ = new AlertWithCheckBoxAction(_loc3_.getString("resources","alert_title"),_loc3_.getString("resources","chat_link_click_warning",[_loc2_]),false,_loc3_.getString("resources","chat_link_click_warning_checkboxtext"));
            _loc4_.showNegative = true;
            _loc4_.setOkCancelLabels();
            _loc4_.add();
            _loc4_.getCompleted().add(this.onLinkClickedReal);
         }
      }
      
      private function onLinkClickedReal(param1:AlertAction) : void
      {
         if(param1.affirmativeResponse)
         {
            this.doNavigateToUrl();
         }
         UserPreferencesManager.userPrefs.enableLinkClickWarning = !(param1 as AlertWithCheckBoxAction).checkbox_selected;
         UserPreferencesManager.instance.saveUserPreferences(Session.instance.summoner.name);
      }
      
      private function doNavigateToUrl() : void
      {
         navigateToURL(new URLRequest(this._urlText));
         this._linkClicked.dispatch();
      }
      
      public function getLinkClicked() : ISignal
      {
         return this._linkClicked;
      }
      
      private function getFormattedChatString(param1:ChatPersonalMessageVO) : String
      {
         var _loc2_:String = "";
         var _loc3_:String = "";
         if(this._showTimestamps)
         {
            _loc3_ = this._dateFormatter.format(param1.timeStamp);
         }
         if(this.shouldShowName(param1))
         {
            _loc2_ += "<font color=\'" + this.getMessageColor(param1) + "\'>";
            if(this._showTimestamps)
            {
               _loc2_ += _loc3_;
               this.lastTimeStampedMessage = param1.timeStamp;
            }
            _loc2_ += param1.userFrom;
            _loc2_ += ": </font>";
         }
         else if(this._showTimestamps && this.lastTimeStampedMessage != null && param1.timeStamp.time - this.lastTimeStampedMessage.time > 120000)
         {
            _loc2_ += "<font color=\'" + this.getMessageColor(param1) + "\'>";
            _loc2_ += _loc3_;
            _loc2_ += ": </font>";
            this.lastTimeStampedMessage = param1.timeStamp;
         }
         var _loc4_:String = WordFilter.instance.maskOffensiveWords(param1.message);
         return _loc2_ + ChatFormatUtil.convertUrlsToLinks(_loc4_,LINK_COLOR);
      }
      
      private function shouldShowName(param1:ChatPersonalMessageVO) : Boolean
      {
         var _loc2_:int = 0;
         var _loc3_:ChatPersonalMessageVO = null;
         if(Boolean(this._model) && Boolean(this._model.getMessages()))
         {
            _loc2_ = int(this._model.getMessages().indexOf(param1));
            if(_loc2_ <= 0)
            {
               return true;
            }
            _loc3_ = this._model.getMessages()[_loc2_ - 1];
            if(!_loc3_)
            {
               return true;
            }
            return _loc3_.userFrom != param1.userFrom;
         }
         return false;
      }
      
      private function getMessageColor(param1:ChatPersonalMessageVO) : String
      {
         var _loc2_:Summoner = Session.instance.summoner;
         if(Boolean(_loc2_) && param1.userFrom == _loc2_.name)
         {
            return USER_COLOR_ONE;
         }
         return USER_COLOR_TWO;
      }
      
      public function setShowTimestamps(param1:Boolean) : void
      {
         this._showTimestamps = param1;
         this.showAllChatMessages();
      }
   }
}

