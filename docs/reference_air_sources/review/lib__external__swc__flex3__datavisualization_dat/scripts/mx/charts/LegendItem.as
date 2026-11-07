package mx.charts
{
   import flash.display.DisplayObject;
   import flash.geom.Rectangle;
   import mx.charts.chartClasses.IChartElement;
   import mx.charts.renderers.BoxItemRenderer;
   import mx.charts.styles.HaloDefaults;
   import mx.core.IDataRenderer;
   import mx.core.IFactory;
   import mx.core.IFlexDisplayObject;
   import mx.core.IUITextField;
   import mx.core.UIComponent;
   import mx.core.UITextField;
   import mx.graphics.SolidColor;
   import mx.styles.CSSStyleDeclaration;
   import mx.styles.ISimpleStyleClient;
   
   [Style(name="stroke",type="Object",inherit="no")]
   [Style(name="legendMarkerRenderer",type="mx.core.IFactory",inherit="no")]
   [Style(name="markerWidth",type="Number",format="Length",inherit="yes")]
   [Style(name="markerHeight",type="Number",format="Length",inherit="yes")]
   [Style(name="labelPlacement",type="String",enumeration="top,bottom,right,left",inherit="yes")]
   [Style(name="fill",type="Object",inherit="no")]
   [Style(name="textIndent",type="Number",format="Length",inherit="yes")]
   [Style(name="textDecoration",type="String",enumeration="none,underline",inherit="yes")]
   [Style(name="textAlign",type="String",enumeration="left,center,right",inherit="yes")]
   [Style(name="letterSpacing",type="Number",inherit="yes")]
   [Style(name="kerning",type="Boolean",inherit="yes")]
   [Style(name="fontWeight",type="String",enumeration="normal,bold",inherit="yes")]
   [Style(name="fontThickness",type="Number",inherit="yes")]
   [Style(name="fontStyle",type="String",enumeration="normal,italic",inherit="yes")]
   [Style(name="fontSize",type="Number",format="Length",inherit="yes")]
   [Style(name="fontSharpness",type="Number",inherit="yes")]
   [Style(name="fontGridFitType",type="String",enumeration="none,pixel,subpixel",inherit="yes")]
   [Style(name="fontFamily",type="String",inherit="yes")]
   [Style(name="fontAntiAliasType",type="String",enumeration="normal,advanced",inherit="yes")]
   [Style(name="disabledColor",type="uint",format="Color",inherit="yes")]
   [Style(name="color",type="uint",format="Color",inherit="yes")]
   [Style(name="paddingRight",type="Number",format="Length",inherit="no")]
   [Style(name="paddingLeft",type="Number",format="Length",inherit="no")]
   [Style(name="verticalGap",type="Number",format="Length",inherit="no")]
   [Style(name="horizontalGap",type="Number",format="Length",inherit="no")]
   public class LegendItem extends UIComponent
   {
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") static const VERSION:String = "3.0.0.0";
      
      private static var stylesInited:Boolean = initStyles();
      
      private var _marker:IFlexDisplayObject;
      
      private var labelChanged:Boolean = false;
      
      private var nameLabel:IUITextField;
      
      private var _label:String = "";
      
      private var _legendData:Object;
      
      [Inspectable(category="General")]
      public var markerAspectRatio:Number;
      
      [Inspectable(environment="none")]
      public var element:IChartElement;
      
      public function LegendItem()
      {
         super();
      }
      
      private static function initStyles() : Boolean
      {
         var o:CSSStyleDeclaration;
         HaloDefaults.init();
         o = HaloDefaults.createSelector("LegendItem");
         o.defaultFactory = function():void
         {
            this.fill = new SolidColor(0);
            this.fontWeight = "bold";
            this.fontSize = 10;
         };
         return true;
      }
      
      override public function styleChanged(styleProp:String) : void
      {
         invalidateDisplayList();
      }
      
      [Inspectable(environment="none")]
      public function get source() : Object
      {
         return element;
      }
      
      override protected function measure() : void
      {
         super.measure();
         var txt:String = _label;
         var labelPlacement:String = getStyle("labelPlacement");
         if(labelPlacement == "" && Boolean(parent))
         {
            labelPlacement = UIComponent(parent).getStyle("labelPlacement");
         }
         var itemW:Number = 0;
         var itemH:Number = 0;
         if(txt == null || txt == "" || txt.length < 2)
         {
            txt = "Wj";
         }
         if(labelChanged)
         {
            labelChanged = false;
            nameLabel.htmlText = _label;
         }
         var textW:Number = nameLabel.textWidth + UITextField.TEXT_WIDTH_PADDING;
         var textH:Number = nameLabel.textHeight + UITextField.TEXT_HEIGHT_PADDING;
         if(isNaN(textW))
         {
            textW = 0;
         }
         if(isNaN(textH))
         {
            textH = 0;
         }
         if(textW > 0 || getMarkerWidth() > 0)
         {
            itemW += getStyle("paddingLeft") + getStyle("paddingRight");
            itemH += getStyle("paddingTop") + getStyle("paddingBottom");
            if(labelPlacement == "top" || labelPlacement == "bottom")
            {
               itemW += Math.max(textW,getMarkerWidth());
               itemH += getStyle("verticalGap") + getMarkerHeight() + textH;
            }
            else
            {
               itemW += getStyle("horizontalGap") + getMarkerWidth() + textW;
               itemH += Math.max(textH,getMarkerHeight());
            }
         }
         measuredWidth = itemW;
         measuredHeight = itemH;
         nameLabel.setActualSize(getExplicitOrMeasuredWidth(),measuredHeight);
      }
      
      override protected function createChildren() : void
      {
         nameLabel = IUITextField(createInFontContext(UITextField));
         nameLabel.selectable = false;
         nameLabel.styleName = this;
         addChild(DisplayObject(nameLabel));
         super.createChildren();
         if(!nameLabel)
         {
            nameLabel = IUITextField(createInFontContext(UITextField));
            nameLabel.selectable = false;
            nameLabel.styleName = this;
            addChild(DisplayObject(nameLabel));
         }
      }
      
      public function set label(value:String) : void
      {
         _label = value;
         labelChanged = true;
         invalidateSize();
         invalidateDisplayList();
      }
      
      [Inspectable(environment="none")]
      public function set legendData(value:Object) : void
      {
         _legendData = value;
         if(_marker is IDataRenderer)
         {
            (_marker as IDataRenderer).data = _legendData;
         }
      }
      
      [Inspectable(category="General")]
      public function get label() : String
      {
         return _label;
      }
      
      override protected function updateDisplayList(unscaledWidth:Number, unscaledHeight:Number) : void
      {
         var cx:Number = NaN;
         var availableAR:Number = NaN;
         var markerClass:IFactory = null;
         super.updateDisplayList(unscaledWidth,unscaledHeight);
         var labelPlacement:String = getStyle("labelPlacement");
         var labelX:Number = 0;
         var labelY:Number = 0;
         var markerX:Number = 0;
         var markerY:Number = 0;
         var paddingLeft:Number = Number(getStyle("paddingLeft"));
         var paddingRight:Number = Number(getStyle("paddingRight"));
         var paddingTop:Number = Number(getStyle("paddingTop"));
         var mAvailableWidth:Number = getMarkerWidth();
         var mAvailableHeight:Number = getMarkerHeight();
         var markerH:Number = mAvailableHeight;
         var markerW:Number = mAvailableWidth;
         var txt:String = _label;
         if(txt == null || txt.length < 2)
         {
            txt = "Wj";
         }
         if(labelChanged)
         {
            labelChanged = false;
            nameLabel.text = _label;
         }
         var textW:Number = nameLabel.textWidth + UITextField.TEXT_WIDTH_PADDING;
         var textH:Number = nameLabel.textHeight + UITextField.TEXT_HEIGHT_PADDING;
         if(isNaN(textW))
         {
            textW = 0;
         }
         if(isNaN(textH))
         {
            textH = 0;
         }
         switch(labelPlacement)
         {
            case "top":
               labelY = paddingTop;
               markerY = labelY + getStyle("verticalGap") + textH;
               cx = paddingLeft + (unscaledWidth - paddingLeft - paddingRight) / 2;
               labelX = cx - textW / 2;
               markerX = cx - markerW / 2;
               break;
            case "bottom":
               markerY = paddingTop;
               labelY = markerY + getStyle("verticalGap") + markerH;
               cx = paddingLeft + (unscaledWidth - paddingLeft - paddingRight) / 2;
               labelX = cx - textW / 2;
               markerX = cx - markerW / 2;
               break;
            case "left":
               markerX = unscaledWidth - markerW - paddingRight;
               labelX = markerX - getStyle("horizontalGap") - textW;
               labelY = markerY = paddingTop;
               if(textH < markerH)
               {
                  labelY += (markerH - textH) / 2;
               }
               else
               {
                  markerY += (textH - markerH) / 2;
               }
               break;
            default:
               markerX = paddingLeft;
               labelX = markerX + getStyle("horizontalGap") + markerW;
               markerY = labelY = paddingTop;
               if(markerH < textH)
               {
                  markerY += (textH - markerH) / 2;
               }
               else
               {
                  labelY += (markerH - textH) / 2;
               }
         }
         nameLabel.move(labelX,labelY);
         if(!isNaN(markerAspectRatio))
         {
            availableAR = markerW / markerH;
            if(availableAR > markerAspectRatio)
            {
               markerW = markerAspectRatio * markerH;
            }
            else
            {
               markerH = markerW / markerAspectRatio;
            }
         }
         var rc:Rectangle = new Rectangle((mAvailableWidth - markerW) / 2,(mAvailableHeight - markerH) / 2,markerW,markerH);
         if(!_marker)
         {
            markerClass = getStyle("legendMarkerRenderer");
            if(Boolean(markerClass))
            {
               marker = markerClass.newInstance();
            }
            else
            {
               marker = new BoxItemRenderer();
            }
            if(_marker is ISimpleStyleClient)
            {
               (_marker as ISimpleStyleClient).styleName = !element ? this : element;
            }
         }
         _marker.x = markerX + (mAvailableWidth - markerW) / 2;
         _marker.y = markerY + (mAvailableHeight - markerH) / 2;
         _marker.setActualSize(markerW,markerH);
      }
      
      [Inspectable]
      public function get marker() : IFlexDisplayObject
      {
         return _marker;
      }
      
      public function set marker(value:IFlexDisplayObject) : void
      {
         if(Boolean(_marker))
         {
            removeChild(_marker as DisplayObject);
         }
         _marker = value;
         if(Boolean(_marker))
         {
            addChild(_marker as DisplayObject);
         }
         if(_marker is IDataRenderer)
         {
            (_marker as IDataRenderer).data = _legendData;
         }
         invalidateDisplayList();
      }
      
      private function getMarkerWidth() : Number
      {
         var out:Number = Number(getStyle("markerWidth"));
         if(isNaN(out))
         {
            out = 10;
         }
         return out;
      }
      
      private function getMarkerHeight() : Number
      {
         var out:Number = Number(getStyle("markerHeight"));
         if(isNaN(out))
         {
            out = 15;
         }
         return out;
      }
   }
}

