package com.riotgames.championdetails
{
   import blix.assets.proxy.SpriteProxy;
   import blix.assets.proxy.errorDialog.ErrorDialogAsset;
   import blix.components.button.ButtonX;
   import blix.components.button.LabelButtonX;
   import blix.components.text.Text;
   import blix.components.timeline.StatefulView;
   import blix.context.Context;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import mx.resources.IResourceManager;
   
   public class ErrorDialog extends StatefulView
   {
      
      private static const CHAMPION_DETAILS_RESOURCE_ID:String = Main.CHAMPION_DETAILS_RESOURCE_ID;
      
      private var errorMessage:Text;
      
      private var _closeCallback:Function;
      
      private var resourceManager:IResourceManager;
      
      private var titleText:Text;
      
      private var okButton:LabelButtonX;
      
      public function ErrorDialog(param1:Context)
      {
         super(param1);
         setCurrentState("hide");
      }
      
      public function showErrorMessage(param1:String, param2:Function = null) : void
      {
         this.errorMessage.setText(param1);
         this._closeCallback = param2;
         setMouseChildren(true);
         setCurrentState("show");
      }
      
      public function close() : void
      {
         setMouseChildren(false);
         setCurrentState("hide");
         if(this._closeCallback != null)
         {
            this._closeCallback.apply();
         }
      }
      
      override protected function createChildren() : void
      {
         super.createChildren();
         var _loc1_:ErrorDialogAsset = new ErrorDialogAsset();
         var _loc2_:SpriteProxy = _loc1_.modalBlock.create(this);
         _loc2_.addEventListener(MouseEvent.CLICK,this.closeClickHandler);
         this.titleText = new Text(this);
         this.titleText.setText(this.resourceManager.getString(CHAMPION_DETAILS_RESOURCE_ID,"errorDialog.title"));
         setTimelineChild(_loc1_.dialog.titleText,this.titleText);
         this.okButton = new LabelButtonX(this);
         this.okButton.setText(this.resourceManager.getString(CHAMPION_DETAILS_RESOURCE_ID,"errorDialog.ok"));
         this.okButton.addEventListener(MouseEvent.CLICK,this.closeClickHandler);
         setTimelineChild(_loc1_.dialog.okButton,this.okButton);
         var _loc3_:ButtonX = new ButtonX(this);
         _loc3_.addEventListener(MouseEvent.CLICK,this.closeClickHandler);
         setTimelineChild(_loc1_.dialog.closeButton,_loc3_);
         this.errorMessage = new Text(this);
         setTimelineChild(_loc1_.dialog.errorMessageText,this.errorMessage);
      }
      
      override public function getTransitionsEnabled() : Boolean
      {
         return getFirstContext(IChampionDetailsContext).getConfig().useTransitions;
      }
      
      override protected function initializeDependencies() : void
      {
         super.initializeDependencies();
         this.resourceManager = getDependency(IResourceManager);
         this.resourceManager.addEventListener(Event.CHANGE,this.onResourceManagerChange);
      }
      
      private function closeClickHandler(param1:MouseEvent) : void
      {
         this.close();
      }
      
      private function onResourceManagerChange(param1:Event) : void
      {
         this.titleText.setText(this.resourceManager.getString(CHAMPION_DETAILS_RESOURCE_ID,"errorDialog.title"));
         this.okButton.setText(this.resourceManager.getString(CHAMPION_DETAILS_RESOURCE_ID,"errorDialog.ok"));
      }
      
      override public function destroy() : void
      {
         if(this.resourceManager)
         {
            this.resourceManager.removeEventListener(Event.CHANGE,this.onResourceManagerChange);
            this.resourceManager = null;
         }
         super.destroy();
      }
   }
}

