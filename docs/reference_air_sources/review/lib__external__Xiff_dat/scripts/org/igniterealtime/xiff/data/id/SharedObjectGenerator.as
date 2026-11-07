package org.igniterealtime.xiff.data.id
{
   import flash.net.SharedObject;
   
   public class SharedObjectGenerator implements IIDGenerator
   {
      
      private static var SO_COOKIE_NAME:String = "IIDGenerator";
      
      private var mySO:SharedObject;
      
      public function SharedObjectGenerator()
      {
         super();
         this.mySO = SharedObject.getLocal(SO_COOKIE_NAME);
         if(this.mySO.data.myCounter == undefined)
         {
            this.mySO.data.myCounter = 0;
         }
      }
      
      public function getID(param1:String) : String
      {
         var _loc2_:String = null;
         ++this.mySO.data.myCounter;
         if(param1 != null)
         {
            _loc2_ = param1 + this.mySO.data.myCounter;
         }
         else
         {
            _loc2_ = this.mySO.data.myCounter.toString();
         }
         return _loc2_;
      }
   }
}

