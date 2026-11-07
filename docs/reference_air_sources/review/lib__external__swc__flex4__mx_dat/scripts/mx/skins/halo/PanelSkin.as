package mx.skins.halo
{
   import flash.display.GradientType;
   import flash.display.Graphics;
   import flash.utils.describeType;
   import flash.utils.getQualifiedClassName;
   import mx.core.EdgeMetrics;
   import mx.core.IContainer;
   import mx.core.IUIComponent;
   
   public class PanelSkin extends HaloBorder
   {
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") static const VERSION:String = "4.6.0.23201";
      
      private static var panels:Object = {};
      
      private var oldHeaderHeight:Number;
      
      private var oldControlBarHeight:Number;
      
      protected var _panelBorderMetrics:EdgeMetrics;
      
      public function PanelSkin()
      {
         super();
      }
      
      private static function isPanel(parent:Object) : Boolean
      {
         var xmllist:XMLList;
         var s:String = null;
         var x:XML = null;
         s = getQualifiedClassName(parent);
         if(panels[s] == 1)
         {
            return true;
         }
         if(panels[s] == 0)
         {
            return false;
         }
         if(s == "mx.containers::Panel")
         {
            panels[s] == 1;
            return true;
         }
         x = describeType(parent);
         xmllist = x.extendsClass.(@type == "mx.containers::Panel");
         if(xmllist.length() == 0)
         {
            panels[s] = 0;
            return false;
         }
         panels[s] = 1;
         return true;
      }
      
      override public function get borderMetrics() : EdgeMetrics
      {
         var newControlBarHeight:Number = NaN;
         var hasPanelParent:Boolean = isPanel(parent);
         var controlBar:IUIComponent = hasPanelParent ? Object(parent)._controlBar : null;
         var hHeight:Number = hasPanelParent ? Number(Object(parent).getHeaderHeightProxy()) : NaN;
         if(Boolean(controlBar) && Boolean(controlBar.includeInLayout))
         {
            newControlBarHeight = Number(controlBar.getExplicitOrMeasuredHeight());
         }
         if(newControlBarHeight != this.oldControlBarHeight && !(isNaN(this.oldControlBarHeight) && isNaN(newControlBarHeight)))
         {
            this._panelBorderMetrics = null;
         }
         if(hHeight != this.oldHeaderHeight && !(isNaN(hHeight) && isNaN(this.oldHeaderHeight)))
         {
            this._panelBorderMetrics = null;
         }
         if(Boolean(this._panelBorderMetrics))
         {
            return this._panelBorderMetrics;
         }
         var o:EdgeMetrics = super.borderMetrics;
         var vm:EdgeMetrics = new EdgeMetrics(0,0,0,0);
         var bt:Number = Number(getStyle("borderThickness"));
         var btl:Number = Number(getStyle("borderThicknessLeft"));
         var btt:Number = Number(getStyle("borderThicknessTop"));
         var btr:Number = Number(getStyle("borderThicknessRight"));
         var btb:Number = Number(getStyle("borderThicknessBottom"));
         vm.left = o.left + (isNaN(btl) ? bt : btl);
         vm.top = o.top + (isNaN(btt) ? bt : btt);
         vm.right = o.bottom + (isNaN(btr) ? bt : btr);
         vm.bottom = o.bottom + (isNaN(btb) ? (Boolean(controlBar) && !isNaN(btt) ? btt : (isNaN(btl) ? bt : btl)) : btb);
         this.oldHeaderHeight = hHeight;
         if(!isNaN(hHeight))
         {
            vm.top += hHeight;
         }
         this.oldControlBarHeight = newControlBarHeight;
         if(!isNaN(newControlBarHeight))
         {
            vm.bottom += newControlBarHeight;
         }
         this._panelBorderMetrics = vm;
         return this._panelBorderMetrics;
      }
      
      override public function styleChanged(styleProp:String) : void
      {
         super.styleChanged(styleProp);
         if(styleProp == null || styleProp == "styleName" || styleProp == "borderStyle" || styleProp == "borderThickness" || styleProp == "borderThicknessTop" || styleProp == "borderThicknessBottom" || styleProp == "borderThicknessLeft" || styleProp == "borderThicknessRight" || styleProp == "borderSides")
         {
            this._panelBorderMetrics = null;
         }
         invalidateDisplayList();
      }
      
      override §§namespace("http://www.adobe.com/2006/flex/mx/internal") function drawBorder(w:Number, h:Number) : void
      {
         var contentAlpha:Number = NaN;
         var backgroundAlpha:Number = NaN;
         var br:Number = NaN;
         var g:Graphics = null;
         var parentContainer:IContainer = null;
         var vm:EdgeMetrics = null;
         super.drawBorder(w,h);
         var borderStyle:String = getStyle("borderStyle");
         if(borderStyle == "default")
         {
            contentAlpha = Number(getStyle("backgroundAlpha"));
            backgroundAlpha = Number(getStyle("borderAlpha"));
            backgroundAlphaName = "borderAlpha";
            radiusObj = null;
            radius = getStyle("cornerRadius");
            bRoundedCorners = getStyle("roundedBottomCorners").toString().toLowerCase() == "true";
            br = bRoundedCorners ? radius : 0;
            g = graphics;
            drawDropShadow(0,0,w,h,radius,radius,br,br);
            if(!bRoundedCorners)
            {
               radiusObj = {};
            }
            parentContainer = parent as IContainer;
            if(Boolean(parentContainer))
            {
               vm = parentContainer.viewMetrics;
               backgroundHole = {
                  "x":vm.left,
                  "y":vm.top,
                  "w":Math.max(0,w - vm.left - vm.right),
                  "h":Math.max(0,h - vm.top - vm.bottom),
                  "r":0
               };
               if(backgroundHole.w > 0 && backgroundHole.h > 0)
               {
                  if(contentAlpha != backgroundAlpha)
                  {
                     drawDropShadow(backgroundHole.x,backgroundHole.y,backgroundHole.w,backgroundHole.h,0,0,0,0);
                  }
                  g.beginFill(Number(backgroundColor),contentAlpha);
                  g.drawRect(backgroundHole.x,backgroundHole.y,backgroundHole.w,backgroundHole.h);
                  g.endFill();
               }
            }
            backgroundColor = getStyle("borderColor");
         }
      }
      
      override §§namespace("http://www.adobe.com/2006/flex/mx/internal") function drawBackground(w:Number, h:Number) : void
      {
         var highlightAlphas:Array = null;
         var highlightAlpha:Number = NaN;
         super.drawBackground(w,h);
         if(getStyle("headerColors") == null && getStyle("borderStyle") == "default")
         {
            highlightAlphas = getStyle("highlightAlphas");
            highlightAlpha = Boolean(highlightAlphas) ? Number(highlightAlphas[0]) : 0.3;
            drawRoundRect(0,0,w,h,{
               "tl":radius,
               "tr":radius,
               "bl":0,
               "br":0
            },16777215,highlightAlpha,null,GradientType.LINEAR,null,{
               "x":0,
               "y":1,
               "w":w,
               "h":h - 1,
               "r":{
                  "tl":radius,
                  "tr":radius,
                  "bl":0,
                  "br":0
               }
            });
         }
      }
      
      override §§namespace("http://www.adobe.com/2006/flex/mx/internal") function getBackgroundColorMetrics() : EdgeMetrics
      {
         if(getStyle("borderStyle") == "default")
         {
            return EdgeMetrics.EMPTY;
         }
         return super.borderMetrics;
      }
   }
}

