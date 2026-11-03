package com.riotgames.newplayerlanding.views.carousel
{
   import blix.assets.proxy.SpriteProxy;
   import blix.assets.proxy.TextFieldProxy;
   import blix.context.IContext;
   import com.riotgames.newplayerlanding.NewPlayerLandingConfig;
   import mx.resources.IResourceManager;
   import mx.resources.ResourceManager;
   
   public class TurretsPage extends SpriteProxy
   {
      
      private var _header:NPLPHeader;
      
      private var _title1:TextFieldProxy;
      
      private var _text1:TextFieldProxy;
      
      private var _title2:TextFieldProxy;
      
      private var _text2:TextFieldProxy;
      
      private var _title3:TextFieldProxy;
      
      private var _text3:TextFieldProxy;
      
      public function TurretsPage(param1:IContext)
      {
         super(param1);
      }
      
      override protected function createChildren() : void
      {
         super.createChildren();
         this._header = new NPLPHeader(this);
         setTimelineChildByName("header",this._header);
         this._header.setTextFromKeys("nplp.turrets.heading","nplp.turrets.subheading");
         var _loc1_:IResourceManager = ResourceManager.getInstance();
         this._title1 = new TextFieldProxy(this);
         setTimelineChildByName("title1.template.mask.text",this._title1);
         this._title1.setText(_loc1_.getString(NewPlayerLandingConfig.LOCALIZATION_NAMESPACE,"nplp.turrets.title1"));
         this._text1 = new TextFieldProxy(this);
         setTimelineChildByName("text1.innerText",this._text1);
         this._text1.setText(_loc1_.getString(NewPlayerLandingConfig.LOCALIZATION_NAMESPACE,"nplp.turrets.text1"));
         this._title2 = new TextFieldProxy(this);
         setTimelineChildByName("title2.template.mask.text",this._title2);
         this._title2.setText(_loc1_.getString(NewPlayerLandingConfig.LOCALIZATION_NAMESPACE,"nplp.turrets.title2"));
         this._text2 = new TextFieldProxy(this);
         setTimelineChildByName("text2.innerText",this._text2);
         this._text2.setText(_loc1_.getString(NewPlayerLandingConfig.LOCALIZATION_NAMESPACE,"nplp.turrets.text2"));
         this._title3 = new TextFieldProxy(this);
         setTimelineChildByName("title3.template.mask.text",this._title3);
         this._title3.setText(_loc1_.getString(NewPlayerLandingConfig.LOCALIZATION_NAMESPACE,"nplp.turrets.title3"));
         this._text3 = new TextFieldProxy(this);
         setTimelineChildByName("text3.innerText",this._text3);
         this._text3.setText(_loc1_.getString(NewPlayerLandingConfig.LOCALIZATION_NAMESPACE,"nplp.turrets.text3"));
      }
   }
}

