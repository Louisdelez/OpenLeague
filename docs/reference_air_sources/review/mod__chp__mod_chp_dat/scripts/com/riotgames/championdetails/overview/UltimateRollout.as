package com.riotgames.championdetails.overview
{
   import blix.components.button.ButtonX;
   import blix.components.text.Text;
   import blix.components.timeline.StatefulView;
   import blix.context.IContext;
   import com.riotgames.championdetails.Main;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import mx.resources.IResourceManager;
   
   public class UltimateRollout extends StatefulView
   {
      
      private static const CHAMPION_DETAILS_RESOURCE_ID:String = Main.CHAMPION_DETAILS_RESOURCE_ID;
      
      private var openButton:ButtonX;
      
      private var closeButton:ButtonX;
      
      public var featuresText:Text;
      
      private var featuresLabel:Text;
      
      private var _userOpened:Boolean = true;
      
      private var resourceManager:IResourceManager;
      
      public function UltimateRollout(param1:IContext)
      {
         super(param1);
         this.close();
      }
      
      override protected function initializeDependencies() : void
      {
         super.initializeDependencies();
         this.resourceManager = getDependency(IResourceManager);
         this.resourceManager.addEventListener(Event.CHANGE,this.onResourceManagerChange);
      }
      
      override protected function createChildren() : void
      {
         super.createChildren();
         this.openButton = new ButtonX(this);
         this.openButton.addEventListener(MouseEvent.CLICK,this.openClickedHandler);
         setTimelineChildByName("openButton",this.openButton);
         this.closeButton = new ButtonX(this);
         setTimelineChildByName("rolloutPanel.closeButton",this.closeButton);
         this.closeButton.addEventListener(MouseEvent.CLICK,this.closeClickedHandler);
         this.featuresLabel = new Text(this);
         this.featuresLabel.setText(this.resourceManager.getString(CHAMPION_DETAILS_RESOURCE_ID,"ultimateSkinCard.featuresLabel"));
         setTimelineChildByName("rolloutPanel.rolloutTitle",this.featuresLabel);
         this.featuresText = new Text(this);
         setTimelineChildByName("rolloutPanel.featuresText",this.featuresText);
      }
      
      private function closeClickedHandler(param1:MouseEvent) : void
      {
         this._userOpened = false;
         this.close();
      }
      
      private function openClickedHandler(param1:MouseEvent) : void
      {
         this._userOpened = true;
         this.open();
      }
      
      public function getUserOpened() : Boolean
      {
         return this._userOpened;
      }
      
      public function show() : void
      {
         if(this.getUserOpened())
         {
            this.open();
         }
      }
      
      public function hide() : void
      {
         this.close();
      }
      
      public function open() : void
      {
         setCurrentState("opened");
      }
      
      public function close() : void
      {
         setCurrentState("closed");
      }
      
      private function onResourceManagerChange(param1:Event) : void
      {
         this.featuresLabel.setText(this.resourceManager.getString(CHAMPION_DETAILS_RESOURCE_ID,"ultimateSkinCard.featuresLabel"));
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

