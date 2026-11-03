package com.riotgames.championdetails
{
   import blix.assets.proxy.SpriteProxy;
   import blix.assets.proxy.purchaseScreen.PurchaseItemCardAsset;
   import blix.components.loader.ImageX;
   import blix.components.text.Text;
   import blix.context.Context;
   import blix.layout.vo.HorizontalAlign;
   import com.riotgames.store.model.Catalog;
   import flash.display.DisplayObject;
   import flash.events.Event;
   import flash.geom.Rectangle;
   import flash.net.URLRequest;
   import mx.resources.IResourceManager;
   
   public class ItemCard extends SpriteProxy
   {
      
      private static const CHAMPION_DETAILS_RESOURCE_ID:String = Main.CHAMPION_DETAILS_RESOURCE_ID;
      
      private var _catalog:Catalog;
      
      private var titleText:Text;
      
      private var priceRp:Text;
      
      private var priceIp:Text;
      
      private var imageLoader:ImageX;
      
      private var resourceManager:IResourceManager;
      
      private var orText:Text;
      
      public function ItemCard(param1:Context)
      {
         super(param1);
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
         var _loc1_:PurchaseItemCardAsset = new PurchaseItemCardAsset();
         this.orText = new Text(this);
         this.orText.setText(this.resourceManager.getString(CHAMPION_DETAILS_RESOURCE_ID,"purchaseScreen.orLabel"));
         this.priceRp = new Text(this);
         this.priceIp = new Text(this);
         this.titleText = new Text(this);
         setTimelineChild(_loc1_.titleText,this.titleText);
         this.imageLoader = new ImageX(this);
         this.imageLoader.setHorizontalAlign(HorizontalAlign.CENTER);
         setTimelineChild(_loc1_.imageHolder,this.imageLoader);
      }
      
      public function setCatalog(param1:Catalog) : void
      {
         if(this._catalog != null)
         {
            this.titleText.setText("");
            this.priceRp.setText("");
            this.priceIp.setText("");
         }
         this._catalog = param1;
         if(this._catalog != null)
         {
            this.titleText.setText(this._catalog.item.name);
            this.priceRp.setText(this._catalog.item.rpCost.toString());
            this.priceIp.setText(this._catalog.item.ipCost.toString());
         }
      }
      
      public function setImage(param1:URLRequest) : void
      {
         this.imageLoader.load(param1);
      }
      
      override protected function updateLayout(param1:Number, param2:Number) : Rectangle
      {
         var _loc3_:Rectangle = super.updateLayout(param1,param2);
         var _loc4_:DisplayObject = _asset["imageSizer"];
         if(_loc4_)
         {
            this.imageLoader.setExplicitSize(_loc4_.width,_loc4_.height);
         }
         return _loc3_;
      }
      
      private function onResourceManagerChange(param1:Event) : void
      {
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

