package
{
   import mx.core.IFlexModuleFactory;
   import mx.styles.CSSStyleDeclaration;
   import mx.styles.StyleManager;
   
   public class _winCloseButtonStyle
   {
      
      private static var _embed_css_win_close_up_png_3571958:Class = _winCloseButtonStyle__embed_css_win_close_up_png_3571958;
      
      private static var _embed_css_win_close_over_png_2136804488:Class = _winCloseButtonStyle__embed_css_win_close_over_png_2136804488;
      
      private static var _embed_css_win_close_down_png_807315180:Class = _winCloseButtonStyle__embed_css_win_close_down_png_807315180;
      
      public function _winCloseButtonStyle()
      {
         super();
      }
      
      public static function init(param1:IFlexModuleFactory) : void
      {
         var fbs:IFlexModuleFactory = param1;
         var style:CSSStyleDeclaration = StyleManager.getStyleDeclaration(".winCloseButton");
         if(!style)
         {
            style = new CSSStyleDeclaration();
            StyleManager.setStyleDeclaration(".winCloseButton",style,false);
         }
         if(style.defaultFactory == null)
         {
            style.defaultFactory = function():void
            {
               this.upSkin = _embed_css_win_close_up_png_3571958;
               this.overSkin = _embed_css_win_close_over_png_2136804488;
               this.downSkin = _embed_css_win_close_down_png_807315180;
            };
         }
      }
   }
}

