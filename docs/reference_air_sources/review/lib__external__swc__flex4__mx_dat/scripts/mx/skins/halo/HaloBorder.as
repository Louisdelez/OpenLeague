package mx.skins.halo
{
   import flash.display.GradientType;
   import flash.display.Graphics;
   import mx.core.EdgeMetrics;
   import mx.core.IUIComponent;
   import mx.graphics.RectangularDropShadow;
   import mx.skins.RectangularBorder;
   import mx.styles.IStyleClient;
   import mx.utils.ColorUtil;
   
   public class HaloBorder extends RectangularBorder
   {
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") static const VERSION:String = "4.6.0.23201";
      
      private static var BORDER_WIDTHS:Object = {
         "none":0,
         "solid":1,
         "inset":2,
         "outset":2,
         "alert":3,
         "dropdown":2,
         "menuBorder":1,
         "comboNonEdit":2
      };
      
      private var dropShadow:RectangularDropShadow;
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") var backgroundColor:Object;
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") var backgroundAlphaName:String;
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") var backgroundHole:Object;
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") var bRoundedCorners:Boolean;
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") var radius:Number;
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") var radiusObj:Object;
      
      protected var _borderMetrics:EdgeMetrics;
      
      public function HaloBorder()
      {
         super();
         BORDER_WIDTHS["default"] = 3;
      }
      
      override public function get borderMetrics() : EdgeMetrics
      {
         var borderThickness:Number = NaN;
         var borderSides:String = null;
         if(Boolean(this._borderMetrics))
         {
            return this._borderMetrics;
         }
         var borderStyle:String = getStyle("borderStyle");
         if(borderStyle == "default" || borderStyle == "alert")
         {
            return EdgeMetrics.EMPTY;
         }
         if(borderStyle == "controlBar" || borderStyle == "applicationControlBar")
         {
            this._borderMetrics = new EdgeMetrics(1,1,1,1);
         }
         else if(borderStyle == "solid")
         {
            borderThickness = Number(getStyle("borderThickness"));
            if(isNaN(borderThickness))
            {
               borderThickness = 0;
            }
            this._borderMetrics = new EdgeMetrics(borderThickness,borderThickness,borderThickness,borderThickness);
            borderSides = getStyle("borderSides");
            if(borderSides != "left top right bottom")
            {
               if(borderSides.indexOf("left") == -1)
               {
                  this._borderMetrics.left = 0;
               }
               if(borderSides.indexOf("top") == -1)
               {
                  this._borderMetrics.top = 0;
               }
               if(borderSides.indexOf("right") == -1)
               {
                  this._borderMetrics.right = 0;
               }
               if(borderSides.indexOf("bottom") == -1)
               {
                  this._borderMetrics.bottom = 0;
               }
            }
         }
         else
         {
            borderThickness = Number(BORDER_WIDTHS[borderStyle]);
            if(isNaN(borderThickness))
            {
               borderThickness = 0;
            }
            this._borderMetrics = new EdgeMetrics(borderThickness,borderThickness,borderThickness,borderThickness);
         }
         return this._borderMetrics;
      }
      
      override public function styleChanged(styleProp:String) : void
      {
         super.styleChanged(styleProp);
         if(styleProp == null || styleProp == "styleName" || styleProp == "borderStyle" || styleProp == "borderThickness" || styleProp == "borderSides")
         {
            this._borderMetrics = null;
         }
      }
      
      override protected function updateDisplayList(w:Number, h:Number) : void
      {
         if(isNaN(w) || isNaN(h))
         {
            return;
         }
         super.updateDisplayList(w,h);
         this.backgroundColor = this.getBackgroundColor();
         this.bRoundedCorners = false;
         this.backgroundAlphaName = "backgroundAlpha";
         this.backgroundHole = null;
         this.radius = 0;
         this.radiusObj = null;
         this.drawBorder(w,h);
         this.drawBackground(w,h);
      }
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") function drawBorder(w:Number, h:Number) : void
      {
         var backgroundAlpha:Number = NaN;
         var borderCapColor:uint = 0;
         var borderColor:uint = 0;
         var borderSides:String = null;
         var borderThickness:Number = NaN;
         var buttonColor:uint = 0;
         var docked:Boolean = false;
         var dropdownBorderColor:uint = 0;
         var fillColors:Array = null;
         var footerColors:Array = null;
         var highlightColor:uint = 0;
         var shadowCapColor:uint = 0;
         var shadowColor:uint = 0;
         var themeColor:uint = 0;
         var translucent:Boolean = false;
         var hole:Object = null;
         var borderColorDrk1:Number = NaN;
         var borderColorDrk2:Number = NaN;
         var borderColorLt1:Number = NaN;
         var borderInnerColor:Object = null;
         var showChrome:Boolean = false;
         var borderAlpha:Number = NaN;
         var fillAlphas:Array = null;
         var backgroundColorNum:uint = 0;
         var bHasAllSides:Boolean = false;
         var holeRadius:Number = NaN;
         var borderStyle:String = getStyle("borderStyle");
         var highlightAlphas:Array = getStyle("highlightAlphas");
         var drawTopHighlight:Boolean = false;
         var g:Graphics = graphics;
         g.clear();
         if(Boolean(borderStyle))
         {
            switch(borderStyle)
            {
               case "none":
                  break;
               case "inset":
                  borderColor = uint(getStyle("borderColor"));
                  borderColorDrk1 = Number(ColorUtil.adjustBrightness2(borderColor,-40));
                  borderColorDrk2 = Number(ColorUtil.adjustBrightness2(borderColor,25));
                  borderColorLt1 = Number(ColorUtil.adjustBrightness2(borderColor,40));
                  borderInnerColor = this.backgroundColor;
                  if(borderInnerColor === null || borderInnerColor === "")
                  {
                     borderInnerColor = borderColor;
                  }
                  this.draw3dBorder(borderColorDrk2,borderColorDrk1,borderColorLt1,Number(borderInnerColor),Number(borderInnerColor),Number(borderInnerColor));
                  break;
               case "outset":
                  borderColor = uint(getStyle("borderColor"));
                  borderColorDrk1 = Number(ColorUtil.adjustBrightness2(borderColor,-40));
                  borderColorDrk2 = Number(ColorUtil.adjustBrightness2(borderColor,-25));
                  borderColorLt1 = Number(ColorUtil.adjustBrightness2(borderColor,40));
                  borderInnerColor = this.backgroundColor;
                  if(borderInnerColor === null || borderInnerColor === "")
                  {
                     borderInnerColor = borderColor;
                  }
                  this.draw3dBorder(borderColorDrk2,borderColorLt1,borderColorDrk1,Number(borderInnerColor),Number(borderInnerColor),Number(borderInnerColor));
                  break;
               case "alert":
               case "default":
                  break;
               case "dropdown":
                  dropdownBorderColor = uint(getStyle("dropdownBorderColor"));
                  this.drawDropShadow(0,0,w,h,4,0,0,4);
                  drawRoundRect(0,0,w,h,{
                     "tl":4,
                     "tr":0,
                     "br":0,
                     "bl":4
                  },5068126,1);
                  drawRoundRect(0,0,w,h,{
                     "tl":4,
                     "tr":0,
                     "br":0,
                     "bl":4
                  },[16777215,16777215],[0.7,0],verticalGradientMatrix(0,0,w,h));
                  drawRoundRect(1,1,w - 1,h - 2,{
                     "tl":3,
                     "tr":0,
                     "br":0,
                     "bl":3
                  },16777215,1);
                  drawRoundRect(1,2,w - 1,h - 3,{
                     "tl":3,
                     "tr":0,
                     "br":0,
                     "bl":3
                  },[15658734,16777215],1,verticalGradientMatrix(0,0,w - 1,h - 3));
                  if(!isNaN(dropdownBorderColor))
                  {
                     drawRoundRect(0,0,w + 1,h,{
                        "tl":4,
                        "tr":0,
                        "br":0,
                        "bl":4
                     },dropdownBorderColor,0.5);
                     drawRoundRect(1,1,w - 1,h - 2,{
                        "tl":3,
                        "tr":0,
                        "br":0,
                        "bl":3
                     },16777215,1);
                     drawRoundRect(1,2,w - 1,h - 3,{
                        "tl":3,
                        "tr":0,
                        "br":0,
                        "bl":3
                     },[15658734,16777215],1,verticalGradientMatrix(0,0,w - 1,h - 3));
                  }
                  this.backgroundColor = null;
                  break;
               case "menuBorder":
                  borderColor = uint(getStyle("borderColor"));
                  drawRoundRect(0,0,w,h,0,borderColor,1);
                  this.drawDropShadow(1,1,w - 2,h - 2,0,0,0,0);
                  break;
               case "comboNonEdit":
                  break;
               case "controlBar":
                  if(w == 0 || h == 0)
                  {
                     this.backgroundColor = null;
                     break;
                  }
                  footerColors = getStyle("footerColors");
                  showChrome = footerColors != null;
                  borderAlpha = Number(getStyle("borderAlpha"));
                  if(showChrome)
                  {
                     g.lineStyle(0,footerColors.length > 0 ? uint(footerColors[1]) : uint(footerColors[0]),borderAlpha);
                     g.moveTo(0,0);
                     g.lineTo(w,0);
                     g.lineStyle(0,0,0);
                     if(Boolean(parent) && Boolean(parent.parent) && parent.parent is IStyleClient)
                     {
                        this.radius = IStyleClient(parent.parent).getStyle("cornerRadius");
                        borderAlpha = Number(IStyleClient(parent.parent).getStyle("borderAlpha"));
                     }
                     if(isNaN(this.radius))
                     {
                        this.radius = 0;
                     }
                     if(IStyleClient(parent.parent).getStyle("roundedBottomCorners").toString().toLowerCase() != "true")
                     {
                        this.radius = 0;
                     }
                     drawRoundRect(0,1,w,h - 1,{
                        "tl":0,
                        "tr":0,
                        "bl":this.radius,
                        "br":this.radius
                     },footerColors,borderAlpha,verticalGradientMatrix(0,0,w,h));
                     if(footerColors.length > 1 && footerColors[0] != footerColors[1])
                     {
                        drawRoundRect(0,1,w,h - 1,{
                           "tl":0,
                           "tr":0,
                           "bl":this.radius,
                           "br":this.radius
                        },[16777215,16777215],highlightAlphas,verticalGradientMatrix(0,0,w,h));
                        drawRoundRect(1,2,w - 2,h - 3,{
                           "tl":0,
                           "tr":0,
                           "bl":this.radius - 1,
                           "br":this.radius - 1
                        },footerColors,borderAlpha,verticalGradientMatrix(0,0,w,h));
                     }
                  }
                  this.backgroundColor = null;
                  break;
               case "applicationControlBar":
                  fillColors = getStyle("fillColors");
                  backgroundAlpha = Number(getStyle("backgroundAlpha"));
                  highlightAlphas = getStyle("highlightAlphas");
                  fillAlphas = getStyle("fillAlphas");
                  docked = Boolean(getStyle("docked"));
                  backgroundColorNum = uint(this.backgroundColor);
                  this.radius = getStyle("cornerRadius");
                  if(!this.radius)
                  {
                     this.radius = 0;
                  }
                  this.drawDropShadow(0,1,w,h - 1,this.radius,this.radius,this.radius,this.radius);
                  if(this.backgroundColor !== null && Boolean(styleManager.isValidStyleValue(this.backgroundColor)))
                  {
                     drawRoundRect(0,1,w,h - 1,this.radius,backgroundColorNum,backgroundAlpha,verticalGradientMatrix(0,0,w,h));
                  }
                  drawRoundRect(0,1,w,h - 1,this.radius,fillColors,fillAlphas,verticalGradientMatrix(0,0,w,h));
                  drawRoundRect(0,1,w,h / 2 - 1,{
                     "tl":this.radius,
                     "tr":this.radius,
                     "bl":0,
                     "br":0
                  },[16777215,16777215],highlightAlphas,verticalGradientMatrix(0,0,w,h / 2 - 1));
                  drawRoundRect(0,1,w,h - 1,{
                     "tl":this.radius,
                     "tr":this.radius,
                     "bl":0,
                     "br":0
                  },16777215,0.3,null,GradientType.LINEAR,null,{
                     "x":0,
                     "y":2,
                     "w":w,
                     "h":h - 2,
                     "r":{
                        "tl":this.radius,
                        "tr":this.radius,
                        "bl":0,
                        "br":0
                     }
                  });
                  this.backgroundColor = null;
                  break;
               default:
                  borderColor = uint(getStyle("borderColor"));
                  borderThickness = Number(getStyle("borderThickness"));
                  borderSides = getStyle("borderSides");
                  bHasAllSides = true;
                  this.radius = getStyle("cornerRadius");
                  this.bRoundedCorners = getStyle("roundedBottomCorners").toString().toLowerCase() == "true";
                  holeRadius = Math.max(this.radius - borderThickness,0);
                  hole = {
                     "x":borderThickness,
                     "y":borderThickness,
                     "w":w - borderThickness * 2,
                     "h":h - borderThickness * 2,
                     "r":holeRadius
                  };
                  if(!this.bRoundedCorners)
                  {
                     this.radiusObj = {
                        "tl":this.radius,
                        "tr":this.radius,
                        "bl":0,
                        "br":0
                     };
                     hole.r = {
                        "tl":holeRadius,
                        "tr":holeRadius,
                        "bl":0,
                        "br":0
                     };
                  }
                  if(borderSides != "left top right bottom")
                  {
                     hole.r = {
                        "tl":holeRadius,
                        "tr":holeRadius,
                        "bl":(this.bRoundedCorners ? holeRadius : 0),
                        "br":(this.bRoundedCorners ? holeRadius : 0)
                     };
                     this.radiusObj = {
                        "tl":this.radius,
                        "tr":this.radius,
                        "bl":(this.bRoundedCorners ? this.radius : 0),
                        "br":(this.bRoundedCorners ? this.radius : 0)
                     };
                     borderSides = borderSides.toLowerCase();
                     if(borderSides.indexOf("left") == -1)
                     {
                        hole.x = 0;
                        hole.w += borderThickness;
                        hole.r.tl = 0;
                        hole.r.bl = 0;
                        this.radiusObj.tl = 0;
                        this.radiusObj.bl = 0;
                        bHasAllSides = false;
                     }
                     if(borderSides.indexOf("top") == -1)
                     {
                        hole.y = 0;
                        hole.h += borderThickness;
                        hole.r.tl = 0;
                        hole.r.tr = 0;
                        this.radiusObj.tl = 0;
                        this.radiusObj.tr = 0;
                        bHasAllSides = false;
                     }
                     if(borderSides.indexOf("right") == -1)
                     {
                        hole.w += borderThickness;
                        hole.r.tr = 0;
                        hole.r.br = 0;
                        this.radiusObj.tr = 0;
                        this.radiusObj.br = 0;
                        bHasAllSides = false;
                     }
                     if(borderSides.indexOf("bottom") == -1)
                     {
                        hole.h += borderThickness;
                        hole.r.bl = 0;
                        hole.r.br = 0;
                        this.radiusObj.bl = 0;
                        this.radiusObj.br = 0;
                        bHasAllSides = false;
                     }
                  }
                  if(this.radius == 0 && bHasAllSides)
                  {
                     this.drawDropShadow(0,0,w,h,0,0,0,0);
                     g.beginFill(borderColor);
                     g.drawRect(0,0,w,h);
                     g.drawRect(borderThickness,borderThickness,w - 2 * borderThickness,h - 2 * borderThickness);
                     g.endFill();
                  }
                  else if(Boolean(this.radiusObj))
                  {
                     this.drawDropShadow(0,0,w,h,this.radiusObj.tl,this.radiusObj.tr,this.radiusObj.br,this.radiusObj.bl);
                     drawRoundRect(0,0,w,h,this.radiusObj,borderColor,1,null,null,null,hole);
                     this.radiusObj.tl = Math.max(this.radius - borderThickness,0);
                     this.radiusObj.tr = Math.max(this.radius - borderThickness,0);
                     this.radiusObj.bl = this.bRoundedCorners ? Math.max(this.radius - borderThickness,0) : 0;
                     this.radiusObj.br = this.bRoundedCorners ? Math.max(this.radius - borderThickness,0) : 0;
                  }
                  else
                  {
                     this.drawDropShadow(0,0,w,h,this.radius,this.radius,this.radius,this.radius);
                     drawRoundRect(0,0,w,h,this.radius,borderColor,1,null,null,null,hole);
                     this.radius = Math.max(getStyle("cornerRadius") - borderThickness,0);
                  }
            }
         }
      }
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") function draw3dBorder(c1:Number, c2:Number, c3:Number, c4:Number, c5:Number, c6:Number) : void
      {
         var w:Number = Number(width);
         var h:Number = Number(height);
         this.drawDropShadow(0,0,width,height,0,0,0,0);
         var g:Graphics = graphics;
         g.beginFill(c1);
         g.drawRect(0,0,w,h);
         g.drawRect(1,0,w - 2,h);
         g.endFill();
         g.beginFill(c2);
         g.drawRect(1,0,w - 2,1);
         g.endFill();
         g.beginFill(c3);
         g.drawRect(1,h - 1,w - 2,1);
         g.endFill();
         g.beginFill(c4);
         g.drawRect(1,1,w - 2,1);
         g.endFill();
         g.beginFill(c5);
         g.drawRect(1,h - 2,w - 2,1);
         g.endFill();
         g.beginFill(c6);
         g.drawRect(1,2,w - 2,h - 4);
         g.drawRect(2,2,w - 4,h - 4);
         g.endFill();
      }
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") function drawBackground(w:Number, h:Number) : void
      {
         var nd:Number = NaN;
         var alpha:Number = NaN;
         var bm:EdgeMetrics = null;
         var g:Graphics = null;
         var bottom:Number = NaN;
         var topRadius:Number = NaN;
         var bottomRadius:Number = NaN;
         if(Boolean(this.backgroundColor !== null && this.backgroundColor !== "") || Boolean(getStyle("mouseShield")) || Boolean(getStyle("mouseShieldChildren")))
         {
            nd = Number(this.backgroundColor);
            alpha = 1;
            bm = this.getBackgroundColorMetrics();
            g = graphics;
            if(isNaN(nd) || this.backgroundColor === "" || this.backgroundColor === null)
            {
               alpha = 0;
               nd = 16777215;
            }
            else
            {
               alpha = Number(getStyle(this.backgroundAlphaName));
            }
            if(this.radius != 0 || Boolean(this.backgroundHole))
            {
               bottom = Number(bm.bottom);
               if(Boolean(this.radiusObj))
               {
                  topRadius = Math.max(this.radius - Math.max(bm.top,bm.left,bm.right),0);
                  bottomRadius = this.bRoundedCorners ? Math.max(this.radius - Math.max(bm.bottom,bm.left,bm.right),0) : 0;
                  this.radiusObj = {
                     "tl":topRadius,
                     "tr":topRadius,
                     "bl":bottomRadius,
                     "br":bottomRadius
                  };
                  drawRoundRect(bm.left,bm.top,width - (bm.left + bm.right),height - (bm.top + bottom),this.radiusObj,nd,alpha,null,GradientType.LINEAR,null,this.backgroundHole);
               }
               else
               {
                  drawRoundRect(bm.left,bm.top,width - (bm.left + bm.right),height - (bm.top + bottom),this.radius,nd,alpha,null,GradientType.LINEAR,null,this.backgroundHole);
               }
            }
            else
            {
               g.beginFill(nd,alpha);
               g.drawRect(bm.left,bm.top,w - bm.right - bm.left,h - bm.bottom - bm.top);
               g.endFill();
            }
         }
      }
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") function drawDropShadow(x:Number, y:Number, width:Number, height:Number, tlRadius:Number, trRadius:Number, brRadius:Number, blRadius:Number) : void
      {
         var angle:Number = NaN;
         var docked:Boolean = false;
         if(getStyle("dropShadowEnabled") == false || getStyle("dropShadowEnabled") == "false" || width == 0 || height == 0)
         {
            return;
         }
         var distance:Number = Number(getStyle("shadowDistance"));
         var direction:String = getStyle("shadowDirection");
         if(getStyle("borderStyle") == "applicationControlBar")
         {
            docked = Boolean(getStyle("docked"));
            angle = docked ? 90 : this.getDropShadowAngle(distance,direction);
            distance = Math.abs(distance);
         }
         else
         {
            angle = this.getDropShadowAngle(distance,direction);
            distance = Math.abs(distance) + 2;
         }
         if(!this.dropShadow)
         {
            this.dropShadow = new RectangularDropShadow();
         }
         this.dropShadow.distance = distance;
         this.dropShadow.angle = angle;
         this.dropShadow.color = getStyle("dropShadowColor");
         this.dropShadow.alpha = 0.4;
         this.dropShadow.tlRadius = tlRadius;
         this.dropShadow.trRadius = trRadius;
         this.dropShadow.blRadius = blRadius;
         this.dropShadow.brRadius = brRadius;
         this.dropShadow.drawShadow(graphics,x,y,width,height);
      }
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") function getDropShadowAngle(distance:Number, direction:String) : Number
      {
         if(direction == "left")
         {
            return distance >= 0 ? 135 : 225;
         }
         if(direction == "right")
         {
            return distance >= 0 ? 45 : 315;
         }
         return distance >= 0 ? 90 : 270;
      }
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") function getBackgroundColor() : Object
      {
         var color:Object = null;
         var p:IUIComponent = parent as IUIComponent;
         if(Boolean(p) && !p.enabled)
         {
            color = getStyle("backgroundDisabledColor");
            if(color !== null && Boolean(styleManager.isValidStyleValue(color)))
            {
               return color;
            }
         }
         return getStyle("backgroundColor");
      }
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") function getBackgroundColorMetrics() : EdgeMetrics
      {
         return this.borderMetrics;
      }
   }
}

