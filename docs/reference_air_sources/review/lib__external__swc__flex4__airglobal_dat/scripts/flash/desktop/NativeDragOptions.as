package flash.desktop
{
   public class NativeDragOptions
   {
      
      public var allowCopy:Boolean = true;
      
      public var allowMove:Boolean = true;
      
      public var allowLink:Boolean = true;
      
      public function NativeDragOptions()
      {
         super();
      }
      
      public function toString() : String
      {
         return "[NativeDragOptions allowCopy=" + this.allowCopy + ",allowMove=" + this.allowMove + ",allowLink=" + this.allowLink + "]";
      }
   }
}

