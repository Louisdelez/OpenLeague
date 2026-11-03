package flash.media
{
   import flash.geom.*;
   
   [API("675")]
   [native(cls="CameraRollBrowseOptionsClass",instance="CameraRollBrowseOptionsObject",methods="auto")]
   public class CameraRollBrowseOptions
   {
      
      public function CameraRollBrowseOptions()
      {
         super();
         this.width = 0;
         this.height = 0;
         this.origin = new Rectangle(0,0,0,0);
      }
      
      public native function get width() : Number;
      
      public native function set width(param1:Number) : void;
      
      public native function get height() : Number;
      
      public native function set height(param1:Number) : void;
      
      public native function get origin() : Rectangle;
      
      public native function set origin(param1:Rectangle) : void;
   }
}

