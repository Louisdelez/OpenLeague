package
{
   import flash.text.TextField;
   import mx.flash.UIMovieClip;
   
   [Embed(source="/_assets/assets.swf", symbol="symbol135")]
   public dynamic class pg_tooltip extends UIMovieClip
   {
      
      public var tooltip_header_text:TextField;
      
      public var tooltip_body_text:TextField;
      
      public function pg_tooltip()
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

