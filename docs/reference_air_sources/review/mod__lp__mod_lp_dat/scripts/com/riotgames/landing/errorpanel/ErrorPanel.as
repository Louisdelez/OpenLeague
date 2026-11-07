package com.riotgames.landing.errorpanel
{
   import blix.assets.proxy.ErrorPanelAsset;
   import blix.assets.proxy.SpriteProxy;
   import blix.components.text.Text;
   import blix.context.IContext;
   
   public class ErrorPanel extends SpriteProxy
   {
      
      private var titleText:Text;
      
      private var errorText:Text;
      
      public function ErrorPanel(param1:IContext)
      {
         super(param1);
         setVisible(false);
      }
      
      override protected function createChildren() : void
      {
         super.createChildren();
         var _loc1_:ErrorPanelAsset = new ErrorPanelAsset();
         this.titleText = new Text(this);
         setTimelineChild(_loc1_.titleText,this.titleText);
         this.errorText = new Text(this);
         setTimelineChild(_loc1_.errorText,this.errorText);
      }
      
      public function showError(param1:String, param2:String) : void
      {
         setVisible(true);
         this.titleText.setText(param1);
         this.errorText.setText(param2);
      }
   }
}

