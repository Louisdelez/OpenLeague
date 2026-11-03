package com.riotgames.platform.gameclient.kudos
{
   import blix.assets.proxy.SpriteProxy;
   import blix.context.IContext;
   import blix.layout.data.CanvasLayoutData;
   import com.riotgames.platform.gameclient.kudos.actions.ShowKudosDialogAction;
   import flash.events.Event;
   import flash.geom.Point;
   
   public class KudosDialogEnemy extends KudosDialogBase
   {
      
      private var alertAction:ShowKudosDialogAction;
      
      private var blixKudosDialog:KudosDialogEnemyView;
      
      public function KudosDialogEnemy(param1:IContext, param2:IKudosService)
      {
         super(param1,param2);
      }
      
      override protected function addClickHandlers() : void
      {
         super.addClickHandlers();
         dialogViewDispatcher.addEventListener("honorableButtonClicked",this.onHonorableButtonClick);
      }
      
      public function onHonorableButtonClick(param1:Event) : void
      {
         giveKudo(KudosType.Honorable);
      }
      
      override public function display() : void
      {
         var _loc1_:CanvasLayoutData = null;
         var _loc2_:Point = null;
         if(Boolean(this.blixKudosDialog))
         {
            this.blixKudosDialog.setSummonerName(this.recipientName);
            this.blixKudosDialog.resetState();
         }
         this.alertAction = new ShowKudosDialogAction(this.context);
         if(Boolean(fromPosition))
         {
            _loc1_ = new CanvasLayoutData();
            _loc2_ = getAnchorOffsetFromTopLeftCorner(this.blixKudosDialog);
            _loc1_.setLeft(fromPosition.x + _loc2_.x);
            _loc1_.setTop(fromPosition.y + _loc2_.y);
            this.alertAction.add(this,this.blixKudosDialog,_loc1_,new Point(fromPosition.x,fromPosition.y));
         }
         else
         {
            this.alertAction.add(this,this.blixKudosDialog);
         }
      }
      
      override public function cancel() : void
      {
         super.cancel();
         if(Boolean(this.alertAction))
         {
            this.alertAction.complete();
         }
      }
      
      override protected function initializeBlixResourcesHelper() : void
      {
         this.blixKudosDialog = new KudosDialogEnemyView(context);
         var _loc1_:SpriteProxy = new SpriteProxy(context,container);
         _loc1_.addChild(this.blixKudosDialog);
         dialogViewDispatcher = this.blixKudosDialog;
      }
   }
}

