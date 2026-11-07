package system.errors
{
   public class NoSuchElementError extends Error
   {
      
      public function NoSuchElementError(param1:String = "", param2:int = 0)
      {
         super(param1,param2);
         name = "NoSuchElementError";
      }
   }
}

