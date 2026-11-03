package com.riotgames.platform.gameclient.components.containers
{
   import flash.display.GradientType;
   import mx.styles.StyleManager;
   
   public class GradientCanvas extends RiotCanvas
   {
      
      private var _borderAlpha:Number;
      
      private var _borderThickness:Number;
      
      public var fillRatios:Array = null;
      
      public function GradientCanvas()
      {
         super();
      }
      
      override protected function updateDisplayList(param1:Number, param2:Number) : void
      {
         super.updateDisplayList(param1,param2);
         var _loc3_:Array = getStyle("fillColors");
         var _loc4_:Array = getStyle("fillAlphas");
         var _loc5_:Number = Number(getStyle("cornerRadius"));
         StyleManager.getColorNames(_loc3_);
         graphics.clear();
         this._borderAlpha = getStyle("borderAlpha") == undefined ? 0 : Number(getStyle("borderAlpha"));
         this._borderThickness = getStyle("borderThickness") == undefined ? 1 : Number(getStyle("borderThickness"));
         if(this._borderThickness > 0)
         {
            this.graphics.lineStyle(this._borderThickness,getStyle("borderColor"),this._borderAlpha,true);
         }
         drawRoundRect(0,0,param1,param2,_loc5_,_loc3_,_loc4_,verticalGradientMatrix(0,0,param1,param2),GradientType.LINEAR,this.fillRatios);
      }
   }
}

