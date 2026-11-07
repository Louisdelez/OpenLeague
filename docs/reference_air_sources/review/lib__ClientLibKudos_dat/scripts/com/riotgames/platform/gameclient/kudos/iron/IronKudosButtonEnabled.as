package com.riotgames.platform.gameclient.kudos.iron
{
   import blix.assets.IAssetsManager;
   import com.riotgames.platform.gameclient.domain.PlayerParticipantStatsSummary;
   import com.riotgames.platform.gameclient.kudos.IKudosButton;
   import com.riotgames.platform.gameclient.kudos.IKudosDialog;
   import com.riotgames.platform.gameclient.kudos.IKudosFactory;
   import com.riotgames.platform.gameclient.kudos.KudosEvent;
   import com.riotgames.platform.gameclient.kudos.KudosFactoryProxy;
   import flash.display.DisplayObject;
   import flash.display.MovieClip;
   import flash.events.MouseEvent;
   import flash.geom.Point;
   import flash.geom.Rectangle;
   import mx.events.CloseEvent;
   
   public class IronKudosButtonEnabled extends MovieClip implements IKudosButton
   {
      
      private const OVER_STATE:String = "over";
      
      private var dialog:IKudosDialog;
      
      private var gameID:Number;
      
      private var kudosFactory:IKudosFactory;
      
      private const UP_STATE:String = "up";
      
      private var isRecipientOnMyTeam:Boolean;
      
      private var recipient:PlayerParticipantStatsSummary;
      
      private const DOWN_STATE:String = "down";
      
      private var kudosGivenCallback:Function;
      
      private var summonerID:Number;
      
      private var positionParent:DisplayObject;
      
      private const DISABLED_STATE:String = "disabled";
      
      private var _btnVisual:MovieClip;
      
      private var outOfKudosCallback:Function;
      
      public function IronKudosButtonEnabled(param1:IAssetsManager, param2:Boolean, param3:Number, param4:PlayerParticipantStatsSummary, param5:Number, param6:DisplayObject, param7:Function = null, param8:Function = null)
      {
         super();
         this.isRecipientOnMyTeam = param2;
         this.summonerID = param3;
         this.recipient = param4;
         this.gameID = param5;
         this.positionParent = param6;
         this.outOfKudosCallback = param7;
         this.kudosGivenCallback = param8;
         var _loc9_:Class = param1.getAssetByLinkage("kudosButton");
         this._btnVisual = new _loc9_() as MovieClip;
         addChild(this._btnVisual);
         this.enabled = true;
      }
      
      override public function set enabled(param1:Boolean) : void
      {
         super.enabled = param1;
         if(!enabled)
         {
            this.RemoveMouseEvent();
            this._btnVisual.gotoAndStop(this.DISABLED_STATE);
         }
         else
         {
            this.AddMouseEvent();
            this._btnVisual.gotoAndStop(this.UP_STATE);
         }
      }
      
      private function AddMouseEvent() : void
      {
         this.addEventListener(MouseEvent.MOUSE_OVER,this.onMouseEvent,false,0,true);
         this.addEventListener(MouseEvent.MOUSE_DOWN,this.onMouseEvent,false,0,true);
         this.addEventListener(MouseEvent.CLICK,this.onMouseEvent,false,0,true);
         this.addEventListener(MouseEvent.MOUSE_OUT,this.onMouseEvent,false,0,true);
      }
      
      private function onOutOfKudos(param1:KudosEvent) : void
      {
         if(this.outOfKudosCallback != null)
         {
            this.outOfKudosCallback.call(this);
         }
      }
      
      public function cleanup() : void
      {
         if(Boolean(this.parent))
         {
            this.parent.removeChild(this);
         }
         this.enabled = false;
      }
      
      private function onDialogKudosGiven(param1:KudosEvent) : void
      {
         this.cleanupListeners();
         this.dialog = null;
         this.recipient.reportEnabled = false;
         this.recipient.kudosEnabled = false;
         this.enabled = false;
         if(this.kudosGivenCallback != null)
         {
            this.kudosGivenCallback.call();
         }
      }
      
      private function onDialogClose(param1:CloseEvent) : void
      {
         this.cleanupListeners();
      }
      
      private function onMouseEvent(param1:MouseEvent) : void
      {
         switch(param1.type)
         {
            case MouseEvent.MOUSE_OVER:
               this._btnVisual.gotoAndStop(this.OVER_STATE);
               break;
            case MouseEvent.MOUSE_DOWN:
               this._btnVisual.gotoAndStop(this.DOWN_STATE);
               break;
            case MouseEvent.CLICK:
               this._btnVisual.gotoAndStop(this.UP_STATE);
               this.onButtonClicked();
               break;
            case MouseEvent.MOUSE_OUT:
               this._btnVisual.gotoAndStop(this.UP_STATE);
         }
      }
      
      private function onButtonClicked() : void
      {
         this.kudosFactory = KudosFactoryProxy.getInstance();
         var _loc1_:Rectangle = this.getBounds(this.stage);
         var _loc2_:Point = new Point((_loc1_.right - _loc1_.left) * 0.5,(_loc1_.bottom - _loc1_.top) * 0.5);
         var _loc3_:Point = this.localToGlobal(_loc2_);
         this.dialog = this.kudosFactory.getKudosDialog(this.isRecipientOnMyTeam,this.summonerID,this.recipient.userId,this.recipient.summonerName,this.gameID,_loc3_);
         this.dialog.addEventListener(CloseEvent.CLOSE,this.onDialogClose,false,0,true);
         this.dialog.addEventListener(KudosEvent.KUDOS_GIVEN,this.onDialogKudosGiven,false,0,true);
         this.dialog.addEventListener(KudosEvent.OUT_OF_KUDOS,this.onOutOfKudos);
         this.dialog.display();
      }
      
      private function RemoveMouseEvent() : void
      {
         this.removeEventListener(MouseEvent.MOUSE_OVER,this.onMouseEvent);
         this.removeEventListener(MouseEvent.MOUSE_DOWN,this.onMouseEvent);
         this.removeEventListener(MouseEvent.CLICK,this.onMouseEvent);
         this.removeEventListener(MouseEvent.MOUSE_OUT,this.onMouseEvent);
      }
      
      private function cleanupListeners() : void
      {
         if(Boolean(this.dialog))
         {
            this.dialog.removeEventListener(KudosEvent.KUDOS_GIVEN,this.onDialogKudosGiven);
            this.dialog.removeEventListener(CloseEvent.CLOSE,this.onDialogClose);
         }
      }
   }
}

