package spark.components.supportClasses
{
   import flash.geom.Point;
   import mx.core.IUIComponent;
   import mx.core.InteractionMode;
   import mx.core.ScrollPolicy;
   import mx.utils.MatrixUtil;
   import spark.components.Scroller;
   import spark.core.IViewport;
   import spark.layouts.supportClasses.LayoutBase;
   
   [ExcludeClass]
   public class ScrollerLayout extends LayoutBase
   {
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") static const SDT:Number = 1;
      
      private var invalidationCount:int = 0;
      
      private var _canScrollHorizontally:Boolean;
      
      private var _canScrollVertically:Boolean;
      
      private var hsbScaleX:Number = 1;
      
      private var hsbScaleY:Number = 1;
      
      private var vsbScaleX:Number = 1;
      
      private var vsbScaleY:Number = 1;
      
      public function ScrollerLayout()
      {
         super();
      }
      
      private function getScroller() : Scroller
      {
         var g:Skin = target as Skin;
         return Boolean(g) && "hostComponent" in g ? Object(g).hostComponent as Scroller : null;
      }
      
      private function getLayoutContentSize(viewport:IViewport) : Point
      {
         var cw:Number = viewport.contentWidth;
         var ch:Number = viewport.contentHeight;
         if(cw == 0 && ch == 0 || (isNaN(cw) || isNaN(ch)))
         {
            return new Point(0,0);
         }
         return MatrixUtil.transformSize(cw,ch,viewport.getLayoutMatrix());
      }
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") function get canScrollHorizontally() : Boolean
      {
         return this._canScrollHorizontally;
      }
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") function get canScrollVertically() : Boolean
      {
         return this._canScrollVertically;
      }
      
      private function get hsbVisible() : Boolean
      {
         var hsb:ScrollBarBase = this.getScroller().horizontalScrollBar;
         return Boolean(hsb) && Boolean(hsb.visible);
      }
      
      private function set hsbVisible(value:Boolean) : void
      {
         var hsb:ScrollBarBase = this.getScroller().horizontalScrollBar;
         if(!hsb || hsb.visible == value)
         {
            return;
         }
         hsb.includeInLayout = hsb.visible = value;
         if(value)
         {
            if(hsb.scaleX == 0)
            {
               hsb.scaleX = this.hsbScaleX;
            }
            if(hsb.scaleY == 0)
            {
               hsb.scaleY = this.hsbScaleY;
            }
         }
         else
         {
            if(hsb.scaleX != 0)
            {
               this.hsbScaleX = hsb.scaleX;
            }
            if(hsb.scaleY != 0)
            {
               this.hsbScaleY = hsb.scaleY;
            }
            hsb.scaleX = hsb.scaleY = 0;
         }
      }
      
      private function hsbRequiredHeight() : Number
      {
         var scroller:Scroller = this.getScroller();
         var minViewportInset:Number = scroller.minViewportInset;
         var hsb:ScrollBarBase = scroller.horizontalScrollBar;
         var sy:Number = this.hsbVisible ? 1 : this.hsbScaleY;
         return Math.max(minViewportInset,hsb.getPreferredBoundsHeight(this.hsbVisible) * sy);
      }
      
      private function hsbFits(w:Number, h:Number, includeVSB:Boolean = true) : Boolean
      {
         var vsb:ScrollBarBase = null;
         if(this.vsbVisible && includeVSB)
         {
            vsb = this.getScroller().verticalScrollBar;
            w -= vsb.getPreferredBoundsWidth();
            h -= vsb.getMinBoundsHeight();
         }
         var hsb:ScrollBarBase = this.getScroller().horizontalScrollBar;
         return w >= hsb.getMinBoundsWidth() && h >= hsb.getPreferredBoundsHeight();
      }
      
      private function get vsbVisible() : Boolean
      {
         var vsb:ScrollBarBase = this.getScroller().verticalScrollBar;
         return Boolean(vsb) && Boolean(vsb.visible);
      }
      
      private function set vsbVisible(value:Boolean) : void
      {
         var vsb:ScrollBarBase = this.getScroller().verticalScrollBar;
         if(!vsb || vsb.visible == value)
         {
            return;
         }
         vsb.includeInLayout = vsb.visible = value;
         if(value)
         {
            if(vsb.scaleX == 0)
            {
               vsb.scaleX = this.vsbScaleX;
            }
            if(vsb.scaleY == 0)
            {
               vsb.scaleY = this.vsbScaleY;
            }
         }
         else
         {
            if(vsb.scaleX != 0)
            {
               this.vsbScaleX = vsb.scaleX;
            }
            if(vsb.scaleY != 0)
            {
               this.vsbScaleY = vsb.scaleY;
            }
            vsb.scaleX = vsb.scaleY = 0;
         }
      }
      
      private function vsbRequiredWidth() : Number
      {
         var scroller:Scroller = this.getScroller();
         var minViewportInset:Number = scroller.minViewportInset;
         var vsb:ScrollBarBase = scroller.verticalScrollBar;
         var sx:Number = this.vsbVisible ? 1 : this.vsbScaleX;
         return Math.max(minViewportInset,vsb.getPreferredBoundsWidth(this.vsbVisible) * sx);
      }
      
      private function vsbFits(w:Number, h:Number, includeHSB:Boolean = true) : Boolean
      {
         var hsb:ScrollBarBase = null;
         if(this.hsbVisible && includeHSB)
         {
            hsb = this.getScroller().horizontalScrollBar;
            w -= hsb.getMinBoundsWidth();
            h -= hsb.getPreferredBoundsHeight();
         }
         var vsb:ScrollBarBase = this.getScroller().verticalScrollBar;
         return w >= vsb.getPreferredBoundsWidth() && h >= vsb.getMinBoundsHeight();
      }
      
      override public function measure() : void
      {
         var contentSize:Point = null;
         var viewportPreferredW:Number = NaN;
         var viewportContentW:Number = NaN;
         var viewportW:Number = NaN;
         var currentSizeNoHSB:Boolean = false;
         var viewportPreferredH:Number = NaN;
         var viewportContentH:Number = NaN;
         var viewportH:Number = NaN;
         var currentSizeNoVSB:Boolean = false;
         var scroller:Scroller = this.getScroller();
         if(!scroller)
         {
            return;
         }
         var minViewportInset:Number = scroller.minViewportInset;
         var measuredSizeIncludesScrollBars:Boolean = scroller.measuredSizeIncludesScrollBars && scroller.getStyle("interactionMode") == InteractionMode.MOUSE;
         var measuredW:Number = minViewportInset;
         var measuredH:Number = minViewportInset;
         var hsb:ScrollBarBase = scroller.horizontalScrollBar;
         var showHSB:Boolean = false;
         var hAuto:Boolean = false;
         if(measuredSizeIncludesScrollBars)
         {
            switch(scroller.getStyle("horizontalScrollPolicy"))
            {
               case ScrollPolicy.ON:
                  if(Boolean(hsb))
                  {
                     showHSB = true;
                  }
                  break;
               case ScrollPolicy.AUTO:
                  if(Boolean(hsb))
                  {
                     showHSB = Boolean(hsb.visible);
                  }
                  hAuto = true;
            }
         }
         var vsb:ScrollBarBase = scroller.verticalScrollBar;
         var showVSB:Boolean = false;
         var vAuto:Boolean = false;
         if(measuredSizeIncludesScrollBars)
         {
            switch(scroller.getStyle("verticalScrollPolicy"))
            {
               case ScrollPolicy.ON:
                  if(Boolean(vsb))
                  {
                     showVSB = true;
                  }
                  break;
               case ScrollPolicy.AUTO:
                  if(Boolean(vsb))
                  {
                     showVSB = Boolean(vsb.visible);
                  }
                  vAuto = true;
            }
         }
         measuredH += showHSB ? this.hsbRequiredHeight() : minViewportInset;
         measuredW += showVSB ? this.vsbRequiredWidth() : minViewportInset;
         var viewport:IViewport = scroller.viewport;
         if(Boolean(viewport))
         {
            if(measuredSizeIncludesScrollBars)
            {
               contentSize = this.getLayoutContentSize(viewport);
               viewportPreferredW = Number(viewport.getPreferredBoundsWidth());
               viewportContentW = contentSize.x;
               viewportW = Number(viewport.getLayoutBoundsWidth());
               currentSizeNoHSB = !isNaN(viewportW) && viewportW + SDT > viewportContentW;
               if(hAuto && !showHSB && viewportPreferredW + SDT <= viewportContentW && currentSizeNoHSB)
               {
                  measuredW += viewportW;
               }
               else
               {
                  measuredW += Math.max(viewportPreferredW,showHSB ? Number(hsb.getMinBoundsWidth()) : 0);
               }
               viewportPreferredH = Number(viewport.getPreferredBoundsHeight());
               viewportContentH = contentSize.y;
               viewportH = Number(viewport.getLayoutBoundsHeight());
               currentSizeNoVSB = !isNaN(viewportH) && viewportH + SDT > viewportContentH;
               if(vAuto && !showVSB && viewportPreferredH + SDT <= viewportContentH && currentSizeNoVSB)
               {
                  measuredH += viewportH;
               }
               else
               {
                  measuredH += Math.max(viewportPreferredH,showVSB ? Number(vsb.getMinBoundsHeight()) : 0);
               }
            }
            else
            {
               measuredW += viewport.getPreferredBoundsWidth();
               measuredH += viewport.getPreferredBoundsHeight();
            }
         }
         var minW:Number = minViewportInset * 2;
         var minH:Number = minViewportInset * 2;
         var viewportUIC:IUIComponent = viewport as IUIComponent;
         var explicitViewportW:Number = Boolean(viewportUIC) ? Number(viewportUIC.explicitWidth) : NaN;
         var explicitViewportH:Number = Boolean(viewportUIC) ? Number(viewportUIC.explicitHeight) : NaN;
         if(!isNaN(explicitViewportW))
         {
            minW += explicitViewportW;
         }
         if(!isNaN(explicitViewportH))
         {
            minH += explicitViewportH;
         }
         var g:GroupBase = target;
         g.measuredWidth = Math.ceil(measuredW);
         g.measuredHeight = Math.ceil(measuredH);
         g.measuredMinWidth = Math.ceil(minW);
         g.measuredMinHeight = Math.ceil(minH);
      }
      
      override public function updateDisplayList(w:Number, h:Number) : void
      {
         var contentSize:Point = null;
         var hsbH:Number = NaN;
         var hsbW:Number = NaN;
         var vsbW:Number = NaN;
         var vsbH:Number = NaN;
         var viewportGroup:GroupBase = null;
         var scroller:Scroller = this.getScroller();
         if(!scroller)
         {
            return;
         }
         var viewport:IViewport = scroller.viewport;
         var hsb:ScrollBarBase = scroller.horizontalScrollBar;
         var vsb:ScrollBarBase = scroller.verticalScrollBar;
         var minViewportInset:Number = scroller.minViewportInset;
         var contentW:Number = 0;
         var contentH:Number = 0;
         if(Boolean(viewport))
         {
            contentSize = this.getLayoutContentSize(viewport);
            contentW = contentSize.x;
            contentH = contentSize.y;
         }
         var viewportUIC:IUIComponent = viewport as IUIComponent;
         var explicitViewportW:Number = Boolean(viewportUIC) ? Number(viewportUIC.explicitWidth) : NaN;
         var explicitViewportH:Number = Boolean(viewportUIC) ? Number(viewportUIC.explicitHeight) : NaN;
         var viewportW:Number = isNaN(explicitViewportW) ? w - minViewportInset * 2 : explicitViewportW;
         var viewportH:Number = isNaN(explicitViewportH) ? h - minViewportInset * 2 : explicitViewportH;
         var oldShowHSB:Boolean = this.hsbVisible;
         var oldShowVSB:Boolean = this.vsbVisible;
         var hAuto:Boolean = false;
         var hsbTakeUpSpace:Boolean = true;
         switch(scroller.getStyle("horizontalScrollPolicy"))
         {
            case ScrollPolicy.ON:
               this._canScrollHorizontally = true;
               this.hsbVisible = true;
               break;
            case ScrollPolicy.AUTO:
               if(Boolean(viewport))
               {
                  hAuto = true;
                  this._canScrollHorizontally = contentW >= viewportW + SDT;
                  this.hsbVisible = Boolean(hsb) && this._canScrollHorizontally;
               }
               break;
            default:
               this._canScrollHorizontally = false;
               this.hsbVisible = false;
         }
         var vAuto:Boolean = false;
         var vsbTakeUpSpace:Boolean = true;
         switch(scroller.getStyle("verticalScrollPolicy"))
         {
            case ScrollPolicy.ON:
               this._canScrollVertically = true;
               this.vsbVisible = true;
               break;
            case ScrollPolicy.AUTO:
               if(Boolean(viewport))
               {
                  vAuto = true;
                  this._canScrollVertically = contentH >= viewportH + SDT;
                  this.vsbVisible = Boolean(vsb) && this._canScrollVertically;
               }
               break;
            default:
               this._canScrollVertically = false;
               this.vsbVisible = false;
         }
         if(scroller.getStyle("interactionMode") == InteractionMode.TOUCH)
         {
            hsbTakeUpSpace = false;
            this.hsbVisible = scroller.horizontalScrollInProgress;
            vsbTakeUpSpace = false;
            this.vsbVisible = scroller.verticalScrollInProgress;
         }
         if(isNaN(explicitViewportW))
         {
            viewportW = w - (this.vsbVisible && vsbTakeUpSpace ? minViewportInset + this.vsbRequiredWidth() : minViewportInset * 2);
         }
         else
         {
            viewportW = explicitViewportW;
         }
         if(isNaN(explicitViewportH))
         {
            viewportH = h - (this.hsbVisible && hsbTakeUpSpace ? minViewportInset + this.hsbRequiredHeight() : minViewportInset * 2);
         }
         else
         {
            viewportH = explicitViewportH;
         }
         var hsbIsDependent:Boolean = false;
         var vsbIsDependent:Boolean = false;
         if(this.vsbVisible && !this.hsbVisible && hAuto && contentW >= viewportW + SDT)
         {
            this.hsbVisible = hsbIsDependent = this._canScrollHorizontally = true;
         }
         else if(!this.vsbVisible && this.hsbVisible && vAuto && contentH >= viewportH + SDT)
         {
            this.vsbVisible = vsbIsDependent = this._canScrollVertically = true;
         }
         if(this.hsbVisible && hsbTakeUpSpace && (this.vsbVisible && vsbTakeUpSpace))
         {
            if(!(this.hsbFits(w,h) && this.vsbFits(w,h)))
            {
               if(!this.hsbFits(w,h,false) && !this.vsbFits(w,h,false))
               {
                  this.hsbVisible = false;
                  this.vsbVisible = false;
               }
               else if(hsbIsDependent)
               {
                  if(this.vsbFits(w,h,false))
                  {
                     this.hsbVisible = false;
                  }
                  else
                  {
                     this.vsbVisible = this.hsbVisible = false;
                  }
               }
               else if(vsbIsDependent)
               {
                  if(this.hsbFits(w,h,false))
                  {
                     this.vsbVisible = false;
                  }
                  else
                  {
                     this.hsbVisible = this.vsbVisible = false;
                  }
               }
               else if(this.vsbFits(w,h,false))
               {
                  this.hsbVisible = false;
               }
               else
               {
                  this.vsbVisible = false;
               }
            }
         }
         else if(this.hsbVisible && hsbTakeUpSpace && !this.hsbFits(w,h))
         {
            this.hsbVisible = false;
         }
         else if(this.vsbVisible && vsbTakeUpSpace && !this.vsbFits(w,h))
         {
            this.vsbVisible = false;
         }
         if(hsbIsDependent && !this.vsbVisible)
         {
            this._canScrollHorizontally = false;
         }
         if(vsbIsDependent && !this.hsbVisible)
         {
            this._canScrollVertically = false;
         }
         if(isNaN(explicitViewportW))
         {
            viewportW = w - (this.vsbVisible && vsbTakeUpSpace ? minViewportInset + this.vsbRequiredWidth() : minViewportInset * 2);
         }
         else
         {
            viewportW = explicitViewportW;
         }
         if(isNaN(explicitViewportH))
         {
            viewportH = h - (this.hsbVisible && hsbTakeUpSpace ? minViewportInset + this.hsbRequiredHeight() : minViewportInset * 2);
         }
         else
         {
            viewportH = explicitViewportH;
         }
         if(Boolean(viewport))
         {
            viewport.setLayoutBoundsSize(viewportW,viewportH);
            viewport.setLayoutBoundsPosition(minViewportInset,minViewportInset);
         }
         if(this.hsbVisible)
         {
            hsbH = Number(hsb.getPreferredBoundsHeight());
            hsbW = this.vsbVisible ? w - vsb.getPreferredBoundsWidth() : w;
            hsb.setLayoutBoundsSize(Math.max(hsb.getMinBoundsWidth(),hsbW),hsbH);
            hsb.setLayoutBoundsPosition(0,h - hsbH);
         }
         if(this.vsbVisible)
         {
            vsbW = Number(vsb.getPreferredBoundsWidth());
            vsbH = this.hsbVisible ? h - hsb.getPreferredBoundsHeight() : h;
            vsb.setLayoutBoundsSize(vsbW,Math.max(vsb.getMinBoundsHeight(),vsbH));
            vsb.setLayoutBoundsPosition(w - vsbW,0);
         }
         if(this.invalidationCount < 2 && (this.vsbVisible != oldShowVSB && vAuto || this.hsbVisible != oldShowHSB && hAuto))
         {
            target.invalidateSize();
            viewportGroup = viewport as GroupBase;
            if(Boolean(viewportGroup) && Boolean(viewportGroup.layout) && viewportGroup.layout.useVirtualLayout)
            {
               viewportGroup.invalidateSize();
            }
            this.invalidationCount += 1;
         }
         else
         {
            this.invalidationCount = 0;
         }
         target.setContentSize(w,h);
      }
   }
}

