package spark.skins.spark
{
   import mx.events.PropertyChangeEvent;
   import mx.graphics.BitmapFill;
   import mx.graphics.RectangularDropShadow;
   import mx.graphics.SolidColor;
   import mx.graphics.SolidColorStroke;
   import mx.states.SetProperty;
   import mx.states.State;
   import spark.components.BorderContainer;
   import spark.components.Group;
   import spark.components.supportClasses.Skin;
   import spark.primitives.Path;
   import spark.primitives.Rect;
   
   [States("disabled")]
   [HostComponent("spark.components.BorderContainer")]
   public class BorderContainerSkin extends Skin
   {
      
      private var _809612678contentGroup:Group;
      
      private var bgRect:Rect;
      
      private var insetPath:Path;
      
      private var rds:RectangularDropShadow;
      
      private var _213507019hostComponent:BorderContainer;
      
      public function BorderContainerSkin()
      {
         super();
         minWidth = 30;
         minHeight = 30;
         states = [new State({"name":"normal"}),new State({
            "name":"disabled",
            "overrides":[new SetProperty(this,"alpha",0.5)]
         })];
      }
      
      override protected function createChildren() : void
      {
         super.createChildren();
         this.bgRect = new Rect();
         addElementAt(this.bgRect,0);
         this.bgRect.left = this.bgRect.top = this.bgRect.right = this.bgRect.bottom = 0;
         this.contentGroup = new Group();
         addElement(this.contentGroup);
         this.insetPath = new Path();
         addElement(this.insetPath);
      }
      
      override protected function measure() : void
      {
         var borderSize:int = 0;
         measuredWidth = this.contentGroup.measuredWidth;
         measuredHeight = this.contentGroup.measuredHeight;
         measuredMinWidth = this.contentGroup.measuredMinWidth;
         measuredMinHeight = this.contentGroup.measuredMinHeight;
         var borderWeight:Number = Number(getStyle("borderWeight"));
         if(Boolean(this.hostComponent) && Boolean(this.hostComponent.borderStroke))
         {
            borderWeight = Number(this.hostComponent.borderStroke.weight);
         }
         if(borderWeight > 0)
         {
            borderSize = borderWeight * 2;
            measuredWidth += borderSize;
            measuredHeight += borderSize;
            measuredMinWidth += borderSize;
            measuredMinHeight += borderSize;
         }
      }
      
      override protected function updateDisplayList(unscaledWidth:Number, unscaledHeight:Number) : void
      {
         var borderWeight:int = 0;
         var borderColor:Number = NaN;
         var borderAlpha:Number = NaN;
         var bgImage:Object = null;
         var bitmapFill:BitmapFill = null;
         var bkgdColor:Number = NaN;
         var bkgdAlpha:Number = NaN;
         var negCR:Number = NaN;
         var path:String = null;
         var a:Number = NaN;
         var s:Number = NaN;
         var right:Number = NaN;
         graphics.clear();
         var borderStyle:String = getStyle("borderStyle");
         var borderVisible:Boolean = Boolean(getStyle("borderVisible"));
         var cornerRadius:Number = Number(getStyle("cornerRadius"));
         if(Boolean(this.hostComponent) && Boolean(this.hostComponent.borderStroke))
         {
            borderWeight = int(this.hostComponent.borderStroke.weight);
         }
         else
         {
            borderWeight = int(getStyle("borderWeight"));
         }
         if(!borderVisible)
         {
            borderWeight = 0;
         }
         if(isNaN(borderWeight))
         {
            borderWeight = 1;
         }
         this.contentGroup.setStyle("left",borderWeight);
         this.contentGroup.setStyle("right",borderWeight);
         this.contentGroup.setStyle("top",borderWeight);
         this.contentGroup.setStyle("bottom",borderWeight);
         if(Boolean(this.hostComponent.borderStroke))
         {
            this.bgRect.stroke = this.hostComponent.borderStroke;
         }
         else if(!borderVisible)
         {
            this.bgRect.stroke = null;
         }
         else
         {
            borderColor = Number(getStyle("borderColor"));
            borderAlpha = Number(getStyle("borderAlpha"));
            if(!isNaN(borderColor))
            {
               if(isNaN(borderAlpha))
               {
                  borderAlpha = 1;
               }
               this.bgRect.stroke = new SolidColorStroke(borderColor,borderWeight,borderAlpha);
            }
         }
         if(Boolean(this.hostComponent.backgroundFill))
         {
            this.bgRect.fill = this.hostComponent.backgroundFill;
         }
         else
         {
            bgImage = getStyle("backgroundImage");
            if(Boolean(bgImage))
            {
               bitmapFill = this.bgRect.fill is BitmapFill ? BitmapFill(this.bgRect.fill) : new BitmapFill();
               bitmapFill.source = bgImage;
               bitmapFill.fillMode = getStyle("backgroundImageFillMode");
               bitmapFill.alpha = getStyle("backgroundAlpha");
               this.bgRect.fill = bitmapFill;
            }
            else
            {
               bkgdColor = Number(getStyle("backgroundColor"));
               bkgdAlpha = Number(getStyle("backgroundAlpha"));
               if(isNaN(bkgdAlpha))
               {
                  bkgdAlpha = 1;
               }
               if(!isNaN(bkgdColor))
               {
                  this.bgRect.fill = new SolidColor(bkgdColor,bkgdAlpha);
               }
               else
               {
                  this.bgRect.fill = new SolidColor(0,0);
               }
            }
         }
         if(borderStyle == "inset" && this.hostComponent.borderStroke == null && borderVisible)
         {
            negCR = -cornerRadius;
            path = "";
            if(cornerRadius > 0 && borderWeight < 10)
            {
               a = cornerRadius * 0.292893218813453;
               s = cornerRadius * 0.585786437626905;
               right = unscaledWidth - borderWeight;
               path += "M 0 " + cornerRadius;
               path += " Q 0 " + s + " " + a + " " + a;
               path += " Q " + s + " 0 " + cornerRadius + " 0";
               path += " L " + (right - cornerRadius) + " 0";
               path += " Q " + (right - s) + " 0 " + (right - a) + " " + a;
               path += " Q " + right + " " + s + " " + right + " " + cornerRadius;
               this.insetPath.height = cornerRadius;
            }
            else
            {
               path += "M 0 0";
               path += " L " + (unscaledWidth - borderWeight) + " 0";
               this.insetPath.height = 1;
            }
            this.insetPath.x = borderWeight;
            this.insetPath.y = borderWeight;
            this.insetPath.width = unscaledWidth - borderWeight * 2;
            this.insetPath.data = path;
            this.insetPath.stroke = new SolidColorStroke(0,1,0.12);
         }
         else
         {
            this.insetPath.data = "";
            this.insetPath.stroke = null;
         }
         this.bgRect.radiusX = this.bgRect.radiusY = cornerRadius;
         super.updateDisplayList(unscaledWidth,unscaledHeight);
         if(getStyle("dropShadowVisible") == true)
         {
            if(!this.rds)
            {
               this.rds = new RectangularDropShadow();
            }
            this.rds.alpha = 0.4;
            this.rds.angle = 90;
            this.rds.color = 0;
            this.rds.distance = 5;
            this.rds.tlRadius = this.rds.trRadius = this.rds.blRadius = this.rds.brRadius = cornerRadius + 1;
            graphics.lineStyle();
            this.rds.drawShadow(graphics,0,0,unscaledWidth,unscaledHeight);
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get contentGroup() : Group
      {
         return this._809612678contentGroup;
      }
      
      public function set contentGroup(param1:Group) : void
      {
         var _loc2_:Object = this._809612678contentGroup;
         if(_loc2_ !== param1)
         {
            this._809612678contentGroup = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"contentGroup",_loc2_,param1));
            }
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get hostComponent() : BorderContainer
      {
         return this._213507019hostComponent;
      }
      
      public function set hostComponent(param1:BorderContainer) : void
      {
         var _loc2_:Object = this._213507019hostComponent;
         if(_loc2_ !== param1)
         {
            this._213507019hostComponent = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"hostComponent",_loc2_,param1));
            }
         }
      }
   }
}

