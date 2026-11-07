package com.riotgames.newplayerlanding.views.carousel
{
   import blix.assets.proxy.SpriteProxy;
   import blix.assets.proxy.TextFieldProxy;
   import blix.context.IContext;
   import com.riotgames.newplayerlanding.NewPlayerLandingConfig;
   import mx.resources.IResourceManager;
   import mx.resources.ResourceManager;
   
   public class NPLPHeader extends SpriteProxy
   {
      
      private var _headingText:TextFieldProxy;
      
      private var _subHeadingText:TextFieldProxy;
      
      public function NPLPHeader(param1:IContext)
      {
         super(param1);
      }
      
      override protected function createChildren() : void
      {
         this._headingText = new TextFieldProxy(this);
         setTimelineChildByName("headingText.template.mask.text",this._headingText);
         this._subHeadingText = new TextFieldProxy(this);
         setTimelineChildByName("subHeadingText.innerText",this._subHeadingText);
         super.createChildren();
      }
      
      public function setTextFromKeys(param1:String, param2:String) : void
      {
         var _loc3_:IResourceManager = ResourceManager.getInstance();
         this._headingText.setText(_loc3_.getString(NewPlayerLandingConfig.LOCALIZATION_NAMESPACE,param1));
         this._subHeadingText.setText(_loc3_.getString(NewPlayerLandingConfig.LOCALIZATION_NAMESPACE,param2));
      }
   }
}

