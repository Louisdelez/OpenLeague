package com.riotgames.platform.gameclient.components.list
{
   import mx.controls.listClasses.ListBase;
   import mx.controls.listClasses.ListItemRenderer;
   import mx.core.UITextField;
   import mx.styles.StyleManager;
   
   public class GradientRollOverList extends ListItemRenderer
   {
      
      private var listOwner:ListBase;
      
      public function GradientRollOverList()
      {
         super();
      }
      
      protected function drawGradientBackground(param1:Array) : void
      {
         var _loc2_:Array = getStyle("fillAlphas");
         var _loc3_:Number = Number(getStyle("cornerRadius"));
         StyleManager.getColorNames(param1);
         graphics.clear();
         drawRoundRect(-3,-3,unscaledWidth + 5,unscaledHeight + 5,_loc3_,param1,_loc2_,horizontalGradientMatrix(0,0,unscaledWidth,unscaledHeight));
      }
      
      override protected function updateDisplayList(param1:Number, param2:Number) : void
      {
         var _loc3_:Array = null;
         var _loc4_:UITextField = null;
         super.updateDisplayList(param1,param2);
         if(Boolean(data) && Boolean(parent))
         {
            this.listOwner = ListBase(listData.owner);
            _loc4_ = this.label as UITextField;
            if(enabled)
            {
               if(this.listOwner.isItemHighlighted(listData.uid))
               {
                  _loc3_ = getStyle("fillColors");
                  this.drawGradientBackground(_loc3_);
                  _loc4_.setStyle("fontWeight","normal");
               }
               else if(this.listOwner.isItemSelected(listData.uid))
               {
                  _loc3_ = getStyle("fillColors");
                  this.drawGradientBackground(_loc3_);
               }
               else
               {
                  _loc3_ = ["#000000"];
                  this.drawGradientBackground(_loc3_);
                  _loc4_.setStyle("fontWeight","normal");
               }
            }
         }
      }
   }
}

