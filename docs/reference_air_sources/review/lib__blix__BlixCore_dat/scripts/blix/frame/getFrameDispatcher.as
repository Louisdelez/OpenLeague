package blix.frame
{
   import flash.display.DisplayObject;
   import flash.display.Shape;
   
   public function getFrameDispatcher() : DisplayObject
   {
      if(frameDispatcher == null)
      {
         frameDispatcher = new Shape();
      }
      return frameDispatcher;
   }
}

