package mx.containers.utilityClasses
{
   import mx.core.IChildList;
   import mx.core.IUIComponent;
   import mx.core.mx_internal;
   
   use namespace mx_internal;
   
   [ExcludeClass]
   public class Flex
   {
      
      mx_internal static const VERSION:String = "4.6.0.23201";
      
      public function Flex()
      {
         super();
      }
      
      public static function flexChildWidthsProportionally(parent:IChildList, spaceForChildren:Number, h:Number) : Number
      {
         var childInfo:FlexChildInfo = null;
         var child:IUIComponent = null;
         var i:int = 0;
         var percentWidth:Number = NaN;
         var percentHeight:Number = NaN;
         var height:Number = NaN;
         var width:Number = NaN;
         var spaceToDistribute:Number = spaceForChildren;
         var totalPercentWidth:Number = 0;
         var childInfoArray:Array = [];
         var n:int = parent.numChildren;
         for(i = 0; i < n; i++)
         {
            child = IUIComponent(parent.getChildAt(i));
            percentWidth = child.percentWidth;
            percentHeight = child.percentHeight;
            if(!isNaN(percentHeight) && child.includeInLayout)
            {
               height = Math.max(child.minHeight,Math.min(child.maxHeight,percentHeight >= 100 ? h : h * percentHeight / 100));
            }
            else
            {
               height = child.getExplicitOrMeasuredHeight();
            }
            if(!isNaN(percentWidth) && child.includeInLayout)
            {
               totalPercentWidth += percentWidth;
               childInfo = new FlexChildInfo();
               childInfo.percent = percentWidth;
               childInfo.min = child.minWidth;
               childInfo.max = child.maxWidth;
               childInfo.height = height;
               childInfo.child = child;
               childInfoArray.push(childInfo);
            }
            else
            {
               width = child.getExplicitOrMeasuredWidth();
               if(child.scaleX == 1 && child.scaleY == 1)
               {
                  child.setActualSize(Math.floor(width),Math.floor(height));
               }
               else
               {
                  child.setActualSize(width,height);
               }
               if(child.includeInLayout)
               {
                  spaceToDistribute -= child.width;
               }
            }
         }
         if(Boolean(totalPercentWidth))
         {
            spaceToDistribute = flexChildrenProportionally(spaceForChildren,spaceToDistribute,totalPercentWidth,childInfoArray);
            n = int(childInfoArray.length);
            for(i = 0; i < n; i++)
            {
               childInfo = childInfoArray[i];
               child = childInfo.child;
               if(child.scaleX == 1 && child.scaleY == 1)
               {
                  child.setActualSize(Math.floor(childInfo.size),Math.floor(childInfo.height));
               }
               else
               {
                  child.setActualSize(childInfo.size,childInfo.height);
               }
            }
            distributeExtraWidth(parent,spaceForChildren);
         }
         return spaceToDistribute;
      }
      
      public static function flexChildHeightsProportionally(parent:IChildList, spaceForChildren:Number, w:Number) : Number
      {
         var childInfo:FlexChildInfo = null;
         var child:IUIComponent = null;
         var i:int = 0;
         var percentWidth:Number = NaN;
         var percentHeight:Number = NaN;
         var width:Number = NaN;
         var height:Number = NaN;
         var spaceToDistribute:Number = spaceForChildren;
         var totalPercentHeight:Number = 0;
         var childInfoArray:Array = [];
         var n:int = parent.numChildren;
         for(i = 0; i < n; i++)
         {
            child = IUIComponent(parent.getChildAt(i));
            percentWidth = child.percentWidth;
            percentHeight = child.percentHeight;
            if(!isNaN(percentWidth) && child.includeInLayout)
            {
               width = Math.max(child.minWidth,Math.min(child.maxWidth,percentWidth >= 100 ? w : w * percentWidth / 100));
            }
            else
            {
               width = child.getExplicitOrMeasuredWidth();
            }
            if(!isNaN(percentHeight) && child.includeInLayout)
            {
               totalPercentHeight += percentHeight;
               childInfo = new FlexChildInfo();
               childInfo.percent = percentHeight;
               childInfo.min = child.minHeight;
               childInfo.max = child.maxHeight;
               childInfo.width = width;
               childInfo.child = child;
               childInfoArray.push(childInfo);
            }
            else
            {
               height = child.getExplicitOrMeasuredHeight();
               if(child.scaleX == 1 && child.scaleY == 1)
               {
                  child.setActualSize(Math.floor(width),Math.floor(height));
               }
               else
               {
                  child.setActualSize(width,height);
               }
               if(child.includeInLayout)
               {
                  spaceToDistribute -= child.height;
               }
            }
         }
         if(Boolean(totalPercentHeight))
         {
            spaceToDistribute = flexChildrenProportionally(spaceForChildren,spaceToDistribute,totalPercentHeight,childInfoArray);
            n = int(childInfoArray.length);
            for(i = 0; i < n; i++)
            {
               childInfo = childInfoArray[i];
               child = childInfo.child;
               if(child.scaleX == 1 && child.scaleY == 1)
               {
                  child.setActualSize(Math.floor(childInfo.width),Math.floor(childInfo.size));
               }
               else
               {
                  child.setActualSize(childInfo.width,childInfo.size);
               }
            }
            distributeExtraHeight(parent,spaceForChildren);
         }
         return spaceToDistribute;
      }
      
      public static function flexChildrenProportionally(spaceForChildren:Number, spaceToDistribute:Number, totalPercent:Number, childInfoArray:Array) : Number
      {
         var flexConsumed:Number = NaN;
         var done:Boolean = false;
         var unused:Number = NaN;
         var spacePerPercent:Number = NaN;
         var i:int = 0;
         var childInfo:FlexChildInfo = null;
         var size:Number = NaN;
         var min:Number = NaN;
         var max:Number = NaN;
         var numChildren:int = int(childInfoArray.length);
         do
         {
            flexConsumed = 0;
            done = true;
            unused = spaceToDistribute - spaceForChildren * totalPercent / 100;
            if(unused > 0)
            {
               spaceToDistribute -= unused;
            }
            else
            {
               unused = 0;
            }
            spacePerPercent = spaceToDistribute / totalPercent;
            for(i = 0; i < numChildren; i++)
            {
               childInfo = childInfoArray[i];
               size = childInfo.percent * spacePerPercent;
               if(size < childInfo.min)
               {
                  min = childInfo.min;
                  childInfo.size = min;
                  childInfoArray[i] = childInfoArray[--numChildren];
                  childInfoArray[numChildren] = childInfo;
                  totalPercent -= childInfo.percent;
                  if(unused >= min)
                  {
                     unused -= min;
                  }
                  else
                  {
                     spaceToDistribute -= min - unused;
                     unused = 0;
                  }
                  done = false;
                  break;
               }
               if(size > childInfo.max)
               {
                  max = childInfo.max;
                  childInfo.size = max;
                  childInfoArray[i] = childInfoArray[--numChildren];
                  childInfoArray[numChildren] = childInfo;
                  totalPercent -= childInfo.percent;
                  if(unused >= max)
                  {
                     unused -= max;
                  }
                  else
                  {
                     spaceToDistribute -= max - unused;
                     unused = 0;
                  }
                  done = false;
                  break;
               }
               childInfo.size = size;
               flexConsumed += size;
            }
         }
         while(!done);
         return Math.max(0,Math.floor(spaceToDistribute + unused - flexConsumed));
      }
      
      public static function distributeExtraHeight(parent:IChildList, spaceForChildren:Number) : void
      {
         var i:int = 0;
         var percentHeight:Number = NaN;
         var child:IUIComponent = null;
         var childHeight:Number = NaN;
         var wantSpace:Number = NaN;
         var n:int = parent.numChildren;
         var wantToGrow:Boolean = false;
         var spaceToDistribute:Number = spaceForChildren;
         var spaceUsed:Number = 0;
         for(i = 0; i < n; i++)
         {
            child = IUIComponent(parent.getChildAt(i));
            if(child.includeInLayout)
            {
               childHeight = Number(child.height);
               percentHeight = child.percentHeight;
               spaceUsed += childHeight;
               if(!isNaN(percentHeight))
               {
                  wantSpace = Math.ceil(percentHeight / 100 * spaceForChildren);
                  if(wantSpace > childHeight)
                  {
                     wantToGrow = true;
                  }
               }
            }
         }
         if(!wantToGrow)
         {
            return;
         }
         spaceToDistribute -= spaceUsed;
         var stillFlexibleComponents:Boolean = true;
         while(stillFlexibleComponents && spaceToDistribute >= 1)
         {
            stillFlexibleComponents = false;
            i = 0;
            while(i < n)
            {
               child = IUIComponent(parent.getChildAt(i));
               childHeight = Number(child.height);
               percentHeight = child.percentHeight;
               if(!isNaN(percentHeight) && child.includeInLayout && childHeight < child.maxHeight)
               {
                  wantSpace = Math.ceil(percentHeight / 100 * spaceForChildren);
                  if(wantSpace > childHeight)
                  {
                     child.setActualSize(child.width,childHeight + 1);
                     spaceToDistribute--;
                     stillFlexibleComponents = true;
                     if(spaceToDistribute == 0)
                     {
                        return;
                     }
                  }
               }
               i++;
            }
         }
      }
      
      public static function distributeExtraWidth(parent:IChildList, spaceForChildren:Number) : void
      {
         var i:int = 0;
         var percentWidth:Number = NaN;
         var child:IUIComponent = null;
         var childWidth:Number = NaN;
         var wantSpace:Number = NaN;
         var n:int = parent.numChildren;
         var wantToGrow:Boolean = false;
         var spaceToDistribute:Number = spaceForChildren;
         var spaceUsed:Number = 0;
         for(i = 0; i < n; i++)
         {
            child = IUIComponent(parent.getChildAt(i));
            if(child.includeInLayout)
            {
               childWidth = Number(child.width);
               percentWidth = child.percentWidth;
               spaceUsed += childWidth;
               if(!isNaN(percentWidth))
               {
                  wantSpace = Math.ceil(percentWidth / 100 * spaceForChildren);
                  if(wantSpace > childWidth)
                  {
                     wantToGrow = true;
                  }
               }
            }
         }
         if(!wantToGrow)
         {
            return;
         }
         spaceToDistribute -= spaceUsed;
         var stillFlexibleComponents:Boolean = true;
         while(stillFlexibleComponents && spaceToDistribute >= 1)
         {
            stillFlexibleComponents = false;
            i = 0;
            while(i < n)
            {
               child = IUIComponent(parent.getChildAt(i));
               childWidth = Number(child.width);
               percentWidth = child.percentWidth;
               if(!isNaN(percentWidth) && child.includeInLayout && childWidth < child.maxWidth)
               {
                  wantSpace = Math.ceil(percentWidth / 100 * spaceForChildren);
                  if(wantSpace > childWidth)
                  {
                     child.setActualSize(childWidth + 1,child.height);
                     spaceToDistribute--;
                     stillFlexibleComponents = true;
                     if(spaceToDistribute == 0)
                     {
                        return;
                     }
                  }
               }
               i++;
            }
         }
      }
   }
}

