package mx.printing
{
   import flash.display.DisplayObject;
   import flash.display.Sprite;
   import flash.display.Stage;
   import flash.geom.Rectangle;
   import flash.printing.PrintJob;
   import flash.printing.PrintJobOptions;
   import mx.core.Application;
   import mx.core.IFlexDisplayObject;
   import mx.core.IUIComponent;
   import mx.core.UIComponent;
   import mx.core.UIComponentGlobals;
   import mx.core.mx_internal;
   
   use namespace mx_internal;
   
   public class FlexPrintJob
   {
      
      mx_internal static const VERSION:String = "3.5.0.12683";
      
      private var _printAsBitmap:Boolean = true;
      
      private var printJob:PrintJob = new PrintJob();
      
      private var _pageHeight:Number = 0;
      
      private var _pageWidth:Number = 0;
      
      public function FlexPrintJob()
      {
         super();
      }
      
      public function start() : Boolean
      {
         var ok:Boolean = printJob.start();
         if(ok)
         {
            _pageWidth = printJob.pageWidth;
            _pageHeight = printJob.pageHeight;
         }
         return ok;
      }
      
      public function addObject(obj:IUIComponent, scaleType:String = "matchWidth") : void
      {
         var objWidth:Number = NaN;
         var objHeight:Number = NaN;
         var objPercWidth:Number = NaN;
         var objPercHeight:Number = NaN;
         var n:int = 0;
         var i:int = 0;
         var j:int = 0;
         var child:IFlexDisplayObject = null;
         var appExplicitWidth:Number = NaN;
         var appExplicitHeight:Number = NaN;
         var r:Rectangle = null;
         var printJobOptions:PrintJobOptions = null;
         var childPercentSize:Object = null;
         var childPercentSizes:Object = {};
         if(obj is Application)
         {
            n = Application(obj).numChildren;
            for(i = 0; i < n; i++)
            {
               child = IFlexDisplayObject(Application(obj).getChildAt(i));
               if(child is UIComponent && (!isNaN(UIComponent(child).percentWidth) || !isNaN(UIComponent(child).percentHeight)))
               {
                  childPercentSizes[child.name] = {};
                  if(!isNaN(UIComponent(child).percentWidth) && isNaN(UIComponent(child).explicitWidth))
                  {
                     childPercentSizes[child.name].percentWidth = UIComponent(child).percentWidth;
                     UIComponent(child).percentWidth = NaN;
                     UIComponent(child).explicitWidth = UIComponent(child).width;
                  }
                  if(!isNaN(UIComponent(child).percentHeight) && isNaN(UIComponent(child).explicitHeight))
                  {
                     childPercentSizes[child.name].percentHeight = UIComponent(child).percentHeight;
                     UIComponent(child).percentHeight = NaN;
                     UIComponent(child).explicitHeight = UIComponent(child).height;
                  }
               }
            }
            if(!isNaN(UIComponent(obj).explicitWidth) && !isNaN(UIComponent(obj).explicitHeight))
            {
               appExplicitWidth = UIComponent(obj).explicitWidth;
               appExplicitHeight = UIComponent(obj).explicitHeight;
               UIComponent(obj).explicitWidth = NaN;
               UIComponent(obj).explicitHeight = NaN;
               UIComponent(obj).measuredWidth = appExplicitWidth;
               UIComponent(obj).measuredHeight = appExplicitHeight;
            }
            if(isNaN(obj.percentWidth) && isNaN(obj.percentHeight))
            {
               UIComponent(obj).invalidateSizeFlag = false;
            }
            UIComponent(obj).validateSize();
            objWidth = Number(obj.measuredWidth);
            objHeight = Number(obj.measuredHeight);
         }
         else
         {
            if(!isNaN(obj.percentWidth) && isNaN(obj.explicitWidth))
            {
               objPercWidth = obj.percentWidth;
               obj.percentWidth = NaN;
               obj.explicitWidth = obj.width;
            }
            if(!isNaN(obj.percentHeight) && isNaN(obj.explicitHeight))
            {
               objPercHeight = obj.percentHeight;
               obj.percentHeight = NaN;
               obj.explicitHeight = obj.height;
            }
            objWidth = obj.getExplicitOrMeasuredWidth();
            objHeight = obj.getExplicitOrMeasuredHeight();
         }
         var widthRatio:Number = _pageWidth / objWidth;
         var heightRatio:Number = _pageHeight / objHeight;
         var ratio:Number = 1;
         if(scaleType == FlexPrintJobScaleType.SHOW_ALL)
         {
            ratio = widthRatio < heightRatio ? widthRatio : heightRatio;
         }
         else if(scaleType == FlexPrintJobScaleType.FILL_PAGE)
         {
            ratio = widthRatio > heightRatio ? widthRatio : heightRatio;
         }
         else if(scaleType != FlexPrintJobScaleType.NONE)
         {
            if(scaleType == FlexPrintJobScaleType.MATCH_HEIGHT)
            {
               ratio = heightRatio;
            }
            else
            {
               ratio = widthRatio;
            }
         }
         obj.scaleX *= ratio;
         obj.scaleY *= ratio;
         UIComponentGlobals.layoutManager.usePhasedInstantiation = false;
         UIComponentGlobals.layoutManager.validateNow();
         var arrPrintData:Array = prepareToPrintObject(obj);
         if(obj is Application)
         {
            objWidth *= ratio;
            objHeight *= ratio;
         }
         else
         {
            objWidth = obj.getExplicitOrMeasuredWidth();
            objHeight = obj.getExplicitOrMeasuredHeight();
         }
         var hPages:int = Math.ceil(objWidth / _pageWidth);
         var vPages:int = Math.ceil(objHeight / _pageHeight);
         var incrX:Number = _pageWidth / ratio;
         var incrY:Number = _pageHeight / ratio;
         var lastPageWidth:Number = objWidth % _pageWidth / ratio;
         var lastPageHeight:Number = objHeight % _pageHeight / ratio;
         for(j = 0; j < vPages; j++)
         {
            for(i = 0; i < hPages; i++)
            {
               r = new Rectangle(i * incrX,j * incrY,incrX,incrY);
               if(i == hPages - 1 && lastPageWidth != 0)
               {
                  r.width = lastPageWidth;
               }
               if(j == vPages - 1 && lastPageHeight != 0)
               {
                  r.height = lastPageHeight;
               }
               r.width = Math.ceil(r.width);
               r.height = Math.ceil(r.height);
               printJobOptions = new PrintJobOptions();
               printJobOptions.printAsBitmap = _printAsBitmap;
               printJob.addPage(Sprite(obj),r,printJobOptions);
            }
         }
         finishPrintObject(obj,arrPrintData);
         obj.scaleX /= ratio;
         obj.scaleY /= ratio;
         if(obj is Application)
         {
            if(!isNaN(appExplicitWidth))
            {
               UIComponent(obj).setActualSize(appExplicitWidth,appExplicitHeight);
               appExplicitWidth = NaN;
               appExplicitHeight = NaN;
               UIComponent(obj).measuredWidth = 0;
               UIComponent(obj).measuredHeight = 0;
            }
            n = Application(obj).numChildren;
            for(i = 0; i < n; i++)
            {
               child = IFlexDisplayObject(Application(obj).getChildAt(i));
               if(child is UIComponent && Boolean(childPercentSizes[child.name]))
               {
                  childPercentSize = childPercentSizes[child.name];
                  if(Boolean(childPercentSize) && !isNaN(childPercentSize.percentWidth))
                  {
                     UIComponent(child).percentWidth = childPercentSize.percentWidth;
                     UIComponent(child).explicitWidth = NaN;
                  }
                  if(Boolean(childPercentSize) && !isNaN(childPercentSize.percentHeight))
                  {
                     UIComponent(child).percentHeight = childPercentSize.percentHeight;
                     UIComponent(child).explicitHeight = NaN;
                  }
               }
            }
            UIComponent(obj).invalidateSizeFlag = false;
            UIComponent(obj).validateSize();
         }
         else
         {
            if(!isNaN(objPercWidth))
            {
               obj.percentWidth = objPercWidth;
               obj.explicitWidth = NaN;
            }
            if(!isNaN(objPercHeight))
            {
               obj.percentHeight = objPercHeight;
               obj.explicitHeight = NaN;
            }
         }
         UIComponentGlobals.layoutManager.usePhasedInstantiation = false;
         UIComponentGlobals.layoutManager.validateNow();
      }
      
      public function send() : void
      {
         printJob.send();
      }
      
      public function get printAsBitmap() : Boolean
      {
         return _printAsBitmap;
      }
      
      private function prepareToPrintObject(target:IUIComponent) : Array
      {
         var arrPrintData:Array = [];
         var obj:DisplayObject = target is DisplayObject ? DisplayObject(target) : null;
         var index:Number = 0;
         while(Boolean(obj))
         {
            if(obj is UIComponent)
            {
               arrPrintData[index++] = UIComponent(obj).prepareToPrint(UIComponent(target));
            }
            else if(obj is DisplayObject && !(obj is Stage))
            {
               arrPrintData[index++] = DisplayObject(obj).mask;
               DisplayObject(obj).mask = null;
            }
            obj = obj.parent is DisplayObject ? DisplayObject(obj.parent) : null;
         }
         return arrPrintData;
      }
      
      public function get pageHeight() : Number
      {
         return _pageHeight;
      }
      
      public function get pageWidth() : Number
      {
         return _pageWidth;
      }
      
      private function finishPrintObject(target:IUIComponent, arrPrintData:Array) : void
      {
         var obj:DisplayObject = target is DisplayObject ? DisplayObject(target) : null;
         var index:Number = 0;
         while(Boolean(obj))
         {
            if(obj is UIComponent)
            {
               UIComponent(obj).finishPrint(arrPrintData[index++],UIComponent(target));
            }
            else if(obj is DisplayObject && !(obj is Stage))
            {
               DisplayObject(obj).mask = arrPrintData[index++];
            }
            obj = obj.parent is DisplayObject ? DisplayObject(obj.parent) : null;
         }
      }
      
      public function set printAsBitmap(value:Boolean) : void
      {
         _printAsBitmap = value;
      }
   }
}

