package mx.utils
{
   import flash.display.DisplayObject;
   import flash.display.DisplayObjectContainer;
   import mx.core.IRawChildrenContainer;
   import mx.core.mx_internal;
   
   use namespace mx_internal;
   
   public class DisplayUtil
   {
      
      mx_internal static const VERSION:String = "4.6.0.23201";
      
      public function DisplayUtil()
      {
         super();
      }
      
      public static function walkDisplayObjects(displayObject:DisplayObject, callbackFunction:Function) : void
      {
         var n:int = 0;
         var i:int = 0;
         var child:DisplayObject = null;
         callbackFunction(displayObject);
         if(displayObject is DisplayObjectContainer)
         {
            n = displayObject is IRawChildrenContainer ? IRawChildrenContainer(displayObject).rawChildren.numChildren : DisplayObjectContainer(displayObject).numChildren;
            for(i = 0; i < n; i++)
            {
               child = displayObject is IRawChildrenContainer ? IRawChildrenContainer(displayObject).rawChildren.getChildAt(i) : DisplayObjectContainer(displayObject).getChildAt(i);
               walkDisplayObjects(child,callbackFunction);
            }
         }
      }
   }
}

