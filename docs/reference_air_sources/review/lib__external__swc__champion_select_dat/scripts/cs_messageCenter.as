package
{
   [Embed(source="/_assets/assets.swf", symbol="symbol64")]
   public dynamic class cs_messageCenter extends MessageCenter
   {
      
      public function cs_messageCenter()
      {
         super();
         addFrameScript(0,this.frame1,14,this.frame15);
      }
      
      internal function frame1() : *
      {
         stop();
      }
      
      internal function frame15() : *
      {
         gotoAndStop(1);
      }
   }
}

