package com.riotgames.platform.gameclient.views.game.common.invite
{
   import com.riotgames.platform.common.utils.RiotResourceLoader;
   import com.riotgames.platform.gameclient.components.button.SoundEffectButton;
   import com.riotgames.pvpnet.suggestedplayers.model.SuggestedPlayer;
   import com.riotgames.pvpnet.system.config.cdc.DynamicClientConfigManager;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import mx.controls.Button;
   import mx.controls.Image;
   import mx.controls.Label;
   import mx.controls.listClasses.IListItemRenderer;
   import mx.core.UIComponent;
   
   public class SuggestedPlayerRenderer extends UIComponent implements IListItemRenderer
   {
      
      public static const SUGGESTED_PLAYER_INVITED:String = "suggestedPlayerInvited";
      
      public static const SUGGESTED_PLAYER_DECLINED:String = "suggestedPlayerDeclined";
      
      private static const BUTTON_SPACING:int = 5;
      
      private static const ICON_LABEL_GAPX:int = 3;
      
      public static var VictoriousIconOver:Class = SuggestedPlayerRenderer_VictoriousIconOver;
      
      public static var VictoriousIconUp:Class = SuggestedPlayerRenderer_VictoriousIconUp;
      
      public static var OnlineFriendIconOver:Class = SuggestedPlayerRenderer_OnlineFriendIconOver;
      
      public static var OnlineFriendIconUp:Class = SuggestedPlayerRenderer_OnlineFriendIconUp;
      
      public static var PremadeIconOver:Class = SuggestedPlayerRenderer_PremadeIconOver;
      
      public static var PremadeIconUp:Class = SuggestedPlayerRenderer_PremadeIconUp;
      
      public static var HonorableIconOver:Class = SuggestedPlayerRenderer_HonorableIconOver;
      
      public static var HonorableIconUp:Class = SuggestedPlayerRenderer_HonorableIconUp;
      
      public static var FriendOfFriendIconOver:Class = SuggestedPlayerRenderer_FriendOfFriendIconOver;
      
      public static var FriendOfFriendIconUp:Class = SuggestedPlayerRenderer_FriendOfFriendIconUp;
      
      protected var _data:Object;
      
      protected var declineButton:Button;
      
      protected var inviteButton:Button;
      
      protected var suggestedPlayer:SuggestedPlayer;
      
      protected var dataChanged:Boolean = false;
      
      protected var iconOver:Image;
      
      protected var iconUp:Image;
      
      protected var label:Label;
      
      public function SuggestedPlayerRenderer()
      {
         super();
      }
      
      protected function handleDeclineButtonClick(param1:MouseEvent) : void
      {
         dispatchEvent(new Event(SUGGESTED_PLAYER_DECLINED,true));
      }
      
      protected function createDeclineButton() : Button
      {
         var _loc1_:Button = new SoundEffectButton();
         _loc1_.setStyle("styleName","removeButton");
         return _loc1_;
      }
      
      private function updateViewToRollOverState(param1:MouseEvent) : void
      {
         this.iconOver.visible = true;
         this.iconUp.visible = false;
      }
      
      override protected function commitProperties() : void
      {
         super.commitProperties();
         if(this.dataChanged)
         {
            this.updateIcon();
            this.updateLabel();
            this.dataChanged = false;
         }
      }
      
      private function updateViewToUpState(param1:MouseEvent) : void
      {
         this.iconOver.visible = false;
         this.iconUp.visible = true;
      }
      
      protected function createIcon() : Image
      {
         return new Image();
      }
      
      protected function createLabel() : Label
      {
         var _loc1_:Label = new Label();
         _loc1_.setStyle("textAlign","left");
         _loc1_.setStyle("color",15658734);
         return _loc1_;
      }
      
      override protected function createChildren() : void
      {
         super.createChildren();
         if(!this.iconUp)
         {
            this.iconUp = this.createIcon();
            addChild(this.iconUp);
         }
         if(!this.iconOver)
         {
            this.iconOver = this.createIcon();
            addChild(this.iconOver);
            this.iconOver.visible = false;
         }
         if(!this.label)
         {
            this.label = this.createLabel();
            addChild(this.label);
         }
         if(!this.inviteButton)
         {
            this.inviteButton = this.createInviteButton();
            addChild(this.inviteButton);
         }
         if(!this.declineButton)
         {
            this.declineButton = this.createDeclineButton();
            addChild(this.declineButton);
         }
      }
      
      protected function handleInviteButtonClick(param1:MouseEvent) : void
      {
         dispatchEvent(new Event(SUGGESTED_PLAYER_INVITED,true));
      }
      
      override protected function childrenCreated() : void
      {
         super.childrenCreated();
         if(this.inviteButton)
         {
            this.inviteButton.addEventListener(MouseEvent.CLICK,this.handleInviteButtonClick);
         }
         if(this.declineButton)
         {
            this.declineButton.addEventListener(MouseEvent.CLICK,this.handleDeclineButtonClick);
         }
         this.addEventListener(MouseEvent.ROLL_OVER,this.updateViewToRollOverState);
         this.addEventListener(MouseEvent.ROLL_OUT,this.updateViewToUpState);
      }
      
      protected function updateLabel() : void
      {
         if(Boolean(this.label) && Boolean(this.suggestedPlayer))
         {
            this.label.text = this.suggestedPlayer.summonerName;
            if(this.suggestedPlayer.suggestionReason == SuggestedPlayer.REASON_HONORED)
            {
               this.label.toolTip = RiotResourceLoader.getString("normalGame_arrangedTeam_suggestedPlayers_honored_tooltip","",[this.suggestedPlayer.summonerName]);
            }
            else if(this.suggestedPlayer.suggestionReason == SuggestedPlayer.REASON_VICTORIOUS_COMRADE)
            {
               this.label.toolTip = RiotResourceLoader.getString("normalGame_arrangedTeam_suggestedPlayers_victorious_comrade_tooltip","",[this.suggestedPlayer.summonerName]);
            }
            else if(this.suggestedPlayer.suggestionReason == SuggestedPlayer.REASON_FRIEND_OF_FRIEND)
            {
               this.label.toolTip = RiotResourceLoader.getString("normalGame_arrangedTeam_suggestedPlayers_fof_tooltip","",[this.suggestedPlayer.summonerName,this.suggestedPlayer.commonFriendName]);
            }
            else
            {
               this.label.toolTip = "";
            }
         }
      }
      
      public function set data(param1:Object) : void
      {
         if(this._data == param1)
         {
            return;
         }
         this._data = param1;
         this.suggestedPlayer = param1 as SuggestedPlayer;
         this.dataChanged = true;
         invalidateProperties();
      }
      
      public function get data() : Object
      {
         return this._data;
      }
      
      protected function createInviteButton() : Button
      {
         var _loc1_:Button = new SoundEffectButton();
         _loc1_.setStyle("styleName","addButton");
         return _loc1_;
      }
      
      protected function updateIcon() : void
      {
         if(this.suggestedPlayer)
         {
            switch(this.suggestedPlayer.suggestionReason)
            {
               case SuggestedPlayer.REASON_HONORED:
                  this.iconUp.source = new HonorableIconUp();
                  this.iconOver.source = new HonorableIconOver();
                  break;
               case SuggestedPlayer.REASON_VICTORIOUS_COMRADE:
                  this.iconUp.source = new VictoriousIconUp();
                  this.iconOver.source = new VictoriousIconOver();
                  break;
               case SuggestedPlayer.REASON_FRIEND_OF_FRIEND:
                  this.iconUp.source = new FriendOfFriendIconUp();
                  this.iconOver.source = new FriendOfFriendIconOver();
                  break;
               case SuggestedPlayer.REASON_ONLINE_FRIEND:
                  this.iconUp.source = new OnlineFriendIconUp();
                  this.iconOver.source = new OnlineFriendIconOver();
                  break;
               case SuggestedPlayer.REASON_PREVIOUS_PREMADE:
                  this.iconUp.source = new PremadeIconUp();
                  this.iconOver.source = new PremadeIconOver();
                  break;
               default:
                  this.iconUp.source = null;
            }
         }
      }
      
      override protected function updateDisplayList(param1:Number, param2:Number) : void
      {
         var _loc9_:Number = NaN;
         var _loc10_:Number = NaN;
         super.updateDisplayList(param1,param2);
         var _loc3_:Number = 0;
         var _loc4_:Number = 0;
         if(Boolean(this.iconUp) && Boolean(this.iconOver) && Boolean(DynamicClientConfigManager.getConfiguration("SuggestedPlayers","VisualUpdate",false).getBoolean()))
         {
            _loc3_ = Number(this.iconUp.getExplicitOrMeasuredWidth());
            _loc4_ = Number(this.iconUp.getExplicitOrMeasuredHeight());
            this.iconOver.setActualSize(_loc3_,_loc4_);
            this.iconUp.setActualSize(_loc3_,_loc4_);
            this.iconOver.move(0,(param2 - _loc4_) / 2);
            this.iconUp.move(0,(param2 - _loc4_) / 2);
         }
         else
         {
            this.iconUp.setActualSize(0,0);
            this.iconOver.setActualSize(0,0);
         }
         if(this.label)
         {
            _loc9_ = Number(this.label.getExplicitOrMeasuredWidth());
            _loc10_ = Number(this.label.getExplicitOrMeasuredHeight());
            this.label.setActualSize(_loc9_,_loc10_);
            this.label.move(ICON_LABEL_GAPX + _loc3_,(param2 - _loc10_) / 2);
         }
         var _loc5_:Number = 0;
         var _loc6_:Number = 0;
         if(this.declineButton)
         {
            _loc5_ = Number(this.declineButton.getExplicitOrMeasuredWidth());
            _loc6_ = Number(this.declineButton.getExplicitOrMeasuredHeight());
            this.declineButton.setActualSize(this.declineButton.getExplicitOrMeasuredWidth(),this.declineButton.getExplicitOrMeasuredHeight());
            this.declineButton.move(param1 - _loc5_,(param2 - _loc6_) / 2);
         }
         var _loc7_:Number = 0;
         var _loc8_:Number = 0;
         if(this.inviteButton)
         {
            _loc7_ = Number(this.inviteButton.getExplicitOrMeasuredWidth());
            _loc8_ = Number(this.inviteButton.getExplicitOrMeasuredHeight());
            this.inviteButton.setActualSize(this.inviteButton.getExplicitOrMeasuredWidth(),this.inviteButton.getExplicitOrMeasuredHeight());
            this.inviteButton.move(param1 - _loc7_ - _loc5_ - BUTTON_SPACING,(param2 - _loc8_) / 2);
         }
      }
   }
}

