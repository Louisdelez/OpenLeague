package com.riotgames.platform.gameclient.components.containers
{
   import flash.display.Graphics;
   import mx.containers.Canvas;
   import mx.core.FlexShape;
   
   [Style(name="whiteBoxImage",type="String",inherit="no")]
   [Style(name="whiteBoxAlpha",type="Number",inherit="no",defaultValue="1")]
   [Style(name="whiteBoxColor",type="int",inherit="no",defaultValue="0xFFFFFF")]
   [Style(name="whiteBoxEnabled",type="Boolean",inherit="no",defaultValue="false")]
   public class RiotCanvas extends Canvas
   {
      
      private static const WHITEBOX_NAME:String = "RIOT_WHITEBOX";
      
      public function RiotCanvas()
      {
         super();
      }
      
      override public function validateDisplayList() : void
      {
         var _loc1_:Boolean = false;
         var _loc2_:Graphics = null;
         super.validateDisplayList();
         if(Boolean(whiteBox) && Boolean(rawChildren.contains(whiteBox)))
         {
            _loc1_ = Boolean(this.getStyle("whiteBoxEnabled"));
            if(!_loc1_ && Boolean(whiteBox))
            {
               rawChildren.removeChild(whiteBox);
               return;
            }
            if(whiteBox.name != WHITEBOX_NAME)
            {
               rawChildren.removeChild(whiteBox);
               whiteBox = new FlexShape();
               whiteBox.name = WHITEBOX_NAME;
               _loc2_ = whiteBox.graphics;
               _loc2_.beginFill(this.getStyle("whiteBoxColor"),this.getStyle("whiteBoxAlpha"));
               _loc2_.drawRect(0,0,verticalScrollBar.minWidth,horizontalScrollBar.minHeight);
               _loc2_.endFill();
               rawChildren.addChild(whiteBox);
            }
         }
      }
      
      override protected function updateDisplayList(param1:Number, param2:Number) : void
      {
         super.updateDisplayList(param1,param2);
      }
   }
}

