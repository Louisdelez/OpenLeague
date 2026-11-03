package com.riotgames.pvpnet.cap.views.components
{
   import blix.assets.proxy.SpriteProxy;
   import blix.components.timeline.StatefulView;
   import blix.context.IContext;
   
   public class CapPanel extends StatefulView
   {
      
      private var header:CapHeader;
      
      private var background:SpriteProxy;
      
      public function CapPanel(param1:IContext)
      {
         super(param1);
         setLinkage("GroupFinderPanel");
      }
      
      public function set title(param1:String) : void
      {
         if(this.header.title == null)
         {
            throw new Error("Unable to set title - panel not initialized");
         }
         this.header.title = param1;
      }
      
      public function get title() : String
      {
         return this.header != null ? this.header.title : "";
      }
      
      override protected function createChildren() : void
      {
         super.createChildren();
         this.background = new SpriteProxy(this);
         setTimelineChildByName("panel",this.background);
         this.header = new CapHeader(this);
         setTimelineChildByName("header",this.header);
         this.header.title = this.title;
      }
   }
}

