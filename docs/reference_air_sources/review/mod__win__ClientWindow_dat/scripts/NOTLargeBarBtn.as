package
{
   import mx.flash.UIMovieClip;
   
   [Embed(source="/_assets/assets.swf", symbol="symbol239")]
   public dynamic class NOTLargeBarBtn extends UIMovieClip
   {
      
      public function NOTLargeBarBtn()
      {
         super();
         addFrameScript(0,this.frame1);
      }
      
      internal function frame1() : *
      {
         stop();
      }
   }
}

