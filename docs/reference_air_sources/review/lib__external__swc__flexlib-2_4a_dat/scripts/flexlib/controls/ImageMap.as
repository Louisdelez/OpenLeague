package flexlib.controls
{
   import flash.display.Graphics;
   import flash.events.MouseEvent;
   import flexlib.events.ImageMapEvent;
   import mx.controls.Image;
   import mx.core.UIComponent;
   import mx.styles.CSSStyleDeclaration;
   import mx.styles.StyleManager;
   
   [IconFile("ImageMap.png")]
   [Event(name="shapeUp",type="flexlib.events.ImageMapEvent")]
   [Event(name="shapeDown",type="flexlib.events.ImageMapEvent")]
   [Event(name="shapeOut",type="flexlib.events.ImageMapEvent")]
   [Event(name="shapeOver",type="flexlib.events.ImageMapEvent")]
   [Event(name="shapeDoubleClick",type="flexlib.events.ImageMapEvent")]
   [Event(name="shapeClick",type="flexlib.events.ImageMapEvent")]
   [Style(name="fillAlpha",type="Number",format="Length",inherit="no")]
   [Style(name="fillColor",type="uint",format="Color",inherit="no")]
   [Style(name="outlineAlpha",type="Number",format="Length",inherit="no")]
   [Style(name="outlineColor",type="uint",format="Color",inherit="no")]
   [Style(name="outlineThickness",type="Number",format="Length",inherit="no")]
   public class ImageMap extends Image
   {
      
      private static var stylesInitialised:Boolean = initStyles();
      
      private var _map:Array;
      
      private var areaHolder:UIComponent;
      
      public var toolTipField:String = "alt";
      
      public var showToolTips:Boolean = false;
      
      public function ImageMap()
      {
         super();
      }
      
      private static function initStyles() : Boolean
      {
         var sd:CSSStyleDeclaration = null;
         sd = StyleManager.getStyleDeclaration("ImageMap");
         if(!sd)
         {
            sd = new CSSStyleDeclaration();
            StyleManager.setStyleDeclaration("ImageMap",sd,false);
         }
         sd.defaultFactory = function():void
         {
            this.outlineColor = 16711680;
            this.outlineAlpha = 1;
            this.outlineThickness = 1;
            this.fillColor = 16711680;
            this.fillAlpha = 0;
         };
         return true;
      }
      
      private function sprite_clickHandler(event:MouseEvent) : void
      {
         var sprite:UIComponent = null;
         sprite = event.currentTarget as UIComponent;
         doDispatchEvent(sprite,ImageMapEvent.SHAPE_CLICK);
      }
      
      public function get map() : Array
      {
         return _map;
      }
      
      private function sprite_overHandler(event:MouseEvent) : void
      {
         var sprite:UIComponent = null;
         sprite = event.currentTarget as UIComponent;
         doDispatchEvent(sprite,ImageMapEvent.SHAPE_OVER);
      }
      
      private function sprite_downHandler(event:MouseEvent) : void
      {
         var sprite:UIComponent = null;
         sprite = event.currentTarget as UIComponent;
         doDispatchEvent(sprite,ImageMapEvent.SHAPE_DOWN);
      }
      
      private function sprite_dblclickHandler(event:MouseEvent) : void
      {
         var sprite:UIComponent = null;
         sprite = event.currentTarget as UIComponent;
         doDispatchEvent(sprite,ImageMapEvent.SHAPE_DOUBLECLICK);
      }
      
      private function sprite_outHandler(event:MouseEvent) : void
      {
         var sprite:UIComponent = null;
         sprite = event.currentTarget as UIComponent;
         doDispatchEvent(sprite,ImageMapEvent.SHAPE_OUT);
      }
      
      public function set map(value:Array) : void
      {
         _map = value;
         invalidateDisplayList();
      }
      
      private function removeChildren() : void
      {
         while(areaHolder.numChildren > 0)
         {
            areaHolder.removeChildAt(0);
         }
      }
      
      override protected function createChildren() : void
      {
         super.createChildren();
         areaHolder = new UIComponent();
         this.addChild(areaHolder);
      }
      
      private function drawPoly(g:Graphics, coords:Array) : void
      {
         var i:int = 0;
         g.moveTo(coords[0],coords[1]);
         for(i = 2; i < coords.length; i += 2)
         {
            g.lineTo(coords[i],coords[i + 1]);
         }
         g.lineTo(coords[0],coords[1]);
      }
      
      private function sprite_upHandler(event:MouseEvent) : void
      {
         var sprite:UIComponent = null;
         sprite = event.currentTarget as UIComponent;
         doDispatchEvent(sprite,ImageMapEvent.SHAPE_UP);
      }
      
      private function drawShapes() : void
      {
         var outlineThickness:Number = NaN;
         var outlineColor:uint = 0;
         var outlineAlpha:Number = NaN;
         var fillColor:uint = 0;
         var fillAlpha:Number = NaN;
         var item:area = null;
         var shape:String = null;
         var coords:Array = null;
         var sprite:UIComponent = null;
         var g:Graphics = null;
         removeChildren();
         outlineThickness = Number(getStyle("outlineThickness"));
         outlineColor = uint(getStyle("outlineColor"));
         outlineAlpha = Number(getStyle("outlineAlpha"));
         fillColor = uint(getStyle("fillColor"));
         fillAlpha = Number(getStyle("fillAlpha"));
         for each(item in _map)
         {
            shape = item.shape;
            coords = item.coords.split(",");
            sprite = new UIComponent();
            sprite.addEventListener(MouseEvent.CLICK,sprite_clickHandler,false,0,true);
            sprite.addEventListener(MouseEvent.DOUBLE_CLICK,sprite_dblclickHandler,false,0,true);
            sprite.addEventListener(MouseEvent.MOUSE_DOWN,sprite_downHandler,false,0,true);
            sprite.addEventListener(MouseEvent.MOUSE_OUT,sprite_outHandler,false,0,true);
            sprite.addEventListener(MouseEvent.MOUSE_OVER,sprite_overHandler,false,0,true);
            sprite.addEventListener(MouseEvent.MOUSE_UP,sprite_upHandler,false,0,true);
            sprite.useHandCursor = this.useHandCursor;
            sprite.buttonMode = true;
            if(showToolTips)
            {
               sprite.toolTip = item[toolTipField];
            }
            g = sprite.graphics;
            g.lineStyle(outlineThickness,outlineColor,outlineAlpha);
            g.beginFill(fillColor,fillAlpha);
            switch(shape.toLowerCase())
            {
               case "rect":
                  g.drawRect(coords[0],coords[1],coords[2] - coords[0],coords[3] - coords[1]);
                  break;
               case "poly":
                  drawPoly(g,coords);
                  break;
               case "circle":
                  g.drawCircle(coords[0],coords[1],coords[2]);
            }
            g.endFill();
            areaHolder.addChild(sprite);
         }
      }
      
      private function doDispatchEvent(sprite:UIComponent, type:String) : void
      {
         var index:int = 0;
         var item:area = null;
         var target:String = null;
         var href:String = null;
         if(sprite.parent != areaHolder)
         {
            return;
         }
         index = int(areaHolder.getChildIndex(sprite));
         item = _map[index];
         target = "";
         if(Boolean(item.target))
         {
            target = item.target;
         }
         href = "";
         if(Boolean(item.href))
         {
            href = item.href;
         }
         dispatchEvent(new ImageMapEvent(type,false,false,href,item,target));
      }
      
      override protected function updateDisplayList(unscaledWidth:Number, unscaledHeight:Number) : void
      {
         super.updateDisplayList(unscaledWidth,unscaledHeight);
         if(Boolean(contentHolder))
         {
            areaHolder.scaleX = contentHolder.scaleX;
            areaHolder.scaleY = contentHolder.scaleY;
            areaHolder.scrollRect = contentHolder.scrollRect;
         }
         drawShapes();
         setChildIndex(areaHolder,numChildren - 1);
      }
   }
}

