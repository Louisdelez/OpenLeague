package
{
   import flash.display.MovieClip;
   import flash.text.TextField;
   
   [Embed(source="/_assets/assets.swf", symbol="symbol7")]
   public class TextFieldMovieClip extends MovieClip implements IScreen
   {
      
      public var label_txt:TextField;
      
      private var _label:String;
      
      public function TextFieldMovieClip()
      {
         super();
      }
      
      public function init() : void
      {
      }
      
      public function set labelName(_label:String) : void
      {
         this._label = _label;
         this.label_txt.text = this._label;
      }
      
      public function get labelName() : String
      {
         return this._label;
      }
   }
}

