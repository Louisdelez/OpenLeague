package com.riotgames.newplayerlanding.views.carousel
{
   import blix.assets.proxy.SpriteProxy;
   import blix.assets.proxy.TextFieldProxy;
   import blix.context.IContext;
   import com.riotgames.newplayerlanding.NewPlayerLandingConfig;
   import mx.resources.IResourceManager;
   import mx.resources.ResourceManager;
   
   public class ItemPage extends SpriteProxy
   {
      
      private var _header:NPLPHeader;
      
      private var _itemShopTitle:TextFieldProxy;
      
      private var _itemShopText1:TextFieldProxy;
      
      private var _itemShopText2:TextFieldProxy;
      
      private var _recommendedTitle:TextFieldProxy;
      
      private var _buildingTitle:TextFieldProxy;
      
      private var _buildingText1:TextFieldProxy;
      
      private var _buildingText2:TextFieldProxy;
      
      public function ItemPage(param1:IContext)
      {
         super(param1);
      }
      
      override protected function createChildren() : void
      {
         super.createChildren();
         this._header = new NPLPHeader(this);
         setTimelineChildByName("header",this._header);
         this._header.setTextFromKeys("nplp.items.heading","nplp.items.subheading");
         var _loc1_:IResourceManager = ResourceManager.getInstance();
         this._itemShopTitle = new TextFieldProxy(this);
         setTimelineChildByName("itemShopTitle.template.mask.text",this._itemShopTitle);
         this._itemShopTitle.setText(_loc1_.getString(NewPlayerLandingConfig.LOCALIZATION_NAMESPACE,"nplp.items.itemshoptitle"));
         this._itemShopText1 = new TextFieldProxy(this);
         setTimelineChildByName("itemShopText1.innerText",this._itemShopText1);
         this._itemShopText1.setText(_loc1_.getString(NewPlayerLandingConfig.LOCALIZATION_NAMESPACE,"nplp.items.itemshoptext1"));
         this._itemShopText2 = new TextFieldProxy(this);
         setTimelineChildByName("itemShopText2.innerText",this._itemShopText2);
         this._itemShopText2.setText(_loc1_.getString(NewPlayerLandingConfig.LOCALIZATION_NAMESPACE,"nplp.items.itemshoptext2"));
         this._recommendedTitle = new TextFieldProxy(this);
         setTimelineChildByName("recommendedTitle.template.mask.text",this._recommendedTitle);
         this._recommendedTitle.setText(_loc1_.getString(NewPlayerLandingConfig.LOCALIZATION_NAMESPACE,"nplp.items.recommendedtitle"));
         this._buildingTitle = new TextFieldProxy(this);
         setTimelineChildByName("buildingTitle.template.mask.text",this._buildingTitle);
         this._buildingTitle.setText(_loc1_.getString(NewPlayerLandingConfig.LOCALIZATION_NAMESPACE,"nplp.items.buildingtitle"));
         this._buildingText1 = new TextFieldProxy(this);
         setTimelineChildByName("buildingText1.innerText",this._buildingText1);
         this._buildingText1.setText(_loc1_.getString(NewPlayerLandingConfig.LOCALIZATION_NAMESPACE,"nplp.items.buildingtext1"));
         this._buildingText2 = new TextFieldProxy(this);
         setTimelineChildByName("buildingText2.innerText",this._buildingText2);
         this._buildingText2.setText(_loc1_.getString(NewPlayerLandingConfig.LOCALIZATION_NAMESPACE,"nplp.items.buildingtext2"));
      }
   }
}

