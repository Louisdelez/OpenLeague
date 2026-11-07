package com.riotgames.championdetails
{
   import blix.assets.proxy.SpriteProxy;
   import blix.assets.proxy.TextFieldProxy;
   import blix.assets.proxy.unlockButton.UnlockAreaAsset;
   import blix.components.button.LabelButtonX;
   import blix.components.text.Text;
   import blix.context.Context;
   import blix.layout.LayoutContainer;
   import blix.layout.algorithms.HorizontalLayout;
   import blix.layout.data.SizeLayoutData;
   import blix.layout.vo.HorizontalAlign;
   import blix.layout.vo.VerticalAlign;
   import blix.view.View;
   import com.riotgames.store.model.Catalog;
   import flash.events.Event;
   import flash.geom.Rectangle;
   import flash.text.TextFieldAutoSize;
   import mx.resources.IResourceManager;
   
   public class UnlockArea extends SpriteProxy
   {
      
      private static const CHAMPION_DETAILS_RESOURCE_ID:String = Main.CHAMPION_DETAILS_RESOURCE_ID;
      
      public var unlockButton:LabelButtonX;
      
      private var ipCostText:TextFieldProxy;
      
      private var rpCostText:TextFieldProxy;
      
      private var orText:Text;
      
      private var costLayout:LayoutContainer;
      
      private var rpIcon:SpriteProxy;
      
      private var ipIcon:SpriteProxy;
      
      private var priceSizer:SpriteProxy;
      
      private var _catalog:Catalog;
      
      private var resourceManager:IResourceManager;
      
      public function UnlockArea(param1:Context)
      {
         super(param1);
         this.resourceManager.addEventListener(Event.CHANGE,this.onResourceManagerChange);
         this.onResourceManagerChange();
      }
      
      override protected function initializeDependencies() : void
      {
         super.initializeDependencies();
         this.resourceManager = getDependency(IResourceManager);
      }
      
      override protected function createChildren() : void
      {
         super.createChildren();
         var _loc1_:UnlockAreaAsset = new UnlockAreaAsset();
         this.unlockButton = new LabelButtonX(this);
         setTimelineChild(_loc1_.unlockButton,this.unlockButton);
         this.priceSizer = _loc1_.priceSizer.create(this);
         this.priceSizer.getLayoutInvalidated().add(invalidateLayout);
         this.costLayout = new LayoutContainer(this);
         this.costLayout.getLayoutInvalidated().add(invalidateLayout);
         var _loc2_:HorizontalLayout = new HorizontalLayout();
         _loc2_.setGap(1);
         _loc2_.setVerticalAlign(VerticalAlign.MIDDLE);
         _loc2_.setHorizontalAlign(HorizontalAlign.CENTER);
         this.costLayout.setLayoutAlgorithm(_loc2_);
         this.rpIcon = _loc1_.rpIcon.create(this);
         this.costLayout.addElement(this.rpIcon);
         this.rpCostText = _loc1_.rpCostText.create(this);
         this.rpCostText.setAutoSize(TextFieldAutoSize.LEFT);
         this.costLayout.addElement(this.rpCostText);
         var _loc3_:SizeLayoutData = new SizeLayoutData();
         _loc3_.setWidth(10);
         this.costLayout.addElement(new View(this),_loc3_);
         this.orText = new Text(this);
         setTimelineChild(_loc1_.orText,this.orText);
         this.orText.setAutoSize(TextFieldAutoSize.LEFT);
         this.costLayout.addElement(this.orText);
         var _loc4_:SizeLayoutData = new SizeLayoutData();
         _loc4_.setWidth(10);
         this.costLayout.addElement(new View(this),_loc4_);
         this.ipIcon = _loc1_.ipIcon.create(this);
         this.costLayout.addElement(this.ipIcon);
         this.ipCostText = _loc1_.ipCostText.create(this);
         this.ipCostText.setAutoSize(TextFieldAutoSize.LEFT);
         this.costLayout.addElement(this.ipCostText);
      }
      
      override protected function updateLayout(param1:Number, param2:Number) : Rectangle
      {
         this.costLayout.setExplicitSize(this.priceSizer.getWidth(),this.priceSizer.getHeight());
         this.costLayout.setExplicitPosition(this.priceSizer.getX(),this.priceSizer.getY());
         return super.updateLayout(param1,param2);
      }
      
      public function setCatalog(param1:Catalog) : void
      {
         if(this._catalog != null)
         {
            this.ipCostText.setText("");
            this.ipCostText.setVisible(false);
            this.ipIcon.setVisible(false);
            this.rpCostText.setText("");
            this.rpCostText.setVisible(false);
            this.rpIcon.setVisible(false);
         }
         this._catalog = param1;
         if(this._catalog != null)
         {
            this.ipCostText.setText(this._catalog.item.ipCost.toString());
            this.ipCostText.setVisible(this._catalog.item.ipCost > 0);
            this.ipIcon.setVisible(this._catalog.item.ipCost > 0);
            this.rpCostText.setText(this._catalog.item.rpCost.toString());
            this.rpCostText.setVisible(this._catalog.item.rpCost > 0);
            this.rpIcon.setVisible(this._catalog.item.rpCost > 0);
         }
      }
      
      private function onResourceManagerChange(param1:Event = null) : void
      {
         this.unlockButton.setText(this.resourceManager.getString(CHAMPION_DETAILS_RESOURCE_ID,"unlockChampion"));
         this.orText.setText(this.resourceManager.getString(CHAMPION_DETAILS_RESOURCE_ID,"purchaseScreen.orLabel"));
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

