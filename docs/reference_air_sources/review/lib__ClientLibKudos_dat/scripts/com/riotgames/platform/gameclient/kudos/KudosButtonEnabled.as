package com.riotgames.platform.gameclient.kudos
{
   import com.riotgames.platform.common.utils.RiotResourceLoader;
   import com.riotgames.platform.gameclient.components.button.SoundEffectButton;
   import com.riotgames.platform.gameclient.domain.PlayerParticipantStatsSummary;
   import flash.display.DisplayObject;
   import flash.events.MouseEvent;
   import flash.geom.Point;
   import mx.events.CloseEvent;
   
   public class KudosButtonEnabled extends SoundEffectButton implements IKudosButton
   {
      
      private var dialog:IKudosDialog;
      
      private var kudosFactory:IKudosFactory = KudosFactoryProxy.getInstance();
      
      private var gameID:Number;
      
      private var isRecipientOnMyTeam:Boolean;
      
      private var recipient:PlayerParticipantStatsSummary;
      
      private var kudosGivenCallback:Function;
      
      private var summonerID:Number;
      
      private var positionParent:DisplayObject;
      
      private var outOfKudosCallback:Function;
      
      public function KudosButtonEnabled(param1:Boolean, param2:Number, param3:PlayerParticipantStatsSummary, param4:Number, param5:DisplayObject, param6:Function = null, param7:Function = null)
      {
         super();
         this.isRecipientOnMyTeam = param1;
         this.summonerID = param2;
         this.recipient = param3;
         this.gameID = param4;
         this.positionParent = param5;
         this.addEventListener(MouseEvent.CLICK,this.onButtonClicked,false,0,true);
         this.height = 20;
         this.width = 20;
         this.setStyle("styleName","playerSummaryKudos");
         this.toolTip = RiotResourceLoader.getString("kudosEndOfGameButtonTooltip");
         this.outOfKudosCallback = param6;
         this.kudosGivenCallback = param7;
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
         this.removeEventListener(MouseEvent.CLICK,this.onButtonClicked);
      }
      
      private function onDialogKudosGiven(param1:KudosEvent) : void
      {
         if(this.kudosGivenCallback != null)
         {
            this.kudosGivenCallback.call(this,this.recipient.summonerName);
         }
         this.cleanupListeners();
         this.dialog = null;
         this.recipient.reportEnabled = false;
         this.recipient.kudosEnabled = false;
      }
      
      private function onDialogClose(param1:CloseEvent) : void
      {
         this.cleanupListeners();
      }
      
      private function onButtonClicked(param1:MouseEvent) : void
      {
         var _loc2_:Point = this.parent.localToGlobal(new Point(this.x,this.y));
         this.dialog = this.kudosFactory.getKudosDialog(this.isRecipientOnMyTeam,this.summonerID,this.recipient.userId,this.recipient.summonerName,this.gameID,this.positionParent.localToGlobal(new Point(this.x,this.y)));
         this.dialog.addEventListener(CloseEvent.CLOSE,this.onDialogClose,false,0,true);
         this.dialog.addEventListener(KudosEvent.KUDOS_GIVEN,this.onDialogKudosGiven,false,0,true);
         this.dialog.addEventListener(KudosEvent.OUT_OF_KUDOS,this.onOutOfKudos);
         this.dialog.display();
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

