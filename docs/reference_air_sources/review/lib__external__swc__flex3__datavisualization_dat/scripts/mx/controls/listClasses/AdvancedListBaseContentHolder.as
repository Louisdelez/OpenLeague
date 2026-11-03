package mx.controls.listClasses
{
   import flash.display.Graphics;
   import flash.display.Shape;
   import flash.display.Sprite;
   import mx.core.FlexShape;
   import mx.core.UIComponent;
   
   [ExcludeClass]
   [Style(name="backgroundColor",type="uint",format="Color",inherit="no")]
   [Style(name="paddingRight",type="Number",format="Length",inherit="no")]
   [Style(name="paddingLeft",type="Number",format="Length",inherit="no")]
   public class AdvancedListBaseContentHolder extends UIComponent
   {
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") static const VERSION:String = "3.0.0.0";
      
      private var parentList:AdvancedListBase;
      
      public var bottomOffset:Number = 0;
      
      public var topOffset:Number = 0;
      
      private var maskShape:Shape;
      
      public var rightOffset:Number = 0;
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") var allowItemSizeChangeNotification:Boolean = true;
      
      public var leftOffset:Number = 0;
      
      public function AdvancedListBaseContentHolder(parentList:AdvancedListBase)
      {
         super();
         this.parentList = parentList;
         setStyle("backgroundColor","");
         setStyle("borderStyle","none");
      }
      
      override public function set focusPane(value:Sprite) : void
      {
         var g:Graphics = null;
         if(Boolean(value))
         {
            if(!maskShape)
            {
               maskShape = new FlexShape();
               maskShape.name = "mask";
               g = maskShape.graphics;
               g.beginFill(16777215);
               g.drawRect(-2,-2,width + 2,height + 2);
               g.endFill();
               addChild(maskShape);
            }
            maskShape.visible = false;
            value.mask = maskShape;
         }
         else if(parentList.focusPane.mask == maskShape)
         {
            parentList.focusPane.mask = null;
         }
         parentList.focusPane = value;
         value.x = x;
         value.y = y;
      }
      
      override public function invalidateSize() : void
      {
         if(allowItemSizeChangeNotification)
         {
            parentList.invalidateList();
         }
      }
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") function getParentList() : AdvancedListBase
      {
         return parentList;
      }
      
      public function get widthExcludingOffsets() : Number
      {
         return width + leftOffset - rightOffset;
      }
      
      public function get heightExcludingOffsets() : Number
      {
         return height + topOffset - bottomOffset;
      }
      
      override protected function updateDisplayList(unscaledWidth:Number, unscaledHeight:Number) : void
      {
         super.updateDisplayList(unscaledWidth,unscaledHeight);
         if(Boolean(maskShape))
         {
            maskShape.width = unscaledWidth;
            maskShape.height = unscaledHeight;
         }
      }
   }
}

