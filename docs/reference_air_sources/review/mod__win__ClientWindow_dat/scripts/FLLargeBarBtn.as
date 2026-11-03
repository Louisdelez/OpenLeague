package
{
   import mx.flash.UIMovieClip;
   
   [Embed(source="/_assets/assets.swf", symbol="symbol85")]
   public dynamic class FLLargeBarBtn extends UIMovieClip
   {
      
      public function FLLargeBarBtn()
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

