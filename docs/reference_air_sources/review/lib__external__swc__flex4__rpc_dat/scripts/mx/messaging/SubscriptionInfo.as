package mx.messaging
{
   public class SubscriptionInfo
   {
      
      public var subtopic:String;
      
      public var selector:String;
      
      public var maxFrequency:uint;
      
      public function SubscriptionInfo(st:String, sel:String, mf:uint = 0)
      {
         super();
         this.subtopic = st;
         this.selector = sel;
         this.maxFrequency = mf;
      }
   }
}

