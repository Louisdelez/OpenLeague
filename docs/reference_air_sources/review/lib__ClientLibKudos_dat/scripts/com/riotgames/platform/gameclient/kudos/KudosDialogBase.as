package com.riotgames.platform.gameclient.kudos
{
   import blix.assets.proxy.DisplayObjectProxy;
   import blix.assets.proxy.SpriteProxy;
   import blix.context.IContext;
   import flash.events.Event;
   import flash.events.IEventDispatcher;
   import flash.geom.Point;
   import flash.geom.Rectangle;
   import mx.core.Container;
   import mx.core.UIComponent;
   import mx.events.CloseEvent;
   
   public class KudosDialogBase extends Container implements IKudosDialog
   {
      
      public var container:UIComponent;
      
      protected var recipientName:String;
      
      protected var kudosDialog:SpriteProxy;
      
      protected var gameID:Number = 0;
      
      protected var flexContainer:SpriteProxy;
      
      public var dialogViewDispatcher:IEventDispatcher;
      
      protected var giverID:Number = 0;
      
      protected var context:IContext;
      
      protected var recipientID:Number = 0;
      
      protected var fromPosition:Point;
      
      protected var kudosService:IKudosService;
      
      public function KudosDialogBase(param1:IContext, param2:IKudosService)
      {
         super();
         this.context = param1;
         this.kudosService = param2;
         this.container = new UIComponent();
         this.clipContent = false;
      }
      
      public function display() : void
      {
      }
      
      protected function initializeBlixResourcesHelper() : void
      {
      }
      
      public function cancel() : void
      {
         dispatchEvent(new CloseEvent(CloseEvent.CLOSE));
      }
      
      protected function handleOutOfKudos(param1:KudosEvent) : void
      {
         this.kudosService.removeEventListener(KudosEvent.OUT_OF_KUDOS,this.handleOutOfKudos);
         dispatchEvent(param1.clone());
      }
      
      protected function getAnchorOffsetFromTopLeftCorner(param1:DisplayObjectProxy) : Point
      {
         var _loc3_:Rectangle = null;
         var _loc2_:Point = new Point();
         _loc3_ = param1.getBounds(param1.getAsset());
         _loc2_.x = _loc3_.x;
         _loc2_.y = _loc3_.y;
         return _loc2_;
      }
      
      public function setData(param1:Number, param2:Number, param3:String, param4:Number, param5:Point = null) : void
      {
         this.giverID = param1;
         this.recipientID = param2;
         this.gameID = param4;
         this.fromPosition = param5;
         this.recipientName = param3;
      }
      
      protected function giveKudo(param1:Number) : void
      {
         this.kudosService.giveKudo(this.giverID,this.recipientID,this.gameID,param1);
         this.kudosService.addEventListener(KudosEvent.OUT_OF_KUDOS,this.handleOutOfKudos);
         var _loc2_:Event = new KudosEvent(KudosEvent.KUDOS_GIVEN,this.giverID,this.recipientID,this.gameID);
         this.dispatchEvent(_loc2_);
         this.cancel();
      }
      
      protected function addClickHandlers() : void
      {
         this.dialogViewDispatcher.addEventListener("cancelButtonClicked",this.onCancelButtonClick);
      }
      
      public function initializeBlixResources() : void
      {
         addChild(this.container);
         this.initializeBlixResourcesHelper();
         this.addClickHandlers();
      }
      
      public function onCancelButtonClick(param1:Event) : void
      {
         this.cancel();
      }
   }
}

