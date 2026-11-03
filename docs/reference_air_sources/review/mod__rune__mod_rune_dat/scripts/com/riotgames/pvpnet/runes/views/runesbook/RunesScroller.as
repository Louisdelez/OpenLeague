package com.riotgames.pvpnet.runes.views.runesbook
{
   import blix.components.scroll.ScrollArea;
   import blix.components.scroll.ScrollPolicy;
   import blix.context.IContext;
   import flash.display.DisplayObject;
   
   public class RunesScroller extends ScrollArea
   {
      
      public function RunesScroller(param1:IContext)
      {
         super(param1);
         setKineticScrolling(false);
         setVScrollPolicy(ScrollPolicy.ON);
         setMouseWheelEnabled(true);
      }
      
      override public function setAsset(param1:DisplayObject) : void
      {
         var _loc2_:DisplayObject = null;
         super.setAsset(param1);
         if(_containerAsset)
         {
            _loc2_ = _containerAsset.getChildByName("scrollAreaSizer");
            setExplicitSize(_loc2_.width,_loc2_.height);
         }
      }
      
      override protected function createChildren() : void
      {
         _contents = new RunesAccordionView(this);
         setTimelineChildByName("contents",_contents);
         super.createChildren();
      }
   }
}

