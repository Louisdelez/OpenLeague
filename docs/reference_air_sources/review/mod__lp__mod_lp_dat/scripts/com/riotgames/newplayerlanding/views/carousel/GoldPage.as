package com.riotgames.newplayerlanding.views.carousel
{
   import blix.assets.proxy.SpriteProxy;
   import blix.assets.proxy.TextFieldProxy;
   import blix.context.IContext;
   import com.riotgames.newplayerlanding.NewPlayerLandingConfig;
   import mx.resources.IResourceManager;
   import mx.resources.ResourceManager;
   
   public class GoldPage extends SpriteProxy
   {
      
      private var _header:NPLPHeader;
      
      private var _minionsTitle:TextFieldProxy;
      
      private var _minionsText:TextFieldProxy;
      
      private var _monstersTitle:TextFieldProxy;
      
      private var _monstersText:TextFieldProxy;
      
      private var _championsTitle:TextFieldProxy;
      
      private var _championsText:TextFieldProxy;
      
      private var _turretsTitle:TextFieldProxy;
      
      private var _turretsText:TextFieldProxy;
      
      public function GoldPage(param1:IContext)
      {
         super(param1);
      }
      
      override protected function createChildren() : void
      {
         super.createChildren();
         this._header = new NPLPHeader(this);
         setTimelineChildByName("header",this._header);
         this._header.setTextFromKeys("nplp.gold.heading","nplp.gold.subheading");
         var _loc1_:IResourceManager = ResourceManager.getInstance();
         this._minionsTitle = new TextFieldProxy(this);
         setTimelineChildByName("minionsTitle.template.mask.text",this._minionsTitle);
         this._minionsTitle.setText(_loc1_.getString(NewPlayerLandingConfig.LOCALIZATION_NAMESPACE,"nplp.gold.minionstitle"));
         this._minionsText = new TextFieldProxy(this);
         setTimelineChildByName("minionsText.innerText",this._minionsText);
         this._minionsText.setText(_loc1_.getString(NewPlayerLandingConfig.LOCALIZATION_NAMESPACE,"nplp.gold.minionstext"));
         this._monstersTitle = new TextFieldProxy(this);
         setTimelineChildByName("monstersTitle.template.mask.text",this._monstersTitle);
         this._monstersTitle.setText(_loc1_.getString(NewPlayerLandingConfig.LOCALIZATION_NAMESPACE,"nplp.gold.monsterstitle"));
         this._monstersText = new TextFieldProxy(this);
         setTimelineChildByName("monstersText.innerText",this._monstersText);
         this._monstersText.setText(_loc1_.getString(NewPlayerLandingConfig.LOCALIZATION_NAMESPACE,"nplp.gold.monsterstext"));
         this._championsTitle = new TextFieldProxy(this);
         setTimelineChildByName("championsTitle.template.mask.text",this._championsTitle);
         this._championsTitle.setText(_loc1_.getString(NewPlayerLandingConfig.LOCALIZATION_NAMESPACE,"nplp.gold.championstitle"));
         this._championsText = new TextFieldProxy(this);
         setTimelineChildByName("championsText.innerText",this._championsText);
         this._championsText.setText(_loc1_.getString(NewPlayerLandingConfig.LOCALIZATION_NAMESPACE,"nplp.gold.championstext"));
         this._turretsTitle = new TextFieldProxy(this);
         setTimelineChildByName("turretsTitle.template.mask.text",this._turretsTitle);
         this._turretsTitle.setText(_loc1_.getString(NewPlayerLandingConfig.LOCALIZATION_NAMESPACE,"nplp.gold.turretstitle"));
         this._turretsText = new TextFieldProxy(this);
         setTimelineChildByName("turretsText.innerText",this._turretsText);
         this._turretsText.setText(_loc1_.getString(NewPlayerLandingConfig.LOCALIZATION_NAMESPACE,"nplp.gold.turretstext"));
      }
   }
}

