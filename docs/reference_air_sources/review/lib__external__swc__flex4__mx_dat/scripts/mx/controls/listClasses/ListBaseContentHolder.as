package mx.controls.listClasses
{
   import flash.display.Graphics;
   import flash.display.Shape;
   import flash.display.Sprite;
   import mx.collections.IViewCursor;
   import mx.core.FlexShape;
   import mx.core.FlexSprite;
   import mx.core.UIComponent;
   
   [Style(name="backgroundColor",type="uint",format="Color",inherit="no")]
   [Style(name="paddingRight",type="Number",format="Length",inherit="no")]
   [Style(name="paddingLeft",type="Number",format="Length",inherit="no")]
   public class ListBaseContentHolder extends UIComponent
   {
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") static const VERSION:String = "4.6.0.23201";
      
      public var selectionLayer:Sprite;
      
      public var visibleData:Object = {};
      
      public var listItems:Array = [];
      
      public var rowInfo:Array = [];
      
      public var iterator:IViewCursor;
      
      private var parentList:ListBase;
      
      private var maskShape:Shape;
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") var allowItemSizeChangeNotification:Boolean = true;
      
      public var leftOffset:Number = 0;
      
      public var topOffset:Number = 0;
      
      public var rightOffset:Number = 0;
      
      public var bottomOffset:Number = 0;
      
      public function ListBaseContentHolder(parentList:ListBase)
      {
         var g:Graphics = null;
         super();
         this.parentList = parentList;
         setStyle("backgroundColor","");
         setStyle("borderStyle","none");
         setStyle("borderSkin",null);
         if(!this.selectionLayer)
         {
            this.selectionLayer = new FlexSprite();
            this.selectionLayer.name = "selectionLayer";
            this.selectionLayer.mouseEnabled = false;
            addChild(this.selectionLayer);
            g = this.selectionLayer.graphics;
            g.beginFill(0,0);
            g.drawRect(0,0,10,10);
            g.endFill();
         }
      }
      
      override public function set focusPane(value:Sprite) : void
      {
         var g:Graphics = null;
         if(Boolean(value))
         {
            if(!this.maskShape)
            {
               this.maskShape = new FlexShape();
               this.maskShape.name = "mask";
               g = this.maskShape.graphics;
               g.beginFill(16777215);
               g.drawRect(-2,-2,this.parentList.width + 2,this.parentList.height + 2);
               g.endFill();
               addChild(this.maskShape);
            }
            this.maskShape.visible = false;
            value.mask = this.maskShape;
         }
         else if(this.parentList.focusPane.mask == this.maskShape)
         {
            this.parentList.focusPane.mask = null;
         }
         this.parentList.focusPane = value;
         value.x = x;
         value.y = y;
      }
      
      override public function invalidateSize() : void
      {
         if(this.allowItemSizeChangeNotification)
         {
            this.parentList.invalidateList();
         }
      }
      
      override protected function updateDisplayList(unscaledWidth:Number, unscaledHeight:Number) : void
      {
         super.updateDisplayList(unscaledWidth,unscaledHeight);
         var g:Graphics = this.selectionLayer.graphics;
         g.clear();
         if(unscaledWidth > 0 && unscaledHeight > 0)
         {
            g.beginFill(8421504,0);
            g.drawRect(0,0,unscaledWidth,unscaledHeight);
            g.endFill();
         }
         if(Boolean(this.maskShape))
         {
            this.maskShape.width = unscaledWidth;
            this.maskShape.height = unscaledHeight;
         }
      }
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") function getParentList() : ListBase
      {
         return this.parentList;
      }
      
      public function get heightExcludingOffsets() : Number
      {
         return height + this.topOffset - this.bottomOffset;
      }
      
      public function get widthExcludingOffsets() : Number
      {
         return width + this.leftOffset - this.rightOffset;
      }
   }
}

